import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tradule/common/section.dart';
import 'package:tradule/server_wrapper/server_wrapper.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  // Form 상태를 추적하기 위한 키
  final TextEditingController _idController = TextEditingController();

  final TextEditingController _pwController = TextEditingController();

  bool _failed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Section(
                title: '이메일 로그인',
                content: Form(
                  key: _formKey, // Form 키 연결
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        autofocus: true, // 자동 포커스
                        controller: _idController,
                        decoration: const InputDecoration(
                          labelText: '아이디',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '아이디를 입력하세요';
                          }
                          if (!value.contains('@')) {
                            return '이메일 형식으로 입력하세요';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      // PW 입력 필드
                      TextFormField(
                        controller: _pwController,
                        obscureText: true, // 비밀번호 숨기기
                        decoration: const InputDecoration(
                          labelText: '비밀번호',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '비밀번호를 입력하세요';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            print(
                                '로그인 시도: ID=${_idController.text}, PW=${_pwController.text}');
                            final result = await ServerWrapper.loginIdPw(
                                _idController.text, _pwController.text);
                            if (result) {
                              _failed = false;
                            } else {
                              _failed = true;
                            }
                            setState(() {});
                          }
                        },
                        child: Text('로그인'),
                      ),
                      SizedBox(height: 10),
                      if (_failed)
                        Center(
                          child: Text(
                            '로그인에 실패하였습니다. 아이디와 비밀번호를 확인하세요.',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('아직 회원이 아니신가요?'),
                          TextButton(
                            onPressed: () {
                              print('회원가입 버튼 클릭');
                            },
                            child: Text('회원가입'),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('비밀번호를 잊으셨나요?'),
                          TextButton(
                            onPressed: () {
                              print('비밀번호 찾기 버튼 클릭');
                            },
                            child: Text('비밀번호 찾기'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Section(
                title: '간편 로그인',
                content: Column(
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                          'assets/images/kakao_login_medium_narrow.svg'),
                      // onPressed: () => _login(context, ref),
                      onPressed: () => print('카카오 로그인'),
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
