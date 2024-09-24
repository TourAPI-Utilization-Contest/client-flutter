import 'package:flutter/material.dart';

class InfiniteTimeDial extends StatefulWidget {
  final double width; // 표시할 다이얼의 가로 크기
  final double height; // 표시할 다이얼의 세로 크기
  final double initialMinutesOffset; // 기준 시간 (분 단위)
  final void Function(double)? onTimeChanged; // 시간 변경 콜백

  InfiniteTimeDial(
      {required this.width,
      required this.height,
      required this.initialMinutesOffset,
      this.onTimeChanged});

  @override
  _InfiniteTimeDialState createState() => _InfiniteTimeDialState();
}

class _InfiniteTimeDialState extends State<InfiniteTimeDial> {
  double scrollOffsetMinutes = 0.0; // 현재 스크롤 위치 (분 단위)
  double tickSpacing = 20.0; // 눈금 사이의 간격 (픽셀 단위)
  double minutesPerTick = 10.0; // 눈금당 표시할 분

  @override
  void initState() {
    super.initState();
    // 초기 시간 오프셋 (분 단위로 설정)
    scrollOffsetMinutes = widget.initialMinutesOffset;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          // 스크롤 업데이트 (분 단위로 변환)
          scrollOffsetMinutes +=
              -details.delta.dx / tickSpacing * minutesPerTick;
          scrollOffsetMinutes %= 1440; // 24시간 (1440분) 기준으로 정규화
          widget.onTimeChanged?.call(scrollOffsetMinutes);
        });
      },
      child: CustomPaint(
        size: Size(widget.width, widget.height),
        painter: TimeDialPainter(
          scrollOffsetMinutes: scrollOffsetMinutes,
          tickSpacing: tickSpacing,
          minutesPerTick: minutesPerTick,
        ),
      ),
    );
  }
}

class TimeDialPainter extends CustomPainter {
  final double scrollOffsetMinutes; // 스크롤 위치 (분 단위)
  final double tickSpacing; // 눈금 사이의 거리 (픽셀 단위)
  final double minutesPerTick; // 눈금당 몇 분을 표시할지

  TimeDialPainter({
    required this.scrollOffsetMinutes,
    required this.tickSpacing,
    required this.minutesPerTick,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    TextPainter textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    var center = size.width / 2;
    var centerTime = scrollOffsetMinutes;
    var leftTime = centerTime - center / tickSpacing * minutesPerTick;
    var leftLow = leftTime - leftTime % minutesPerTick - minutesPerTick;
    for (int i = 0; i < size.width / tickSpacing + 2; i++) {
      var time = leftLow + i * minutesPerTick;
      var x = center + (time - centerTime) / minutesPerTick * tickSpacing;
      var height = time % 60 == 0 ? size.height * 0.5 : size.height * 0.75;
      canvas.drawLine(Offset(x, height), Offset(x, size.height), linePaint);
      if (time % 60 == 0) {
        String timeString = '${(time + 1440) % 1440 ~/ 60}:00';
        textPainter.text = TextSpan(
          text: timeString,
          style: TextStyle(color: Colors.black, fontSize: 16),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, height - textPainter.height),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
