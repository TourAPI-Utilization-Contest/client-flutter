import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'api_key.dart';
import 'package:tradule/home/home_screen.dart';
import 'package:tradule/login/login_screen.dart';
import 'package:tradule/provider/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  KakaoSdk.init(
    nativeAppKey: kakaoNativeAppKey,
    javaScriptAppKey: kakaoJavascriptKey,
  );

  runApp(const ProviderScope(child: Tradule()));
}

class Tradule extends StatelessWidget {
  const Tradule({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tradule',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomeScreen(),
      routes: <String, WidgetBuilder>{
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
