import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tradule/common/app_bar_blur.dart';
import 'package:tradule/common/color.dart';
import 'package:tradule/common/login_text_form_field.dart';
import 'package:tradule/common/my_text_field.dart';
import 'package:tradule/common/my_text_style.dart';
import 'package:tradule/common/section.dart';
import 'package:tradule/common/single_child_scroll_fade_view.dart';
import 'package:tradule/server_wrapper/server_wrapper.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormFieldState<String>> _nameKey =
      GlobalKey<FormFieldState<String>>();
  final FocusNode _focusNodeName = FocusNode();
  bool _nameValidateFlag = false;

  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormFieldState<String>> _emailKey =
      GlobalKey<FormFieldState<String>>();
  final FocusNode _focusNodeEmail = FocusNode();
  bool _emailValidateFlag = false;

  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final GlobalKey<FormFieldState<String>> _passwordKey =
      GlobalKey<FormFieldState<String>>();
  final FocusNode _focusNodePassword = FocusNode();
  bool _passwordValidateFlag = false;

  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormFieldState<String>> _passwordConfirmKey =
      GlobalKey<FormFieldState<String>>();
  final FocusNode _focusNodePasswordConfirm = FocusNode();

  bool _isFormValidateFailFlag = false;
  SignUpResult _signUpResult = SignUpResult(true);
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBarBlur(
            title: const Text('회원가입'),
            scrollController: _scrollController,
          ),
          body: Center(
            child: SingleChildScrollView(
              clipBehavior: Clip.none,
              controller: _scrollController,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  child: Column(
                    spacing: 24,
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

                      Column(
                        spacing: 16,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('기본 정보',
                              style: myTextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                LoginTextFormField(
                                  hintText: 'Nickname',
                                  isPassword: false,
                                  formFieldKey: _nameKey,
                                  focusNode: _focusNodeName,
                                  controller: _nameController,
                                  helperText: '다른 사용자에게 보여질 이름입니다',
                                  onSubmitted: (_) => onSubmitted(),
                                  onChanged: (value) {
                                    if (!_nameValidateFlag) return;
                                    _nameValidateFlag = false;
                                    _nameKey.currentState!.validate();
                                    setState(() {});
                                  },
                                  validator: (value) {
                                    if (!_nameValidateFlag) return null;
                                    if (value == null || value.isEmpty) {
                                      if (!_isFormValidateFailFlag) {
                                        _isFormValidateFailFlag = true;
                                        _focusNodeName.requestFocus();
                                      }
                                      return '닉네임은 비워둘 수 없어요!';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        spacing: 16,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('계정 정보',
                              style: myTextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              spacing: 8,
                              children: [
                                LoginTextFormField(
                                  key: const Key('email'),
                                  formFieldKey: _emailKey,
                                  hintText: 'Email',
                                  isPassword: false,
                                  focusNode: _focusNodeEmail,
                                  controller: _emailController,
                                  helperText: '가입 후 이메일로 인증 링크를 보내드립니다',
                                  onSubmitted: (_) => onSubmitted(),
                                  onChanged: (value) {
                                    if (!_emailValidateFlag) return;
                                    _emailValidateFlag = false;
                                    _emailKey.currentState!.validate();
                                    setState(() {});
                                  },
                                  // onSubmitted: (_) {
                                  //   _submitted(context: context);
                                  // },
                                  validator: (value) {
                                    if (!_emailValidateFlag) return null;
                                    if (value == null || value.isEmpty) {
                                      if (!_isFormValidateFailFlag) {
                                        _isFormValidateFailFlag = true;
                                        _focusNodeEmail.requestFocus();
                                      }
                                      return '이메일은 비워둘 수 없어요!';
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
                                const SizedBox(),
                                LoginTextFormField(
                                  hintText: 'Password',
                                  isPassword: true,
                                  formFieldKey: _passwordKey,
                                  focusNode: _focusNodePassword,
                                  controller: _passwordController,
                                  validator: null,
                                  onSubmitted: (_) => onSubmitted(),
                                  onChanged: (value) {
                                    if (!_passwordValidateFlag) return;
                                    _passwordValidateFlag = false;
                                    _passwordConfirmKey.currentState!
                                        .validate();
                                    setState(() {});
                                  },
                                ),
                                LoginTextFormField(
                                  hintText: 'Password Confirm',
                                  isPassword: true,
                                  formFieldKey: _passwordConfirmKey,
                                  focusNode: _focusNodePasswordConfirm,
                                  controller: _passwordConfirmController,
                                  helperText: '비밀번호는 6자 이상이어야 합니다',
                                  onSubmitted: (_) => onSubmitted(),
                                  onChanged: (value) {
                                    if (!_passwordValidateFlag) return;
                                    _passwordValidateFlag = false;
                                    // _loginResult = null;
                                    // _formKey.currentState!.validate();
                                    setState(() {});
                                  },
                                  validator: (value) {
                                    if (!_passwordValidateFlag) return null;
                                    if (_passwordController.text.isEmpty) {
                                      if (!_isFormValidateFailFlag) {
                                        _isFormValidateFailFlag = true;
                                        _focusNodePassword.requestFocus();
                                      }
                                      return '비밀번호는 비워둘 수 없어요!';
                                    }
                                    if (_passwordController.text.length < 6) {
                                      if (!_isFormValidateFailFlag) {
                                        _isFormValidateFailFlag = true;
                                        _focusNodePassword.requestFocus();
                                      }
                                      return '6자리 이상 입력해주세요!';
                                    }
                                    if (value == null || value.isEmpty) {
                                      if (!_isFormValidateFailFlag) {
                                        _isFormValidateFailFlag = true;
                                        _focusNodePasswordConfirm
                                            .requestFocus();
                                      }
                                      return '비밀번호를 한번 더 입력해주세요!';
                                    }
                                    if (value.length < 6) {
                                      if (!_isFormValidateFailFlag) {
                                        _isFormValidateFailFlag = true;
                                        _focusNodePasswordConfirm
                                            .requestFocus();
                                      }
                                      return '6자리 이상 입력해주세요!';
                                    }
                                    if (value != _passwordController.text) {
                                      if (!_isFormValidateFailFlag) {
                                        _isFormValidateFailFlag = true;
                                        _focusNodePasswordConfirm
                                            .requestFocus();
                                      }
                                      return '비밀번호가 일치하지 않습니다';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                        child: _signUpResult.success
                            ? null
                            : Text(
                                _signUpResult.message ?? '',
                                style: myTextStyle(
                                  fontSize: 14,
                                  color: cError,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                      ),
                      Row(
                        spacing: 8,
                        children: [
                          Flexible(
                            flex: 3,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ButtonStyle(
                                minimumSize: WidgetStateProperty.all(
                                  const Size(double.infinity, 50),
                                ),
                              ),
                              child: Text(
                                '돌아기기',
                                style: myTextStyle(
                                  fontSize: 14,
                                  color: cGray3,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 7,
                            child: ElevatedButton(
                              onPressed: onSubmitted,
                              // child: isEditing ? const Text('수정 완료') : const Text('일정 만들기'),
                              child: Text('가입 후 인증 메일 보내기',
                                  style: myTextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  )),
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  Theme.of(context).primaryColor,
                                ),
                                minimumSize: WidgetStateProperty.all(
                                  const Size(double.infinity, 50),
                                ),
                                overlayColor: WidgetStateProperty.all(
                                  Colors.white.withAlpha(50),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
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

  void onSubmitted() async {
    _isFormValidateFailFlag = false;
    _nameValidateFlag = true;
    _emailValidateFlag = true;
    _passwordValidateFlag = true;

    if (_formKey.currentState!.validate()) {
      _isLoading = true;
      setState(() {});
      try {
        // 회원가입 로직
        _signUpResult = await ServerWrapper.signUpIdPw(
          id: _emailController.text,
          pw: _passwordController.text,
          nickname: _nameController.text,
        );
        if (!mounted || !_isLoading) return;
        if (_signUpResult.success) {
          Navigator.pop(context);
          _showDialog();
        }
      } catch (e) {
        print('회원가입 실패');
      } finally {
        _isLoading = false;
        setState(() {});
      }
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('회원가입 완료'),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '이메일 인증 후 로그인해주세요!',
                style: myTextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.4,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '혹시, 이메일이 도착하지 않았나요?',
                style: myTextStyle(
                  color: cDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.4,
                  height: 1.3,
                ),
              ),
              Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '스팸 메일함',
                        style: myTextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.4,
                          height: 1.3,
                        ),
                      ),
                      TextSpan(
                        text: '을 확인해주세요',
                        style: myTextStyle(
                          color: cDark,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.4,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                  //스팸 글자 색상 변경
                  style: TextStyle(
                    color: cGray3,
                    fontSize: 12,
                    fontWeight: FontWeight.w200,
                    letterSpacing: 0.4,
                    height: 1.3,
                  )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('확인'),
            ),
          ],
          backgroundColor: Colors.white,
        );
      },
    );
  }
}
