import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:tradule/common/app_bar_blur.dart';
import 'package:tradule/common/color.dart';
import 'package:tradule/common/global_value.dart';
import 'package:tradule/common/my_text_field.dart';
import 'package:tradule/common/my_text_style.dart';
import 'package:tradule/server_wrapper/server_info.dart';
import 'package:tradule/server_wrapper/server_wrapper.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool _changeNickname = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _nicknameController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBlur(
        title: const Text('내 정보'),
        scrollController: _scrollController,
        // clipper: const InvertedCornerClipper(arcRadius: 10),
        // preferredSize: const Size.fromHeight(kToolbarHeight + 10),
      ),
      body: Center(
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(17.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 30,
              children: <Widget>[
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(54),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      color: cGray4,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Stack(
                        children: [
                          Center(
                            child: SvgPicture.asset(
                              'assets/logo/tradule_text.svg',
                              height: 20,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFFADB0BB),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          // 프로필(썸내일) 이미지
                          if (ServerWrapper.isLogin() &&
                              ServerWrapper.userCubit.state!.profileUrl != null)
                            Image.network(
                              kIsWeb
                                  ? proxyImageUrl +
                                      ServerWrapper.userCubit.state!.profileUrl!
                                  : ServerWrapper.userCubit.state!.profileUrl!,
                              width: double.infinity,
                              height: double.infinity,
                              // width: 54,
                              // height: 54,
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  // 이미지 로딩이 완료되면 이미지를 보여줌
                                  return child;
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!_changeNickname)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 4,
                        children: [
                          Text(ServerWrapper.getUser()?.nickname ?? '익명',
                              style: myTextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              )),
                          Text(
                            '님',
                            style: myTextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _changeNickname = true;
                          });
                        },
                        child: Text('닉네임 변경'),
                      ),
                    ],
                  ),
                if (_changeNickname)
                  Padding(
                    padding: const EdgeInsets.all(2.5),
                    child: MyTextFormField(
                      autoFocus: true,
                      controller: TextEditingController(
                          text: ServerWrapper.getUser()?.nickname ?? ''),
                      hintText: ServerWrapper.getUser()?.nickname ?? '',
                      labelText: '닉네임을 입력해주세요',
                      suffixToolTip: '취소',
                      suffixOnPressed: () {
                        setState(() {
                          _changeNickname = false;
                        });
                      },
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          ServerWrapper.userCubit.updateNickname(value);
                          setState(() {
                            _changeNickname = false;
                          });
                        }
                      },
                    ),
                  ),
                Form(
                  key: _formKey,
                  child: Column(
                    spacing: 10,
                    children: [
                      MyTextFormField(
                        controller: TextEditingController(
                            text: ServerWrapper.getUser()?.email ?? ''),
                        hintText: ServerWrapper.getUser()?.email ?? '',
                        labelText: '이메일',
                        enabled: false,
                      ),
                      //비밀번호 변경
                      MyTextFormField(
                        controller: _passwordController,
                        hintText: '새 비밀번호',
                        labelText:
                            '비밀번호 변경${ServerWrapper.getLoginKind() == 2 ? ' (카카오 로그인 사용자는 비밀번호 변경이 불가능합니다.)' : ''}',
                        passwordMode: true,
                        enabled: ServerWrapper.getLoginKind() != 2,
                        onSubmitted: (_) => onSubmitted(),
                        onChanged: (value) {
                          // if (value.isNotEmpty) {
                          setState(() {});
                          // }
                        },
                      ),
                      if (_passwordController.text.isNotEmpty)
                        MyTextFormField(
                          controller: _passwordConfirmController,
                          hintText: '새 비밀번호 확인',
                          labelText: '새 비밀번호 확인',
                          helperText: '6자리 이상 입력해주세요.',
                          passwordMode: true,
                          onSubmitted: (_) => onSubmitted(),
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return '비밀번호가 일치하지 않습니다.';
                            }
                            return null;
                          },
                        ),
                    ],
                  ),
                ),
                Row(
                  spacing: 8,
                  children: [
                    Flexible(
                      flex: 3,
                      child: TextButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            mainTabController!.animateTo(1);
                          }
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
                        child: Text('저장하기',
                            style: myTextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('회원탈퇴'),
                          content: const Text('정말로 탈퇴하시겠습니까?'),
                          backgroundColor: Colors.white,
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('취소'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                var email = ServerWrapper.getUser()?.email;
                                if (email == 'admin@tradule.com' ||
                                    email == 'test@test') {
                                  toastification.show(
                                    context: context,
                                    type: ToastificationType.error,
                                    style: ToastificationStyle.fillColored,
                                    title: Text("회원 탈퇴 오류"),
                                    description: Text("관리자 계정은 탈퇴할 수 없습니다."),
                                    alignment: Alignment.center,
                                    autoCloseDuration:
                                        const Duration(seconds: 3),
                                    icon: Icon(Iconsax.alarm_copy),
                                    borderRadius: BorderRadius.circular(12.0),
                                    dragToClose: true,
                                    applyBlurEffect: true,
                                    showProgressBar: false,
                                    // boxShadow: lowModeShadow,
                                  );
                                  return;
                                }
                                ServerWrapper.deleteUser();
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                } else {
                                  mainTabController!.animateTo(1);
                                }
                              },
                              child: const Text('확인'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  //글자 색 변경
                  style: ButtonStyle(
                    overlayColor: WidgetStateProperty.all(
                      Colors.red.withAlpha(20),
                    ),
                    foregroundColor: WidgetStateProperty.resolveWith(
                      (states) {
                        if (states.contains(WidgetState.hovered)) {
                          return Colors.red.shade900;
                        }
                        return cGray3;
                      },
                    ),
                  ),
                  child: Text(
                    '회원탈퇴',
                    style: myTextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: cGray3,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onSubmitted() async {
    if (ServerWrapper.getLoginKind() != 2 &&
        _passwordController.text.isNotEmpty &&
        _formKey.currentState!.validate()) {
      var result = await ServerWrapper.updatePassword(_passwordController.text);
      if (result != null) {
        toastification.show(
          context: context,
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
          title: Text("비밀번호 변경 오류"),
          description: Text(result),
          alignment: Alignment.center,
          autoCloseDuration: const Duration(seconds: 3),
          icon: Icon(Iconsax.alarm_copy),
          borderRadius: BorderRadius.circular(12.0),
          dragToClose: true,
          applyBlurEffect: true,
          showProgressBar: false,
        );
        return;
      }
      toastification.show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
        title: Text("비밀번호 변경 완료"),
        description: Text("비밀번호가 변경되었습니다."),
        alignment: Alignment.center,
        autoCloseDuration: const Duration(seconds: 3),
        icon: Icon(Iconsax.alarm_copy),
        borderRadius: BorderRadius.circular(12.0),
        dragToClose: true,
        applyBlurEffect: true,
        showProgressBar: false,
      );
    }
  }
}
