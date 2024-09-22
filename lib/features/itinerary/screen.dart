import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomBottomSheetMap extends StatefulWidget {
  @override
  _CustomBottomSheetMapState createState() => _CustomBottomSheetMapState();
}

class _CustomBottomSheetMapState extends State<CustomBottomSheetMap> {
  GoogleMapController? _mapController;
  double _bottomSheetHeight = 50; // 바텀 시트 초기 높이
  double _timeDialHeight = 40; // 다이얼의 높이

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double mapHeight =
              constraints.maxHeight - _bottomSheetHeight - _timeDialHeight;

          return Stack(
            children: [
              // 지도 부분
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: mapHeight,
                child: GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  // padding: EdgeInsets.only(bottom: _bottomSheetHeight),
                  initialCameraPosition: CameraPosition(
                    target: LatLng(37.5662952, 126.9779451),
                    zoom: 12,
                  ),
                ),
              ),
              Positioned(
                bottom: _bottomSheetHeight,
                left: 0,
                child: InfiniteTimeDial(
                  initialMinutesOffset: 0,
                  width: constraints.maxWidth,
                  height: _timeDialHeight,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    setState(() {
                      _bottomSheetHeight -= details.delta.dy;
                      if (_bottomSheetHeight < 50) _bottomSheetHeight = 50;
                      if (_bottomSheetHeight > constraints.maxHeight / 2) {
                        _bottomSheetHeight = constraints.maxHeight / 2;
                      }
                    });
                  },
                  child: Container(
                    height: _bottomSheetHeight,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          height: 20,
                          color: Colors.grey[300],
                          child: Center(
                            child: Icon(Icons.drag_handle),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.all(8),
                            children: [
                              Center(
                                child: Text(
                                  '상세 정보',
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                              ListTile(
                                title: Text('정보 1'),
                              ),
                              ListTile(
                                title: Text('정보 2'),
                              ),
                              ListTile(
                                title: Text('정보 3'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class InfiniteTimeDial extends StatefulWidget {
  final double width; // 표시할 다이얼의 가로 크기
  final double height; // 표시할 다이얼의 세로 크기
  final double initialMinutesOffset; // 기준 시간 (분 단위)

  InfiniteTimeDial(
      {required this.width,
      required this.height,
      required this.initialMinutesOffset});

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

    // 중앙 눈금 위치에서 기준 시간을 기준으로 눈금을 그릴 첫 위치 계산
    double centerPosition = size.width / 2.0;

    // 눈금 시작 위치를 기준으로 스크롤된 분만큼 보정 (offsetFromReference를 반영하여 첫 눈금 위치 보정)
    double referenceMinutes =
        (scrollOffsetMinutes ~/ minutesPerTick) * minutesPerTick;
    double firstTickOffset =
        -((scrollOffsetMinutes % minutesPerTick) / minutesPerTick) *
            tickSpacing;

    // 화면의 왼쪽에서 오른쪽까지 눈금 그리기
    var x_max = size.width + tickSpacing;
    for (double x = firstTickOffset; x <= x_max; x += tickSpacing) {
      double currentMinutes = (referenceMinutes +
              (x - firstTickOffset) / tickSpacing * minutesPerTick) %
          1440;

      if (currentMinutes < 0) {
        currentMinutes += 1440; // 음수가 될 경우 1440분으로 순환
      }

      // 시간을 시:분 형식으로 계산
      int hours = currentMinutes ~/ 60;
      int minutes = (currentMinutes % 60).toInt();

      // 눈금 그리기 (정시에 긴 눈금)
      double tickHeight =
          (minutes == 0) ? size.height * 0.5 : size.height * 0.75;
      canvas.drawLine(Offset(x, tickHeight), Offset(x, size.height), linePaint);

      // 시간 표시 (정시에만 시간 텍스트 표시)
      if (minutes == 0) {
        String timeString = "$hours:00";

        textPainter.text = TextSpan(
          text: timeString,
          style: TextStyle(color: Colors.black, fontSize: 16),
        );
        textPainter.layout();
        textPainter.paint(canvas,
            Offset(x - textPainter.width / 2, tickHeight - textPainter.height));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // 스크롤이 변하면 다시 그리기
  }
}
