// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAWKkTPt-LYXJJ5rWrWjgH037D7l5aLTZo',
    appId: '1:514600973364:web:8d773019f319dc23cd4661',
    messagingSenderId: '514600973364',
    projectId: 'tradule-com',
    authDomain: 'tradule-com.firebaseapp.com',
    storageBucket: 'tradule-com.appspot.com',
    measurementId: 'G-FVE40W6B1V',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDKVGMG-8ACuUS-_-F8pEUFa5vNaJ-xNIQ',
    appId: '1:514600973364:android:25d7e009d4982ba9cd4661',
    messagingSenderId: '514600973364',
    projectId: 'tradule-com',
    storageBucket: 'tradule-com.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDxBvgOxdNpkJvde6ASNTI3XRioZVv6YhY',
    appId: '1:514600973364:ios:29a7d90379f49be3cd4661',
    messagingSenderId: '514600973364',
    projectId: 'tradule-com',
    storageBucket: 'tradule-com.appspot.com',
    iosBundleId: 'com.tradule.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDxBvgOxdNpkJvde6ASNTI3XRioZVv6YhY',
    appId: '1:514600973364:ios:38a9663a841d3388cd4661',
    messagingSenderId: '514600973364',
    projectId: 'tradule-com',
    storageBucket: 'tradule-com.appspot.com',
    iosBundleId: 'com.tradule.tradule',
  );

}