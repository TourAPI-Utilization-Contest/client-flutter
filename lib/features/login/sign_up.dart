import 'package:flutter/material.dart';
import 'package:tradule/common/app_bar_blur.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBlur(
        title: const Text('회원가입'),
        scrollController: _scrollController,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/login');
          },
          child: const Text('Go to Login'),
        ),
      ),
    );
  }
}
