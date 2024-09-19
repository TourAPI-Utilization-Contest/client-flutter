import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

final isLoggedInProvider = StateProvider<bool>((ref) => false);
final userProvider = StateProvider<User?>((ref) => null);

final authInitializationProvider = FutureProvider<void>((ref) async {
  try {
    final user = await UserApi.instance.me();
    ref.read(userProvider.notifier).state = user;
    ref.read(isLoggedInProvider.notifier).state = true;
  } catch (e) {
    ref.read(isLoggedInProvider.notifier).state = false;
  }
  //딜레이 추가
  // await Future.delayed(const Duration(seconds: 1));
});
