import 'dart:math';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tradule/common/app_bar_blur.dart';
import 'package:tradule/common/login_text_form_field.dart';
import 'package:tradule/common/my_text_style.dart';
import 'package:tradule/common/section.dart';
import 'package:tradule/server_wrapper/server_wrapper.dart';
import 'package:tradule/common/color.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController(
    text: kDebugMode ? 'admin@tradule.com' : null,
  );
  final TextEditingController _pwController = TextEditingController(
    text: kDebugMode ? '1234' : null,
  );
  // final _focusNode = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  // bool _failed = false;
  LoginResult? _loginResult;
  bool _isFormValidateFailFlag = false;
  bool _emailValidateFlag = false;
  bool _passwordValidateFlag = false;
  final _emailKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();
  bool _isLoading = false;

  final cGray = const Color(0xFFD1D3D9);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBarBlur(
            title: const Text('로그인'),
            scrollController: _scrollController,
            clipper: const InvertedCornerClipper(arcRadius: 10),
            preferredSize: const Size.fromHeight(kToolbarHeight + 10),
          ),
          body: Center(
            child: SingleChildScrollView(
              clipBehavior: Clip.none,
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    // 로고
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/logo/tradule_text.svg',
                            width: 110,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "트래쥴과 함께\n여행을 계획해 보세요!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'NotoSansKR',
                              fontSize: 20,
                              color: Colors.black,
                              fontVariations: [
                                FontVariation('wght', 500.0),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LoginTextFormField(
                              key: const Key('email'),
                              formFieldKey: _emailKey,
                              hintText: 'Email',
                              isPassword: false,
                              focusNode: _focusNodeEmail,
                              controller: _idController,
                              onChanged: (value) {
                                if (!_emailValidateFlag) return;
                                _emailValidateFlag = false;
                                _loginResult = null;
                                _emailKey.currentState!.validate();
                                setState(() {});
                              },
                              onSubmitted: (_) {
                                _submitted(context: context);
                              },
                              validator: (value) {
                                if (!_emailValidateFlag) return null;
                                if (value == null || value.isEmpty) {
                                  if (!_isFormValidateFailFlag) {
                                    _isFormValidateFailFlag = true;
                                    _focusNodeEmail.requestFocus();
                                  }
                                  return '아이디를 입력하세요';
                                }
                                if (!value.contains('@')) {
                                  if (!_isFormValidateFailFlag) {
                                    _isFormValidateFailFlag = true;
                                    _focusNodeEmail.requestFocus();
                                  }
                                  return '이메일 형식으로 입력하세요';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            LoginTextFormField(
                              key: const Key('password'),
                              hintText: 'Password',
                              isPassword: true,
                              formFieldKey: _passwordKey,
                              focusNode: _focusNodePassword,
                              controller: _pwController,
                              onChanged: (value) {
                                if (!_passwordValidateFlag) return;
                                _passwordValidateFlag = false;
                                _loginResult = null;
                                _passwordKey.currentState!.validate();
                                setState(() {});
                              },
                              onSubmitted: (_) {
                                _submitted(context: context);
                              },
                              validator: (value) {
                                if (!_passwordValidateFlag) return null;
                                if (value == null || value.isEmpty) {
                                  if (!_isFormValidateFailFlag) {
                                    _isFormValidateFailFlag = true;
                                    _focusNodePassword.requestFocus();
                                  }
                                  return '비밀번호를 입력하세요';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  _submitted(context: context);
                                },
                                style: ElevatedButton.styleFrom(
                                  // padding: const EdgeInsets.symmetric(
                                  //     horizontal: 0, vertical: 20),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                ),
                                child: const Text(
                                  'sign in',
                                  style: TextStyle(
                                    fontFamily: 'NotoSansKR',
                                    color: Colors.white,
                                    fontVariations: [
                                      FontVariation('wght', 400.0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // if (_failed)
                            if (_loginResult != null && !_loginResult!.success)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  _loginResult?.message ??
                                      '로그인에 실패하였습니다. 아이디와 비밀번호를 확인하세요.',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: 12.0,
                                    fontFamily: 'NotoSansKR',
                                    fontVariations: const [
                                      FontVariation('wght', 400.0),
                                    ],
                                  ),
                                ),
                              ),
                            if (_loginResult != null &&
                                !_loginResult!.success &&
                                _loginResult!.needEmailVerification)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '이메일이 오지 않았다면 스팸 메일함을 확인하세요.',
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        fontSize: 12.0,
                                        fontFamily: 'NotoSansKR',
                                        fontVariations: const [
                                          FontVariation('wght', 400.0),
                                        ],
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        var auth = FirebaseAuth.instance;
                                        auth.currentUser!
                                            .sendEmailVerification();
                                      },
                                      child: Text(
                                        '이메일 재전송',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontSize: 12.0,
                                          fontFamily: 'NotoSansKR',
                                          fontVariations: const [
                                            FontVariation('wght', 200.0),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                // print('비밀번호 찾기 버튼 클릭');
                                // 이메일 입력 다이얼로그 표시
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    var emailController =
                                        TextEditingController();
                                    return AlertDialog(
                                      title: const Text('비밀번호 찾기'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            '가입 시 사용한 이메일을 입력하세요.',
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              fontFamily: 'NotoSansKR',
                                              fontVariations: [
                                                FontVariation('wght', 200.0),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          TextFormField(
                                            controller: emailController,
                                            decoration: InputDecoration(
                                              hintText: 'Email',
                                              hintStyle: TextStyle(
                                                color: cGray,
                                                fontFamily: 'NotoSansKR',
                                                fontVariations: const [
                                                  FontVariation('wght', 200.0),
                                                ],
                                              ),
                                              filled: true,
                                              fillColor:
                                                  const Color(0xFFF8F8F8),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                borderSide: BorderSide.none,
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 17.0,
                                                horizontal: 25.0,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          ElevatedButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              var result = await ServerWrapper
                                                  .sendPasswordResetEmail(
                                                      emailController.text);
                                              print(result.message);
                                              if (!context.mounted) return;
                                              if (!result.success) {
                                                print('비밀번호 찾기 실패');
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title:
                                                          const Text('비밀번호 찾기'),
                                                      content: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            result.message!,
                                                            style: myTextStyle(
                                                              fontSize: 12.0,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                '확인'),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                                return;
                                              }
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title:
                                                        const Text('비밀번호 찾기'),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Text(
                                                          '입력하신 이메일로 비밀번호 재설정 링크를 보냈습니다.',
                                                          style: TextStyle(
                                                            fontSize: 12.0,
                                                            fontFamily:
                                                                'NotoSansKR',
                                                            fontVariations: [
                                                              FontVariation(
                                                                  'wght',
                                                                  200.0),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              const Text('확인'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: const Text('전송'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Text(
                                'forgot your password?',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 12.0,
                                  fontFamily: 'NotoSansKR',
                                  fontVariations: const [
                                    FontVariation('wght', 200.0),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 1,
                      child: Container(
                        color: cGray4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'or',
                      style: TextStyle(
                        color: cGray,
                        fontSize: 16.0,
                        fontFamily: 'NotoSansKR',
                        fontVariations: const [
                          FontVariation('wght', 200.0),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          print('카카오 로그인 버튼 클릭');
                          _isLoading = true;
                          setState(() {});
                          _loginResult = await ServerWrapper.loginKakao();
                          if (!context.mounted) return;
                          if (_loginResult!.success) {
                            Navigator.pop(context);
                            ServerWrapper.getScheduleWithClear();
                          } else {
                            _loginResult = null;
                          }
                          _isLoading = false;
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          // padding: const EdgeInsets.symmetric(
                          //     horizontal: 0, vertical: 20),
                          backgroundColor: const Color(0xFFFEE500),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: SvgPicture.asset(
                            'assets/social/kakao_login.svg',
                            // width: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(
                            color: cGray,
                            fontSize: 12.0,
                            fontFamily: 'NotoSansKR',
                            fontVariations: const [
                              FontVariation('wght', 200.0),
                            ],
                          ),
                        ),
                        const SizedBox(width: 5),
                        TextButton(
                          onPressed: () {
                            print('회원가입 버튼 클릭');
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: Text(
                            'sign up',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 12.0,
                              fontFamily: 'NotoSansKR',
                              fontVariations: const [
                                FontVariation('wght', 200.0),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // 로딩 인디케이터와 취소 버튼을 스택에 추가
        if (_isLoading) ...[
          ModalBarrier(
            color: Colors.black.withOpacity(0.3),
            dismissible: false,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _isLoading = false;
                    setState(() {});
                  },
                  child: Text('취소'),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget buildLoginTextFormField({
    required String hintText,
    required isPassword,
    String? initialValue,
    TextEditingController? controller,
  }) {
    return TextFormField(
      key: isPassword ? _passwordKey : _emailKey,
      keyboardType: TextInputType.emailAddress,
      initialValue: initialValue,
      controller: controller,
      obscureText: isPassword,
      autofocus: !isPassword,
      focusNode: isPassword ? _focusNodePassword : _focusNodeEmail,
      onFieldSubmitted: (_) {
        _submitted(context: context);
      },
      onChanged: (_) {
        if (isPassword) {
          if (!_passwordValidateFlag) return;
          _passwordValidateFlag = false;
          // _failed = false;
          _loginResult = null;
          _passwordKey.currentState!.validate();
          setState(() {});
        } else {
          if (!_emailValidateFlag) return;
          _emailValidateFlag = false;
          // _failed = false;
          _loginResult = null;
          _emailKey.currentState!.validate();
          setState(() {});
        }
      },
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: cGray,
          fontFamily: 'NotoSansKR',
          fontVariations: const [FontVariation('wght', 200.0)],
        ),
        filled: true,
        fillColor: const Color(0xFFF8F8F8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 17.0,
          horizontal: 25.0,
        ),
      ),
      validator: (value) {
        if (isPassword) {
          if (!_passwordValidateFlag) return null;
          if (value == null || value.isEmpty) {
            if (!_isFormValidateFailFlag) {
              _isFormValidateFailFlag = true;
              _focusNodePassword.requestFocus();
            }
            return '비밀번호를 입력하세요';
          }
          return null;
        }
        if (!_emailValidateFlag) return null;
        if (value == null || value.isEmpty) {
          if (!_isFormValidateFailFlag) {
            _isFormValidateFailFlag = true;
            _focusNodeEmail.requestFocus();
          }
          return '아이디를 입력하세요';
        }
        if (!value.contains('@')) {
          if (!_isFormValidateFailFlag) {
            _isFormValidateFailFlag = true;
            _focusNodeEmail.requestFocus();
          }
          return '이메일 형식으로 입력하세요';
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    super.dispose();
  }

  void _submitted({required BuildContext context}) async {
    _isLoading = true;
    _isFormValidateFailFlag = false;
    _emailValidateFlag = true;
    _passwordValidateFlag = true;
    setState(() {});
    if (_formKey.currentState!.validate()) {
      // print('로그인 시도: 이메일: ${_idController.text}, 비밀번호: ${_pwController.text}');
      final result =
          await ServerWrapper.loginIdPw(_idController.text, _pwController.text);
      if (!context.mounted) return;
      if (result.success) {
        // _failed = false;
        _loginResult = result;
        Navigator.pop(context);
        ServerWrapper.getScheduleWithClear();
        setState(() {});
      } else {
        // _failed = true;
        _loginResult = result;
        _focusNodePassword.requestFocus();
        setState(() {});
      }
    }
    _isLoading = false;
    setState(() {});
  }
}

class InvertedCornerClipper extends CustomClipper<Path> {
  final double arcRadius;

  const InvertedCornerClipper({this.arcRadius = 10});

  @override
  Path getClip(Size size) {
    final path = Path();

    // 좌상단에서 시작
    path.lineTo(0, size.height);

    // 왼쪽 아래에 호 그리기
    path.arcToPoint(
      Offset(arcRadius, size.height - arcRadius),
      radius: Radius.circular(arcRadius),
      clockwise: true, // 시계 방향
    );

    // 오른쪽 아래에 호 그리기
    path.lineTo(size.width - arcRadius, size.height - arcRadius);
    path.arcToPoint(
      Offset(size.width, size.height),
      radius: Radius.circular(arcRadius),
      clockwise: true,
    );

    // 우상단으로 이동
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
