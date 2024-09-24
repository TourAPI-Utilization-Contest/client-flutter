import 'package:flutter/material.dart';

import 'server_info.dart';
import 'data/user_data.dart';
import 'data/itinerary_data.dart';

class ServerWrapper {
  static bool _login = false;
  static bool _testAccount = false;
  static int _loginKind = 0; // 1: ID/PW, 2: Kakao
  static UserData? _user;

  static Future<bool> loginIdPw(String id, String pw) async {
    if (id == 'test@test' && pw == '1234') {
      _login = true;
      _testAccount = true;
      _loginKind = 1;
      _user = UserData(
        id: 'test',
        name: '테스트 유저',
      );
      return true;
    } else {
      _login = false;
      _testAccount = false;
      return false;
    }
  }

  static Future<bool> loginKakao() async {
    _login = true;
    _testAccount = false;
    _loginKind = 2;
    return true;
  }

  static bool isLogin() {
    return _login;
  }

  static bool isTestAccount() {
    return _testAccount;
  }

  static int getLoginKind() {
    return _loginKind;
  }

  static void logout() {
    _login = false;
    _testAccount = false;
    _loginKind = 0;
  }

  static UserData? getUser() {
    return _user;
  }

  //임시 함수
  static Future<List<String>> getEvents(int page) async {
    await Future.delayed(Duration(milliseconds: 500));
    return List.generate(2, (index) => '일정 제목 ${index + 1 + (page * 2)}');
  }
}
