import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

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
      name: '테스트 유저',
      email: 'test@test',
      itineraries: itineraryIds,
    ));
    itineraryCubitMapCubit.setItineraryCubitMap({
      itineraryIds[0]: ItineraryCubit(
        ItineraryData(
          id: itineraryIds[0],
          users: [userId],
          title: '테스트 일정',
          startDate: DateTime(2024, 9, 29),
          endDate: DateTime(2024, 10, 3),
          iconColor: Colors.blue,
        ),
      ),
      itineraryIds[1]: ItineraryCubit(
        ItineraryData(
          id: itineraryIds[1],
          users: [userId],
          title: '테스트 일정2',
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
          title: '테스트 일정3',
          startDate: DateTime(2024, 10, 20),
          endDate: DateTime(2024, 10, 22),
          iconColor: Colors.red,
        ),
      ),
    });
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
