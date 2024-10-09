import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tradule/server_wrapper/server_wrapper.dart';

import 'api_key.dart';
import 'theme.dart';
// import 'package:tradule/home/home_screen.dart';
// import 'package:tradule/login/login_screen.dart';
import 'package:tradule/provider/auth_provider.dart';
import 'package:tradule/features/home/screen.dart';
import 'package:tradule/features/login/screen_legacy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // GoogleFonts.config.allowRuntimeFetching = false;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  // await GoogleFonts.pendingFonts([
  //   GoogleFonts.notoSansKr(),
  // ]);

  Intl.defaultLocale = 'ko_KR';
  await initializeDateFormatting('ko_KR', null);

  KakaoSdk.init(
    nativeAppKey: kakaoNativeAppKey,
    javaScriptAppKey: kakaoJavascriptKey,
  );

  if (kDebugMode) {
    ServerWrapper.loginIdPw('test@test', '1234');
  }

  runApp(const ProviderScope(child: Tradule()));
}

class Tradule extends StatelessWidget {
  const Tradule({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tradule',
      theme: ThemeData(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        colorScheme: MaterialTheme.lightScheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff0ED2F7),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            // fontWeight: FontWeight.bold,
          ),
        ),
        fontFamily: 'NotoSansKR',
        textTheme: addWghtTextTheme(Theme.of(context).textTheme),
      ),
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        '/home': (context) => HomePage(),
        '/login': (context) => LoginScreen(),
      },
    );
  }

  static TextTheme addWghtTextTheme(TextTheme textTheme) {
    return TextTheme(
      displayLarge: addWght(textStyle: textTheme.displayLarge),
      displayMedium: addWght(textStyle: textTheme.displayMedium),
      displaySmall: addWght(textStyle: textTheme.displaySmall),
      headlineLarge: addWght(textStyle: textTheme.headlineLarge),
      headlineMedium: addWght(textStyle: textTheme.headlineMedium),
      headlineSmall: addWght(textStyle: textTheme.headlineSmall),
      titleLarge: addWght(textStyle: textTheme.titleLarge),
      titleMedium: addWght(textStyle: textTheme.titleMedium),
      titleSmall: addWght(textStyle: textTheme.titleSmall),
      bodyLarge: addWght(textStyle: textTheme.bodyLarge),
      bodyMedium: addWght(textStyle: textTheme.bodyMedium),
      bodySmall: addWght(textStyle: textTheme.bodySmall),
      labelLarge: addWght(textStyle: textTheme.labelLarge),
      labelMedium: addWght(textStyle: textTheme.labelMedium),
      labelSmall: addWght(textStyle: textTheme.labelSmall),
    );
  }

  static TextStyle? addWght({TextStyle? textStyle}) {
    if (textStyle == null) return null;
    double weight = 400;
    if (textStyle.fontWeight != null) {
      weight = textStyle.fontWeight!.index * 100.0;
    }
    return textStyle.copyWith(
      fontVariations: [FontVariation('wght', weight)],
    );
  }
}
