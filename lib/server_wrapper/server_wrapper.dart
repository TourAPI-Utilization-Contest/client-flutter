import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'data/daily_itinerary_data.dart';
import 'data/movement_data.dart';
import 'data/place_data.dart';
import 'server_info.dart';
import 'data/user_data.dart';
import 'data/itinerary_data.dart';

class LoginResult {
  bool success;
  String? message;
  bool needEmailVerification;
  LoginResult(this.success, {this.message, this.needEmailVerification = false});
}

class SignUpResult {
  bool success;
  String? message;
  SignUpResult(this.success, {this.message});
}

class SendPasswordResetEmailResult {
  bool success;
  String? message;
  SendPasswordResetEmailResult(this.success, {this.message});
}

class ServerWrapper {
  static FirebaseFirestore firestore = FirebaseFirestore.instanceFor(
      app: Firebase.app(), databaseId: 'tradule-db');
  static FirebaseAuth auth = FirebaseAuth.instance;
  static bool _offlineAccount = false;
  static int _loginKind = 0; // 1: ID/PW, 2: Kakao
  static UserCubit userCubit = UserCubit();
  static String _accessToken = '';
  static String _refreshToken = '';
  static String _code = '';
  // static Map<String, ItineraryCubit> itineraryCubitMap = {}; // key: itineraryId
  static ItineraryCubitMapCubit itineraryCubitMapCubit =
      ItineraryCubitMapCubit();

