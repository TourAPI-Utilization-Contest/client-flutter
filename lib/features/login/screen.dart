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

  final cGray = const Color(0xFFD1D3D9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 10),
        child: ClipPath(
          clipper: InvertedCornerClipper(arcRadius: 10),
          child: AppBar(
            title: Text('로그인'),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
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
                // 로그인
                // Form(
                //   key: _formKey, // Form 키 연결
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.stretch,
                //     children: [
                //       TextFormField(
                //         autofocus: true, // 자동 포커스
                //         controller: _idController,
                //         decoration: const InputDecoration(
                //           labelText: '아이디',
                //           border: OutlineInputBorder(),
                //           prefixIcon: Icon(Icons.person),
                //         ),
                //         validator: (value) {
                //           if (value == null || value.isEmpty) {
                //             return '아이디를 입력하세요';
                //           }
                //           if (!value.contains('@')) {
                //             return '이메일 형식으로 입력하세요';
                //           }
                //           return null;
                //         },
                //       ),
                //       SizedBox(height: 16),
                //       // PW 입력 필드
                //       TextFormField(
                //         controller: _pwController,
                //         obscureText: true, // 비밀번호 숨기기
                //         decoration: const InputDecoration(
                //           labelText: '비밀번호',
                //           border: OutlineInputBorder(),
                //           prefixIcon: Icon(Icons.lock),
                //         ),
                //         validator: (value) {
                //           if (value == null || value.isEmpty) {
                //             return '비밀번호를 입력하세요';
                //           }
                //           return null;
                //         },
                //       ),
                //       SizedBox(height: 16),
                //       // 로그인 버튼
                //       ElevatedButton(
                //         onPressed: () {
                //           if (_formKey.currentState!.validate()) {
                //             // 여기에 로그인 로직 추가
                //             print(
                //                 '로그인 시도: 이메일: ${_idController.text}, 비밀번호: ${_pwController.text}');
                //           }
                //         },
                //         child: const Text('로그인'),
                //       ),
                //       // 로그인 실패 시 메시지
                //       if (_failed)
                //         const Padding(
                //           padding: EdgeInsets.only(top: 8),
                //           child: Text(
                //             '로그인에 실패했습니다. 다시 시도해 주세요.',
                //             style: TextStyle(color: Colors.red),
                //           ),
                //         ),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 15),
                Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildLoginTextFormField(
                          hintText: 'Email',
                          isPassword: false,
                          controller: _idController,
                        ),
                        const SizedBox(height: 15),
                        buildLoginTextFormField(
                          hintText: 'Password',
                          isPassword: true,
                          controller: _pwController,
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              // print('로그인 버튼 클릭');
                              if (_formKey.currentState!.validate()) {
                                // 여기에 로그인 로직 추가
                                print(
                                    '로그인 시도: 이메일: ${_idController.text}, 비밀번호: ${_pwController.text}');
                                final result = await ServerWrapper.loginIdPw(
                                    _idController.text, _pwController.text);
                                if (!mounted) return;
                                if (result) {
                                  _failed = false;
                                } else {
                                  _failed = true;
                                }
                                setState(() {});
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 20),
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
                        if (_failed)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
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
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            print('비밀번호 찾기 버튼 클릭');
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
                    color: const Color(0xFFECECEC),
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
                    onPressed: () {
                      print('카카오 로그인 버튼 클릭');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 20),
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
    );
  }

  TextFormField buildLoginTextFormField({
    required String hintText,
    required isPassword,
    TextEditingController? controller,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      // autofocus: !isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: cGray,
          fontFamily: 'NotoSansKR',
          fontVariations: const [
            FontVariation('wght', 200.0),
          ],
        ),
        filled: true,
        fillColor: Color(0xFFF8F8F8),
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
          if (value == null || value.isEmpty) {
            return '비밀번호를 입력하세요';
          }
          return null;
        }
        if (value == null || value.isEmpty) {
          return '아이디를 입력하세요';
        }
        if (!value.contains('@')) {
          return '이메일 형식으로 입력하세요';
        }
        return null;
      },
    );
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
