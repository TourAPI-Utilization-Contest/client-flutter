import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

import 'map_style.dart';
import 'time_dial.dart';

class CustomBottomSheetMap extends StatefulWidget {
  @override
  _CustomBottomSheetMapState createState() => _CustomBottomSheetMapState();
}

class _CustomBottomSheetMapState extends State<CustomBottomSheetMap>
    with AutomaticKeepAliveClientMixin<CustomBottomSheetMap> {
  GoogleMapController? _mapController;
  double _bottomSheetHeight = 100; // 바텀 시트 초기 높이
  double _bottomSheetMinHeight = 100; // 바텀 시트 최소 높이
  double _timeDialHeight = 40; // 다이얼의 높이
  GlobalKey _mapKey = GlobalKey();
  String _cloudMapId = lightMapId; // 기본 스타일
  String? _style = aubergine;
  BitmapDescriptor _markerIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    _createCustomMarkerBitmap('Hello World', 2).then((BitmapDescriptor bitmap) {
      _markerIcon = bitmap;
    });
  }

  // 텍스트가 포함된 커스텀 마커 이미지 생성 (해상도 조절 가능)
  Future<BitmapDescriptor> _createCustomMarkerBitmap(
      String text, double scaleFactor) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    final double width = 150 * scaleFactor;
    final double height = 50 * scaleFactor;

    final paint = Paint()..color = Colors.black12;
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // 배경 그리기 (해상도 크기에 맞게)
    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, width, height), paint);

    // 텍스트 그리기 (스케일에 맞춰서)
    textPainter.text = TextSpan(
      text: text,
      style: TextStyle(
        fontSize: 20.0 * scaleFactor, // 스케일에 맞춘 폰트 크기
        color: Colors.white,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(10.0 * scaleFactor, 10.0 * scaleFactor));

    // 이미지 생성 (더 큰 해상도로)
    final img = await pictureRecorder
        .endRecording()
        .toImage(width.toInt(), height.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(
      data!.buffer.asUint8List(),
      imagePixelRatio: scaleFactor,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double mapHeight =
              constraints.maxHeight - _bottomSheetHeight - _timeDialHeight;
          return Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: mapHeight,
                child: GoogleMap(
                  key: _mapKey,
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  // padding: EdgeInsets.only(bottom: _bottomSheetHeight),
                  initialCameraPosition: CameraPosition(
                    target: LatLng(37.5662952, 126.9779451),
                    zoom: 12,
                  ),
                  // cloudMapId: '254d275a4bbfaf53',
                  // cloudMapId: _cloudMapId,
                  // style: _style,
                  // mapToolbarEnabled: true,
                  markers: {
                    Marker(
                      markerId: MarkerId('marker_1'),
                      icon: _markerIcon,
                      position: LatLng(37.5662952, 126.9779451),
                      draggable: false,
                      onDrag: (LatLng position) {
                        print('Marker position: $position');
                      },
                      infoWindow: InfoWindow(
                        title: '서울특별시청',
                        snippet: '서울특별시 중구 태평로1가 31',
                        anchor: Offset(0.5, 0.5),
                      ),
                    ),
                  },

                  polylines: {
                    Polyline(
                      polylineId: PolylineId('polyline_1'),
                      points: [
                        LatLng(37.5662952, 126.9779451),
                        LatLng(37.55, 126.7),
                        LatLng(37.6, 126.6),
                      ],
                      color: Colors.red,
                      width: 3,
                    ),
                  },
                ),
              ),
              // Positioned(//https://github.com/flutter/flutter/issues/73830 참고
              //   left: 0,
              //   right: 0, top: 0,
              //   height: 100, // 하단 20px의 높이 설정
              //   child: AbsorbPointer(
              //     // 하단 20px에서 모든 입력을 차단
              //     absorbing: true,
              //     child: Container(
              //       color: Colors.black26,
              //     ),
              //   ),
              // ),
              Positioned(
                bottom: _bottomSheetHeight,
                left: 0,
                child: InfiniteTimeDial(
                  initialMinutesOffset: 0,
                  width: constraints.maxWidth,
                  height: _timeDialHeight,
                  onTimeChanged: (double minutes) {
                    // print('Time changed: $minutes');
                  },
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
                      _bottomSheetHeight = _bottomSheetHeight.clamp(
                          _bottomSheetMinHeight, constraints.maxHeight / 2);
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

  @override
  bool get wantKeepAlive => true;
}