  static Future<LoginResult> loginIdPw(String id, String pw) async {
    if (id == 'test@test' && pw == '1234') {
      _offlineAccount = true;
      _loginKind = 1;
      _testAccountLogin();
      return LoginResult(true);
    } else {
      final FirebaseAuth auth = FirebaseAuth.instance;
      try {
        if (id == "admin@tradule.com" && pw == "1234") pw = "tradule1234";
        //탈퇴한 계정인지 확인
        var isDeleted = await isAccountDeleted(id);
        if (isDeleted) {
          return LoginResult(false, message: '탈퇴한 계정입니다. (재가입 가능)');
        }
        await auth.signInWithEmailAndPassword(email: id, password: pw);
        print(auth.currentUser);
        if (auth.currentUser != null) {
          if (!auth.currentUser!.emailVerified && id != "admin@tradule.com") {
            return LoginResult(
              false,
              message: '이메일 인증을 완료해주세요.',
              needEmailVerification: true,
            );
          }
          _offlineAccount = false;
          _loginKind = 1;
          print(auth.currentUser!.uid);
          var loginUrl = Uri.parse('${serverUrl}api/oauth/login-test');
          var response = await http.post(
            loginUrl,
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'method': 'POST',
              'header': {'Content-Type': 'application/json'},
              'body': {
                "email": id,
                "password":
                    id == "admin@tradule.com" ? "1234" : auth.currentUser!.uid,
              }
            }),
          );
          if (response.statusCode == 200) {
            if (response.body[0] == '{') {
              return LoginResult(false, message: '메인 서버의 응답이 잘못되었습니다.');
            }
            var accessToken = "abeda";
            var memberId = response.body;
            return _getUser(
              accessToken: accessToken,
              memberId: memberId,
            );
          } else {
            return LoginResult(false, message: '메인 서버와 통신에 실패하였습니다.');
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          return LoginResult(false, message: '존재하지 않는 이메일입니다.');
        } else if (e.code == 'wrong-password') {
          return LoginResult(false, message: '비밀번호가 틀렸습니다.');
        } else if (e.code == 'invalid-email') {
          return LoginResult(false, message: '이메일 형식이 아닙니다.');
        } else if (e.code == 'invalid-credential') {
          return LoginResult(false, message: '로그인에 실패하였습니다. 아이디와 비밀번호를 확인하세요.');
        } else if (e.code == 'user-disabled') {
          return LoginResult(false, message: '차단된 계정입니다.');
        } else {
          return LoginResult(false, message: '알 수 없는 오류: $e');
        }
      } catch (e) {
        print(e);
        return LoginResult(false, message: '로그인에 실패하였습니다. 아이디와 비밀번호를 확인하세요.');
      }
      return LoginResult(false, message: '로그인에 실패하였습니다. 아이디와 비밀번호를 확인하세요.');
    }
  }

  static Future<SignUpResult> signUpIdPw(
      {required String id,
      required String pw,
      required String nickname}) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.createUserWithEmailAndPassword(email: id, password: pw);
      if (auth.currentUser != null) {
        var localPw = auth.currentUser!.uid;
        try {
          var r = await postRegister(id: id, pw: localPw, nickname: nickname);
          if (!r) throw Exception('회원가입에 실패하였습니다.');
          await auth.currentUser!.sendEmailVerification();
        } catch (e) {
          print(e);
          await auth.currentUser!.delete();
          return SignUpResult(false, message: '회원가입에 실패하였습니다.');
        }
        return SignUpResult(true);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        bool isDeleted = await isAccountDeleted(id);
        if (isDeleted) {
          reactivateAccount(id);
          FirebaseAuth.instance.sendPasswordResetEmail(email: id);
          return SignUpResult(false,
              message: '이미 가입된 이메일이므로 재가입 처리를 위한 이메일을 전송하였습니다.');
        } else {
          return SignUpResult(false, message: '이미 가입된 이메일입니다.');
        }
      } else if (e.code == 'weak-password') {
        return SignUpResult(false, message: '비밀번호가 너무 약합니다.');
      } else if (e.code == 'invalid-email') {
        return SignUpResult(false, message: '이메일 형식이 아닙니다.');
      } else {
        return SignUpResult(false, message: '알 수 없는 오류: $e');
      }
    } catch (e) {
      print(e);
      return SignUpResult(false, message: '회원가입에 실패하였습니다.');
    }
    return SignUpResult(false, message: '회원가입에 실패하였습니다.');
  }

  static void _testAccountLogin() {
    var userId = 1;
    var itineraryIds = [1, 2, 3];
    userCubit.setUser(UserData(
      id: userId,
      nickname: '트래쥴',
      email: 'test@test',
      itineraries: itineraryIds,
    ));
    itineraryCubitMapCubit.setItineraryCubitMap({
      itineraryIds[0]: ItineraryCubit(
        ItineraryData(
          id: itineraryIds[0],
          users: [userId],
          title: '서울 여행',
          startDate: DateTime(2024, 9, 29),
          endDate: DateTime(2024, 10, 2),
          iconColor: Colors.blue,
          dailyItineraryCubitList: [
            DailyItineraryCubit(DailyItineraryData(
              dailyItineraryId: itineraryIds[0],
              date: DateTime(2024, 9, 29),
              placeList: [
                PlaceCubit(PlaceData(
                  id: Random().nextInt(100000),
                  title: '우리 집',
                  address: '테스트 주소1',
                  latitude: 37.123456,
                  longitude: 127.123456,
                  iconColor: Colors.blue,
                  stayTime: const Duration(minutes: 10),
                )),
                PlaceCubit(PlaceData(
                  id: Random().nextInt(100000),
                  title: '경복궁',
                  address: '테스트 주소2',
                  latitude: 37.123456,
                  longitude: 127.123456,
                  iconColor: Colors.blue,
                  stayTime: const Duration(minutes: 120),
                )),
                PlaceCubit(PlaceData(
                  id: Random().nextInt(100000),
                  title: '런던베이글뮤지엄',
                  address: '테스트 주소2',
                  latitude: 37.123456,
                  longitude: 127.123456,
                  iconColor: Colors.blue,
                  stayTime: const Duration(minutes: 30),
                )),
                PlaceCubit(PlaceData(
                  id: Random().nextInt(100000),
                  title: '숙소',
                  address: '테스트 주소2',
                  latitude: 37.123456,
                  longitude: 127.123456,
                  iconColor: Colors.blue,
                  stayTime: const Duration(minutes: 30),
                )),
              ],
              movementList: [
                MovementCubit(MovementData(
                  duration: const Duration(minutes: 30),
                  distance: 1000,
                  method: '도보',
                  source: 'Google',
                  startTime: DateTime(2024, 9, 29, 9, 0),
                  endTime: DateTime(2024, 9, 29, 10, 0),
                )),
                MovementCubit(MovementData(
                  duration: const Duration(minutes: 30),
                  distance: 1000,
                  method: '지하철',
                  source: 'Google',
                  startTime: DateTime(2024, 9, 29, 10, 0),
                  endTime: DateTime(2024, 9, 29, 10, 30),
                )),
              ],
            )),
            DailyItineraryCubit(DailyItineraryData(
              dailyItineraryId: itineraryIds[0],
              date: DateTime(2024, 9, 30),
              placeList: [
                PlaceCubit(PlaceData(
                  id: Random().nextInt(100000),
                  title: '테스트 장소3',
                  address: '테스트 주소3',
                  latitude: 37.123456,
                  longitude: 127.123456,
                  iconColor: Colors.blue,
                )),
              ],
            )),
            DailyItineraryCubit(DailyItineraryData(
              dailyItineraryId: itineraryIds[0],
              date: DateTime(2024, 10, 1),
              placeList: [
                PlaceCubit(PlaceData(
                  id: Random().nextInt(100000),
                  title: '테스트 장소4',
                  address: '테스트 주소4',
                  latitude: 37.123456,
                  longitude: 127.123456,
                  iconColor: Colors.blue,
                )),
              ],
            )),
            DailyItineraryCubit(DailyItineraryData(
              dailyItineraryId: itineraryIds[0],
              date: DateTime(2024, 10, 2),
              placeList: [
                PlaceCubit(PlaceData(
                  id: Random().nextInt(100000),
                  title: '테스트 장소5',
                  address: '테스트 주소5',
                  latitude: 37.123456,
                  longitude: 127.123456,
                  iconColor: Colors.blue,
                )),
              ],
            )),
          ],
        ),
      ),
      itineraryIds[1]: ItineraryCubit(
        ItineraryData(
          id: itineraryIds[1],
          users: [userId],
          title: '맛집 탐방',
          startDate: DateTime(2024, 10, 14),
          endDate: DateTime(2024, 10, 16),
          iconPath: 'assets/icon/나침반.svg',
          iconColor: Colors.green,
        ),
      ),
      itineraryIds[2]: ItineraryCubit(
        ItineraryData(
          id: itineraryIds[2],
          users: [userId],
          title: '수학여행',
          startDate: DateTime(2024, 10, 20),
          endDate: DateTime(2024, 10, 22),
          iconColor: Colors.red,
        ),
      ),
    });
    //string encoding

    // // json으로 변환후 다시 객채화
    // for (var itineraryId in itineraryIds) {
    //   var s = json
    //       .encode(itineraryCubitMapCubit.state[itineraryId]!.state!.toJson());
    // }

    var a1 = json
        .encode(itineraryCubitMapCubit.state[itineraryIds[0]]!.state.toJson());
    // var a2 = json.decode(a1);
    var a2 = ItineraryData.fromJson(json.decode(a1));
    var a3 = json.encode(a2.toJson());
    print(a1);
    print(a3);

    offlineSet();
    print(json
        .encode(itineraryCubitMapCubit.state[itineraryIds[0]]!.state.toJson()));
  }

  static Future<LoginResult> autoLoginKakao() async {
    if (TargetPlatform.macOS == defaultTargetPlatform ||
        TargetPlatform.windows == defaultTargetPlatform ||
        TargetPlatform.linux == defaultTargetPlatform) {
      return LoginResult(false, message: '카카오톡 로그인은 모바일에서만 가능합니다.');
    }
    var token = await TokenManagerProvider.instance.manager.getToken();
    if (token != null) {
      _accessToken = token.accessToken;
      _refreshToken = token.refreshToken!;
      _offlineAccount = false;
      _loginKind = 2;
      return _getUser(accessToken: _accessToken, refreshToken: _refreshToken);
    }
    return LoginResult(false, message: '카카오톡 로그인에 실패하였습니다.');
  }

  static Future<LoginResult> loginKakao() async {
    final AuthCodeClient client = AuthCodeClient.instance;
    try {
      final api = UserApi.instance;
      final token = await (await isKakaoTalkInstalled()
          ? api.loginWithKakaoTalk()
          : api.loginWithKakaoAccount());
      // api.loginWithKakaoAccount();
      // String redirectUri =
      //     'http://ec2-3-104-73-228.ap-southeast-2.compute.amazonaws.com:8080/api/oauth/authenticate';
      // _code = await (await isKakaoTalkInstalled()
      //     ? client.authorizeWithTalk(
      //         redirectUri: redirectUri,
      //         webPopupLogin: true,
      //       )
      //     : client.authorize(
      //         redirectUri: redirectUri,
      //         webPopupLogin: true,
      //       ));
      // final token = await AuthApi.instance.issueAccessToken(
      //   authCode: _code,
      //   redirectUri: redirectUri,
      // );
      // final tokenResponseLow = await http.post(
      //   Uri.parse('${serverUrl}api/oauth/authenticate?code=$_code'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //   },
      //   body: json.encode({
      //     'method': 'GET',
      //   }),
      // );
      // var tokenResponseLowJson = json.decode(tokenResponseLow.body);
      // print(tokenResponseLowJson);
      // // OAuthToken()
      // var tokenResponse = AccessTokenResponse(
      //   tokenResponseLowJson['accessToken'],
      //   7199,
      //   tokenResponseLowJson['refreshToken'],
      //   null,
      //   null,
      //   "bearer",
      // );
      // var token = OAuthToken.fromResponse(tokenResponse);
      // token = OAuthToken.fromJson(json)
      final tokenResponseLow = await http.post(
        Uri.parse('${serverUrl}api/oauth/authenticate'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'method': 'GET',
          'header': {
            'access_token': token.accessToken,
            'refresh_token': token.refreshToken!,
            'member_id': (await api.me()).id.toString(),
          }
        }),
      );
      print(tokenResponseLow.body);
      await TokenManagerProvider.instance.manager.setToken(token);
      _accessToken = token.accessToken;
      _refreshToken = token.refreshToken!;

      _offlineAccount = false;
      _loginKind = 2;
      return _getUser(accessToken: _accessToken, refreshToken: _refreshToken);
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
      return LoginResult(false, message: '카카오톡 로그인에 실패하였습니다.');
    }
    // _testAccount = false;
    // _loginKind = 2;
    // return true;
  }

  static Future<bool> updateNickname(String nickname) async {
    if (_offlineAccount) {
      userCubit.updateNickname(nickname);
      return true;
    }
    var userUrl = Uri.parse('${serverUrl}api/oauth/user');
    var response = await http.post(
      userUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'method': 'PUT',
        'header': {
          'access_token': _accessToken,
          'refresh_token': _refreshToken,
          'member_id': userCubit.state!.id.toString(),
        },
        'body': {
          'nickname': nickname,
        },
      }),
    );
    if (response.statusCode == 200) {
      userCubit.updateNickname(nickname);
      return true;
    }
    return false;
  }

  static Future<String?> updatePassword(String password) async {
    var email = userCubit.state!.email;
    if (email == 'admin@tradule.com' || email == 'test@test') {
      return '관리자 계정은 비밀번호 변경이 불가능합니다.';
    }
    if (_offlineAccount) return '오프라인 계정은 비밀번호 변경이 불가능합니다.';
    if (_loginKind == 1) {
      try {
        await FirebaseAuth.instance.currentUser!.updatePassword(password);
        return null;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          return '비밀번호가 너무 약합니다.';
        } else {
          return '알 수 없는 오류: $e';
        }
      } catch (e) {
        print(e);
        return '비밀번호 변경에 실패하였습니다.';
      }
    } else if (_loginKind == 2) {
      return '카카오톡 로그인은 비밀번호 변경이 불가능합니다.';
    }
    return '알 수 없는 오류';
  }

  static bool isLogin() {
    return userCubit.state != null;
  }

  static bool isOfflineAccount() {
    return _offlineAccount;
  }

  static int getLoginKind() {
    return _loginKind;
  }

  static void logout() {
    if (_loginKind == 2) {
      UserApi.instance.logout();
      _accessToken = '';
      _refreshToken = '';
    } else if (_loginKind == 1) {
      FirebaseAuth.instance.signOut();
    }
    _offlineAccount = false;
    _loginKind = 0;
    userCubit.setUser(null);
    itineraryCubitMapCubit.setItineraryCubitMap({});
  }

  static UserData? getUser() {
    return userCubit.state;
  }

  // //임시 함수
  // static Future<List<String>> getEvents(int page) async {
  //   await Future.delayed(Duration(milliseconds: 500));
  //   return List.generate(2, (index) => '일정 제목 ${index + 1 + (page * 2)}');
  // }

  static Future<List<ItineraryCubit>> getAllItineraries() async {
    await Future.delayed(Duration(milliseconds: 500));
    return itineraryCubitMapCubit.state.values.toList();
  }

  // ------------------------- 서버 통신 -------------------------

  static Future<LoginResult> _getUser({
    required String accessToken,
    String refreshToken = '',
    String memberId = '',
    int recursionCount = 0,
  }) async {
    if (_offlineAccount) return LoginResult(true);
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    var userUrl = Uri.parse('${serverUrl}api/oauth/user');
    print('accessToken: $accessToken');
    var response = await http.post(
      userUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'method': 'GET',
        'header': {
          'access_token': accessToken,
          'refresh_token': refreshToken,
          'member_id': memberId,
        }
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      var user =
          UserData.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      userCubit.setUser(user);
      getMyPlaceList();
      return LoginResult(true);
    } else {
      if (3 < recursionCount) {
        return LoginResult(false, message: '사용자 정보를 불러오는데 실패하였습니다.');
      }
      return _getUser(
        accessToken: accessToken,
        refreshToken: refreshToken,
        memberId: memberId,
        recursionCount: recursionCount + 1,
      );
    }
  }

  static Future<bool> getScheduleWithClear({int recursionCount = 0}) async {
    if (_offlineAccount) return true;
    var scheduleUrl = Uri.parse('${serverUrl}api/schedule');
    var response = await http.post(
      scheduleUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'method': 'GET',
        'header': {
          'access_token': _accessToken,
          'refresh_token': _refreshToken,
          'member_id': userCubit.state!.id.toString(),
        }
      }),
    );
    if (200 <= response.statusCode && response.statusCode < 300) {
      itineraryCubitMapCubit.setItineraryCubitMap({});
      var scheduleList = json.decode(response.body)['scheduleList'];
      for (var schedule in scheduleList) {
        var itinerary = ItineraryData(
          id: schedule['id'],
          users: [userCubit.state!.id],
          title: schedule['title'],
          startDate: DateTime.parse(schedule['startsAt']),
          endDate: DateTime.parse(schedule['endsAt']),
          iconColor: Color(schedule['color']),
          iconPath: schedule['icon'],
          dailyItineraryCubitList: [],
        );
        itineraryCubitMapCubit.addItineraryCubit(ItineraryCubit(itinerary));
      }
      return true;
    } else {
      if (3 < recursionCount) {
        return false;
      }
      return getScheduleWithClear(recursionCount: recursionCount + 1);
    }
  }

  static Future<bool> getScheduleDetailWithClear(ItineraryCubit itinerary,
      {int recursionCount = 0}) async {
    if (_offlineAccount) return true;
    var scheduleUrl = Uri.parse(
        '${serverUrl}api/schedule/${itinerary.state.id}?contains-user=false');
    var response = await http.post(
      scheduleUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'method': 'GET',
        'header': {
          'access_token': _accessToken,
          'refresh_token': _refreshToken,
          'member_id': userCubit.state!.id.toString(),
        }
      }),
    );
    if (200 <= response.statusCode && response.statusCode < 300) {
      itinerary.clearDailyItineraryCubitList();
      var schedule = json.decode(response.body);
      var details = schedule['details'];
      for (var i = 0; i < details.length; i++) {
        var detail = details[i];
        DailyItineraryCubit dailyItineraryCubit;
        var id = detail['id'];
        var detail2 = json.decode(detail['detail']);
        try {
          dailyItineraryCubit =
              DailyItineraryCubit(DailyItineraryData.fromJson(detail2).copyWith(
            dailyItineraryId: id,
          ));
          // print(detail2);
          // print(detail2['movementList']);
          // print(json.encode(detail2['movementList'][0]['details']).length);
          print(detail2['placeList']);
        } catch (e) {
          print(e);
          dailyItineraryCubit =
              DailyItineraryCubit(DailyItineraryData.initial().copyWith(
            dailyItineraryId: id,
          ));
        }
        itinerary.addDailyItineraryCubit(dailyItineraryCubit);
      }
      return true;
    } else {
      if (3 < recursionCount) return false;
      return getScheduleDetailWithClear(itinerary,
          recursionCount: recursionCount + 1);
    }
  }

  static Future<int?> postSchedule(ItineraryCubit itineraryCubit,
      {int recursionCount = 0}) async {
    if (_offlineAccount) return Random().nextInt(100000);
    var itinerary = itineraryCubit.state;
    var scheduleUrl = Uri.parse('${serverUrl}api/schedule');
    var response = await http.post(
      scheduleUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'method': 'POST',
        'header': {
          'Content-Type': 'application/json',
          'access_token': _accessToken,
          'refresh_token': _refreshToken,
          'member_id': userCubit.state!.id.toString(),
        },
        'body': {
          'title': itinerary.title,
          'startsAt': itinerary.startDate.toIso8601String(),
          'endsAt': itinerary.endDate.toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
          'color': itinerary.iconColor.value,
          'icon': itinerary.iconPath,
        },
      }),
    );
    if (200 <= response.statusCode && response.statusCode < 300) {
      return int.parse(response.body);
    } else {
      if (3 < recursionCount) return null;
      return postSchedule(itineraryCubit, recursionCount: recursionCount + 1);
    }
  }

  static Future<int?> postScheduleDetail(
      int itineraryId, DailyItineraryCubit dailyItineraryCubit,
      {int recursionCount = 0}) async {
    if (_offlineAccount) return Random().nextInt(100000);
    var dailyItinerary = dailyItineraryCubit.state;
    var scheduleUrl = Uri.parse('${serverUrl}api/schedule/$itineraryId');
    var response = await http.post(
      scheduleUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'method': 'POST',
        'header': {
          'Content-Type': 'application/json',
          'access_token': _accessToken,
          'refresh_token': _refreshToken,
          'member_id': userCubit.state!.id.toString(),
        },
        'body': {
          'detail': json.encode(dailyItinerary.toJson()),
        },
      }),
    );
    if (200 <= response.statusCode && response.statusCode < 300) {
      return int.parse(response.body);
    } else {
      if (3 < recursionCount) return null;
      return postScheduleDetail(itineraryId, dailyItineraryCubit,
          recursionCount: recursionCount + 1);
    }
  }

  static Future<bool> deleteSchedule(ItineraryCubit itineraryCubit,
      {int recursionCount = 0}) async {
    if (_offlineAccount) return true;
    var itinerary = itineraryCubit.state;
    var scheduleUrl = Uri.parse('${serverUrl}api/schedule/${itinerary.id}');
    var response = await http.post(
      scheduleUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'method': 'DELETE',
        'header': {
          'Content-Type': 'application/json',
          'access_token': _accessToken,
          'refresh_token': _refreshToken,
          'member_id': userCubit.state!.id.toString(),
        },
      }),
    );
    if (200 <= response.statusCode && response.statusCode < 300) {
      return true;
    } else {
      if (3 < recursionCount) return false;
      return deleteSchedule(itineraryCubit, recursionCount: recursionCount + 1);
    }
  }

  static Future<bool> deleteScheduleDetail(
      int itineraryId, DailyItineraryCubit dailyItineraryCubit,
      {int recursionCount = 0}) async {
    if (_offlineAccount) return true;
    var dailyItinerary = dailyItineraryCubit.state;
    var scheduleUrl = Uri.parse(
        '${serverUrl}api/schedule/$itineraryId/${dailyItinerary.dailyItineraryId}');
    var response = await http.post(
      scheduleUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'method': 'DELETE',
        'header': {
          'Content-Type': 'application/json',
          'access_token': _accessToken,
          'refresh_token': _refreshToken,
          'member_id': userCubit.state!.id.toString(),
        },
      }),
    );
    if (200 <= response.statusCode && response.statusCode < 300) {
      return true;
    } else {
      if (3 < recursionCount) return false;
      return deleteScheduleDetail(itineraryId, dailyItineraryCubit,
          recursionCount: recursionCount + 1);
    }
  }

  static Future<bool> putSchedule(ItineraryCubit itineraryCubit,
      {int recursionCount = 0}) async {
    if (_offlineAccount) return true;
    var itinerary = itineraryCubit.state;
    var scheduleUrl = Uri.parse('${serverUrl}api/schedule/${itinerary.id}');
    var response = await http.post(
      scheduleUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'method': 'PUT',
        'header': {
          'Content-Type': 'application/json',
          'access_token': _accessToken,
          'refresh_token': _refreshToken,
          'member_id': userCubit.state!.id.toString(),
        },
        'body': {
          'title': itinerary.title,
          'startsAt': itinerary.startDate.toIso8601String(),
          'endsAt': itinerary.endDate.toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
          'color': itinerary.iconColor.value,
          'icon': itinerary.iconPath,
        },
      }),
    );
    if (200 <= response.statusCode && response.statusCode < 300) {
      return true;
    } else {
      if (3 < recursionCount) return false;
      return putSchedule(itineraryCubit, recursionCount: recursionCount + 1);
    }
  }

  static Future<bool> putScheduleDetail(
      int itineraryId, DailyItineraryCubit dailyItineraryCubit,
      {int recursionCount = 0}) async {
    if (_offlineAccount) return true;
    var dailyItinerary = dailyItineraryCubit.state;
    var scheduleUrl = Uri.parse(
        '${serverUrl}api/schedule/$itineraryId/${dailyItinerary.dailyItineraryId}');
    var response = await http.post(
      scheduleUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'method': 'PUT',
        'header': {
          'Content-Type': 'application/json',
          'access_token': _accessToken,
          'refresh_token': _refreshToken,
          'member_id': userCubit.state!.id.toString(),
        },
        'body': {
          'detail': json.encode(dailyItinerary.toJson()),
        },
      }),
    );
    if (200 <= response.statusCode && response.statusCode < 300) {
      return true;
    } else {
      if (3 < recursionCount) return false;
      return putScheduleDetail(itineraryId, dailyItineraryCubit,
          recursionCount: recursionCount + 1);
    }
  }

  static Future<bool> putMyPlaceList({int recursionCount = 0}) async {
    if (_offlineAccount) return true;
    // UserCubit.state!.myPlaceList;
    List<PlaceData> places = userCubit.state!.places.values.toList();
    var scheduleUrl = Uri.parse('${serverUrl}api/oauth/user');
    var response = await http.post(
      scheduleUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'method': 'PUT',
        'header': {
          // 'Content-Type': 'application/json',
          'access_token': _accessToken,
          'refresh_token': _refreshToken,
          'member_id': userCubit.state!.id.toString(),
        },
        'body': places,
      }),
    );
    if (200 <= response.statusCode && response.statusCode < 300) {
      return true;
    } else {
      if (3 < recursionCount) return false;
      return putMyPlaceList(recursionCount: recursionCount + 1);
    }
  }

  static Future<bool> getMyPlaceList({int recursionCount = 0}) async {
    if (_offlineAccount) return true;
    var scheduleUrl = Uri.parse('${serverUrl}api/oauth/location');
    var response = await http.post(
      scheduleUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'method': 'GET',
        'header': {
          'Content-Type': 'application/json',
          'access_token': _accessToken,
          'refresh_token': _refreshToken,
          'member_id': userCubit.state!.id.toString(),
        },
      }),
    );
    if (200 <= response.statusCode && response.statusCode < 300) {
      print(response.body);
      ServerWrapper.userCubit.setPlaceWithClear(response.body);
      return true;
    } else {
      if (3 < recursionCount) return false;
      return getMyPlaceList(recursionCount: recursionCount + 1);
    }
  }

  static Future<bool> postRegister({
    required String id,
    required String pw,
    required String nickname,
    int recursionCount = 0,
  }) async {
    var registerUrl = Uri.parse('${serverUrl}api/oauth/register');
    var response = await http.post(
      registerUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'method': 'POST',
        'header': {'Content-Type': 'application/json'},
        'body': {
          "email": id,
          "password": pw,
          "nickname": nickname,
        }
      }),
    );
    if (200 <= response.statusCode && response.statusCode < 300) {
      return true;
    }
    var responseJson = json.decode(response.body);
    if (responseJson['code'] == -421) {
      //이미 가입된 이메일
      return true;
    } else {
      if (3 < recursionCount) return false;
      return postRegister(
          id: id,
          pw: pw,
          nickname: nickname,
          recursionCount: recursionCount + 1);
    }
  }

  static Future<bool> deleteUser() async {
    if (_offlineAccount) return true;

    //일정 삭제
    for (var itineraryCubit in itineraryCubitMapCubit.state.values) {
      deleteSchedule(itineraryCubit);
    }

    //내 장소 삭제
    // userCubit.state!.places.clear();
    userCubit.setUser(userCubit.state!.copyWith(places: {}));
    putMyPlaceList();

    if (_loginKind == 2) {
      await UserApi.instance.unlink();
    }

    if (_loginKind == 1) {
      await markAccountAsDeleted(FirebaseAuth.instance.currentUser!.email!);
    }

    logout();
    return true;
  }

  static Future<SendPasswordResetEmailResult> sendPasswordResetEmail(
      String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return SendPasswordResetEmailResult(true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return SendPasswordResetEmailResult(false, message: '가입되지 않은 이메일입니다.');
      } else if (e.code == 'user-not-found') {
        return SendPasswordResetEmailResult(false, message: '가입되지 않은 이메일입니다.');
      } else {
        return SendPasswordResetEmailResult(false, message: '알 수 없는 오류: $e');
      }
    } catch (e) {
      print(e);
      return SendPasswordResetEmailResult(false,
          message: '비밀번호 재설정 이메일 전송에 실패하였습니다.');
    }
  }

  // ------------------------- 파이어 스토어 -------------------------
  static Future<void> markAccountAsDeleted(String email) async {
    await firestore.collection('users').doc(email).set({
      'isDeleted': true, // 탈퇴 계정으로 설정
    });
  }

  static Future<void> reactivateAccount(String email) async {
    await firestore.collection('users').doc(email).set({
      'isDeleted': false, // 계정을 다시 활성화
    });
  }

  static Future<bool> isAccountDeleted(String email) async {
    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(email).get();

    if (userDoc.exists && userDoc.data() != null) {
      return userDoc['isDeleted'] ?? false; // 탈퇴 상태 확인
    }

    return false; // 기본값으로 탈퇴되지 않은 상태 반환
  }
}

