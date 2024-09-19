import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:tradule/provider/auth_provider.dart';

final isLoadingProvider = StateProvider<bool>((ref) => false); // 로딩 상태 관리
final isCancelledProvider = StateProvider<bool>((ref) => false); // 취소 상태 관리

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isLoadingProvider); // 로딩 상태 읽기

    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                        'assets/images/kakao_login_medium_narrow.svg'),
                    onPressed: () => _login(context, ref),
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    focusColor: Colors.transparent,
                  ),
                ],
              ),
            ),
          ),
          // 로딩 인디케이터와 취소 버튼을 스택에 추가
          if (isLoading) ...[
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
                      ref.read(isLoadingProvider.notifier).state = false;
                      ref.read(isCancelledProvider.notifier).state = true;
                    },
                    child: Text('취소'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _login(BuildContext context, WidgetRef ref) async {
    ref.read(isLoadingProvider.notifier).state = true; // 로딩 시작
    ref.read(isCancelledProvider.notifier).state = false; // 취소 상태 초기화
    try {
      print(await KakaoSdk.origin);
      if (await isKakaoTalkInstalled()) {
        print('카카오톡 설치됨');
        try {
          await UserApi.instance.loginWithKakaoTalk();
          await _successLogin(context, ref);
        } catch (error) {
          if (error is PlatformException && error.code == 'CANCELED') {
            print('카카오톡 로그인 취소');
            return;
          }
          await _loginWithKakaoAccount(context, ref);
        }
      } else {
        print('카카오톡 미설치');
        await _loginWithKakaoAccount(context, ref);
      }
    } catch (error) {
      print('카카오 로그인 실패: $error');
    } finally {
      if (context.mounted) {
        ref.read(isLoadingProvider.notifier).state = false; // 로딩 종료
      }
    }
  }

  Future<void> _loginWithKakaoAccount(
      BuildContext context, WidgetRef ref) async {
    try {
      await UserApi.instance.loginWithKakaoAccount();
      await _successLogin(context, ref);
    } catch (error) {
      print('카카오 계정 로그인 실패2: $error');
    }
  }

  Future<void> _successLogin(BuildContext context, WidgetRef ref) async {
    if (!context.mounted) {
      return;
    }
    ref.read(isLoadingProvider.notifier).state = false; // 로딩 종료
    if (ref.read(isCancelledProvider)) {
      await UserApi.instance.logout();
      return;
    }
    final user = await UserApi.instance.me();
    if (!context.mounted) {
      return;
    }
    ref.read(userProvider.notifier).state = user;
    ref.read(isLoggedInProvider.notifier).state = true;
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushNamed(context, '/home');
    }
  }
}
