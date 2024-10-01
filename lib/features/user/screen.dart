import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tradule/server_wrapper/server_wrapper.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 정보'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '내 정보 화면',
            ),
            TextButton(
              child: Text('데이터 로컬 출력'),
              onPressed: () {
                var c = ServerWrapper.itineraryCubitMapCubit;
                for (var i in c.state.values) {
                  print(jsonEncode(i.state.toJson()));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