class ItineraryCubitMapCubit extends Cubit<Map<int, ItineraryCubit>> {
  ItineraryCubitMapCubit() : super({});

  void setItineraryCubitMap(Map<int, ItineraryCubit> itineraryCubitMap) {
    emit(itineraryCubitMap);
  }

  void addItineraryCubit(ItineraryCubit itineraryCubit) {
    int itineraryId = itineraryCubit.state.id;
    var newMap = Map<int, ItineraryCubit>.from(state);
    newMap[itineraryId] = itineraryCubit;
    emit(newMap);
    // print('addItineraryCubit: $itineraryId');
  }

  void removeItineraryCubit(ItineraryCubit itineraryCubit) {
    var itineraryId = itineraryCubit.state.id;
    var newMap = Map<int, ItineraryCubit>.from(state);
    newMap.remove(itineraryId);
    emit(newMap);
    // emit({...state}..remove(itineraryId));
    // print('removeItineraryCubit: $itineraryId');
  }
}

void offlineSet() {
  var s =
      """{"id":1,"users":[1],"title":"서울 여행","description":null,"startDate":"2024-09-29T00:00:00.000","endDate":"2024-10-02T00:00:00.000","iconPath":null,"iconColor":4280391411,"dailyItineraryCubitList":[{"dailyItineraryId":1,"date":"2024-09-29T00:00:00.000","placeList":[{"id":11548,"title":"우리 집","address":"테스트 주소1","latitude":37.123456,"longitude":127.123456,"stayTime":10,"visitTime":null,"description":null,"phoneNumber":null,"homepage":null,"tag":null,"imageUrl":null,"thumbnailUrl":null,"iconColor":4280391411},{"id":126508,"title":"경복궁","address":"서울특별시 종로구 사직로 161","latitude":37.5788222356,"longitude":126.9769930325,"stayTime":0,"visitTime":null,"description":null,"phoneNumber":null,"homepage":null,"tag":null,"imageUrl":"http://tong.visitkorea.or.kr/cms/resource/33/2678633_image2_1.jpg","thumbnailUrl":"http://tong.visitkorea.or.kr/cms/resource/33/2678633_image3_1.jpg","iconColor":4288475135},{"id":2809117,"title":"런던베이글뮤지엄","address":"서울특별시 종로구 북촌로4길 20 연화빌딩","latitude":37.5792251324,"longitude":126.9862171806,"stayTime":0,"visitTime":null,"description":null,"phoneNumber":null,"homepage":null,"tag":null,"imageUrl":"","thumbnailUrl":"","iconColor":4288475135},{"id":44726,"title":"숙소","address":"테스트 주소2","latitude":37.123456,"longitude":127.123456,"stayTime":30,"visitTime":null,"description":null,"phoneNumber":null,"homepage":null,"tag":null,"imageUrl":null,"thumbnailUrl":null,"iconColor":4280391411}],"movementList":[{"startTime":"1970-01-01T00:00:00.000","endTime":"1970-01-01T00:00:00.000","duration":0,"minDuration":null,"maxDuration":null,"distance":0,"startLatitude":null,"startLongitude":null,"endLatitude":null,"endLongitude":null,"method":"work","source":"unknown","details":[]},{"startTime":"2024-10-10T16:00:08.426","endTime":"2024-10-10T16:17:03.426","duration":1015,"minDuration":null,"maxDuration":null,"distance":1529,"startLatitude":null,"startLongitude":null,"endLatitude":null,"endLongitude":null,"method":"TRANSIT","source":"Google","details":[{"duration":403,"distance":402,"path":"srjdFee_fWvSiJ","method":"WALK","source":"Google"},{"duration":344,"distance":860,"path":"{}idFop_fWYu@OqBGaB?i@ZyDT{EPyAEoAgAmEq@wBcCuFQc@Io@Wo@a@_BKw@Ca@@k@","method":"TRANSIT","source":"Google"},{"duration":268,"distance":267,"path":"qhjdFiiafWsKlI","method":"WALK","source":"Google"}]},{"startTime":"1970-01-01T00:00:00.000","endTime":"1970-01-01T00:00:00.000","duration":0,"minDuration":null,"maxDuration":null,"distance":0,"startLatitude":null,"startLongitude":null,"endLatitude":null,"endLongitude":null,"method":"work","source":"unknown","details":[]}]},{"dailyItineraryId":1,"date":"2024-09-30T00:00:00.000","placeList":[{"id":65049,"title":"테스트 장소3","address":"테스트 주소3","latitude":37.123456,"longitude":127.123456,"stayTime":0,"visitTime":null,"description":null,"phoneNumber":null,"homepage":null,"tag":null,"imageUrl":null,"thumbnailUrl":null,"iconColor":4280391411}],"movementList":[]},{"dailyItineraryId":1,"date":"2024-10-01T00:00:00.000","placeList":[{"id":1926,"title":"테스트 장소4","address":"테스트 주소4","latitude":37.123456,"longitude":127.123456,"stayTime":0,"visitTime":null,"description":null,"phoneNumber":null,"homepage":null,"tag":null,"imageUrl":null,"thumbnailUrl":null,"iconColor":4280391411}],"movementList":[]},{"dailyItineraryId":1,"date":"2024-10-02T00:00:00.000","placeList":[{"id":83937,"title":"테스트 장소5","address":"테스트 주소5","latitude":37.123456,"longitude":127.123456,"stayTime":0,"visitTime":null,"description":null,"phoneNumber":null,"homepage":null,"tag":null,"imageUrl":null,"thumbnailUrl":null,"iconColor":4280391411}],"movementList":[]}]}""";
  ServerWrapper.itineraryCubitMapCubit.state[1]!
      .setItinerary(ItineraryData.fromJson(json.decode(s)));
}
