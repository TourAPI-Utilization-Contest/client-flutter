import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _tryLogin() {
    if (_formKey.currentState!.validate()) {
      // 여기에 로그인 로직 추가
      print(
          '로그인 시도: 이메일: ${emailController.text}, 비밀번호: ${passwordController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListenableBuilder(
            listenable: Listenable.merge([
              emailController,
              passwordController,
            ]),
            builder: (context, child) {
              return AutofillGroup(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: emailController,
                      autofillHints: const [
                        AutofillHints.username,
                        AutofillHints.email,
                      ],
                      decoration: InputDecoration(
                        hintText: 'Email',
                        suffixIcon: Visibility(
                          visible: emailController.text.isNotEmpty,
                          child: GestureDetector(
                            onTap: () {
                              emailController.clear();
                            },
                            child: const Icon(Icons.close),
                          ),
                        ),
                        prefixIcon: const Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: passwordController,
                      autofillHints: const [
                        AutofillHints.password,
                      ],
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    // ElevatedButton(
                    //   onPressed: invalidForm()
                    //       ? null
                    //       : () {
                    //     controller.submit();
                    //   },
                    //   child: const Text('Submit'),
                    // ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
