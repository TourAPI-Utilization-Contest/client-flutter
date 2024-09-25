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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Column(
                  children: [
                    Text(
                      "ABCD",
                      style: TextStyle(
                        // fontFamily: 'NotoSansKR',
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "ABCD",
                      style: TextStyle(
                        // fontFamily: 'NotoSansKR',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "ABCD",
                      style: TextStyle(
                        // fontFamily: 'NotoSansKR',
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        fontVariations: [
                          FontVariation('wght', 900.0),
                        ],
                      ),
                    ),
                    Text(
                      "트레쥴과 함께\n여행을 계획해 보세요!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        // fontFamily: 'NotoSansKR',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        // fontVariations: [
                        //   FontVariation('wght', 100.0),
                        // ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: FontWeight.values
                          .map(
                            (weight) => Text(
                              '트레쥴과 함께 $weight',
                              style: TextStyle(
                                fontFamily: 'NotoSansKR',
                                fontSize: 20,
                                // fontWeight: weight,
                                fontVariations: [
                                  FontVariation('wght',
                                      ((weight.index + 1) * 100).toDouble())
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
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
