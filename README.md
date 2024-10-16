# tradule

## 메모

`flutter pub run build_runner watch`
`dart run flutter_native_splash:create`
웹 CORS 끄기: `--web-browser-flag "--disable-web-security"`

### web build

`flutter build web --release --web-renderer html`

### iOS build

`flutter build ios --release`
`flutter build ipa --obfuscate --split-debug-info=./build/ios/debug-info`

### Android build

`flutter build apk --release`
`flutter build appbundle --release --obfuscate --split-debug-info=./build/android/debug-info`