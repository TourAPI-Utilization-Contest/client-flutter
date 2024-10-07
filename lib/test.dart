import 'dart:ui';
import 'package:flutter/material.dart';

class GradualBlurExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 배경 이미지 또는 컬러
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logo/symbol_icon3.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // 점진적 블러를 위한 BackdropFilter와 ShaderMask 조합
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                // imageFilter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      // center: Alignment.center,
                      // radius: 0.5,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black,
                        Colors.black.withOpacity(0),
                      ],
                      stops: [0, 1],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstOut,
                  child: Container(
                    width: 300,
                    height: 300,
                    color: Colors.transparent,
                    child: Image(
                      image: AssetImage('assets/logo/symbol_icon3.png'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: GradualBlurExample()));
