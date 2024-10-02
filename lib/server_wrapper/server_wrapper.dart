import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'data/daily_itinerary_data.dart';
import 'data/place_data.dart';
import 'server_info.dart';
import 'data/user_data.dart';
import 'data/itinerary_data.dart';

class ServerWrapper {
  static bool _testAccount = false;
  static int _loginKind = 0; // 1: ID/PW, 2: Kakao
  static UserCubit userCubit = UserCubit();
  // static Map<String, ItineraryCubit> itineraryCubitMap = {}; // key: itineraryId
  static ItineraryCubitMapCubit itineraryCubitMapCubit =
      ItineraryCubitMapCubit();

  static Future<bool> loginIdPw(String id, String pw) async {
    if (id == 'test@test' && pw == '1234') {
      _testAccount = true;
      _loginKind = 1;
      _testAccountLogin();
      return true;
    } else {
      _testAccount = false;
      return false;
    }
  }

  static void _testAccountLogin() {
    var userId = 'test@test';
    var itineraryIds = ['1', '2', '3'];
    userCubit.setUser(UserData(
      id: userId,
      name: '테스터',
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
                  id: Random().nextInt(100000).toString(),
                  title: '우리 집',
                  address: '테스트 주소1',
                  latitude: 37.123456,
                  longitude: 127.123456,
                  iconColor: Colors.blue,
                  stayTime: const Duration(minutes: 10),
                )),
                PlaceCubit(PlaceData(
                  id: Random().nextInt(100000).toString(),
                  title: '경복궁',
                  address: '테스트 주소2',
                  latitude: 37.123456,
                  longitude: 127.123456,
                  iconColor: Colors.blue,
                  stayTime: const Duration(minutes: 120),
                )),
                PlaceCubit(PlaceData(
                  id: Random().nextInt(100000).toString(),
                  title: '런던베이글뮤지엄',
                  address: '테스트 주소2',
                  latitude: 37.123456,
                  longitude: 127.123456,
                  iconColor: Colors.blue,
                  stayTime: const Duration(minutes: 30),
                )),
                PlaceCubit(PlaceData(
                  id: Random().nextInt(100000).toString(),
                  title: '숙소',
                  address: '테스트 주소2',
                  latitude: 37.123456,
                  longitude: 127.123456,
                  iconColor: Colors.blue,
                  stayTime: const Duration(minutes: 30),
                )),
              ],
            )),
            DailyItineraryCubit(DailyItineraryData(
              dailyItineraryId: itineraryIds[0],
              date: DateTime(2024, 9, 30),
              placeList: [
                PlaceCubit(PlaceData(
                  id: Random().nextInt(100000).toString(),
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
                  id: Random().nextInt(100000).toString(),
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
                  id: Random().nextInt(100000).toString(),
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
          iconPath: 'assets/icon/나침판.svg',
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

    Set();
    print(json
        .encode(itineraryCubitMapCubit.state[itineraryIds[0]]!.state.toJson()));
  }

  static Future<bool> loginKakao() async {
    _testAccount = false;
    _loginKind = 2;
    return true;
  }

  static bool isLogin() {
    return userCubit.state != null;
  }

  static bool isTestAccount() {
    return _testAccount;
  }

  static int getLoginKind() {
    return _loginKind;
  }

  static void logout() {
    _testAccount = false;
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
}

class ItineraryCubitMapCubit extends Cubit<Map<String, ItineraryCubit>> {
  ItineraryCubitMapCubit() : super({});

  void setItineraryCubitMap(Map<String, ItineraryCubit> itineraryCubitMap) {
    emit(itineraryCubitMap);
  }

  void addItineraryCubit(ItineraryCubit itineraryCubit) {
    var itineraryId = itineraryCubit.state!.id;
    emit({...state, itineraryId: itineraryCubit});
    print('addItineraryCubit: $itineraryId');
    // TODO: 서버로 전송
  }
}

void Set() {
  var s =
      """{"id":"1","users":["test@test"],"title":"테스트 일정","description":null,"startDate":"2024-09-29T00:00:00.000","endDate":"2024-10-02T00:00:00.000","iconPath":null,"iconColor":4280391411,"dailyItineraryCubitList":[{"dailyItineraryId":"1","date":"2024-09-29T00:00:00.000","placeList":[{"id":"126508","title":"경복궁","address":"서울특별시 종로구 사직로 161","latitude":37.5788222356,"longitude":126.9769930325,"stayTime":0,"description":null,"phoneNumber":null,"homepage":null,"tag":null,"imageUrl":"http://tong.visitkorea.or.kr/cms/resource/33/2678633_image2_1.jpg","thumbnailUrl":"http://tong.visitkorea.or.kr/cms/resource/33/2678633_image3_1.jpg","iconColor":4288475135},{"id":"11548","title":"우리 집","address":"테스트 주소1","latitude":37.123456,"longitude":127.123456,"stayTime":10,"description":null,"phoneNumber":null,"homepage":null,"tag":null,"imageUrl":null,"thumbnailUrl":null,"iconColor":4280391411},{"id":"98819","title":"경복궁","address":"테스트 주소2","latitude":37.123456,"longitude":127.123456,"stayTime":120,"description":null,"phoneNumber":null,"homepage":null,"tag":null,"imageUrl":null,"thumbnailUrl":null,"iconColor":4280391411},{"id":"60075","title":"런던베이글뮤지엄","address":"테스트 주소2","latitude":37.123456,"longitude":127.123456,"stayTime":30,"description":null,"phoneNumber":null,"homepage":null,"tag":null,"imageUrl":null,"thumbnailUrl":null,"iconColor":4280391411},{"id":"44726","title":"숙소","address":"테스트 주소2","latitude":37.123456,"longitude":127.123456,"stayTime":30,"description":null,"phoneNumber":null,"homepage":null,"tag":null,"imageUrl":null,"thumbnailUrl":null,"iconColor":4280391411}]},{"dailyItineraryId":"1","date":"2024-09-30T00:00:00.000","placeList":[{"id":"65049","title":"테스트 장소3","address":"테스트 주소3","latitude":37.123456,"longitude":127.123456,"stayTime":0,"description":null,"phoneNumber":null,"homepage":null,"tag":null,"imageUrl":null,"thumbnailUrl":null,"iconColor":4280391411}]},{"dailyItineraryId":"1","date":"2024-10-01T00:00:00.000","placeList":[{"id":"1926","title":"테스트 장소4","address":"테스트 주소4","latitude":37.123456,"longitude":127.123456,"stayTime":0,"description":null,"phoneNumber":null,"homepage":null,"tag":null,"imageUrl":null,"thumbnailUrl":null,"iconColor":4280391411}]},{"dailyItineraryId":"1","date":"2024-10-02T00:00:00.000","placeList":[{"id":"83937","title":"테스트 장소5","address":"테스트 주소5","latitude":37.123456,"longitude":127.123456,"stayTime":0,"description":null,"phoneNumber":null,"homepage":null,"tag":null,"imageUrl":null,"thumbnailUrl":null,"iconColor":4280391411}]}]}""";
  ServerWrapper.itineraryCubitMapCubit.state['1']!
      .setItinerary(ItineraryData.fromJson(json.decode(s)));
}
