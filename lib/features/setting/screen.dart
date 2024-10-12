import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tradule/server_wrapper/server_wrapper.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Setting Screen'),
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
      )),
    );
  }
}
