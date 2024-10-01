import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tradule/common/color.dart';
import 'package:tradule/common/my_text_style.dart';

import 'package:tradule/server_wrapper/data/itinerary_data.dart';

import 'map_style.dart';
import 'time_dial.dart';

class ItineraryEditor extends StatefulWidget {
  final ItineraryCubit? itineraryCubit;

  const ItineraryEditor({
    super.key,
    this.itineraryCubit,
  });

  @override
  _ItineraryEditorState createState() => _ItineraryEditorState();
}

class _ItineraryEditorState extends State<ItineraryEditor>
    with AutomaticKeepAliveClientMixin<ItineraryEditor> {
  GoogleMapController? _mapController;
  double _bottomSheetHeight = 100; // 바텀 시트 초기 높이
  double _bottomSheetMinHeight = 100; // 바텀 시트 최소 높이
  GlobalKey _mapKey = GlobalKey();
  String _cloudMapId = lightMapId; // 기본 스타일
  String? _style = aubergine;
  BitmapDescriptor _markerIcon = BitmapDescriptor.defaultMarker;
  DateTime _mapTime = DateTime.now();

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
          double mapHeight = constraints.maxHeight - _bottomSheetHeight;
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
                  cloudMapId: _cloudMapId,
                  style: _style,
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
                    // color: Colors.white,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: const Offset(0, 2),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // 헤더
                        Column(
                          children: [
                            // 슬라이더
                            Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: FractionallySizedBox(
                                  widthFactor: 0.15,
                                  child: Container(
                                    height: 2.67,
                                    color: cGray4,
                                  ),
                                ),
                              ),
                            ),
                            // 날짜 보기
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '전체보기',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: const Color(0xFF4C5364),
                                    letterSpacing: 0.25,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '2021년 10월 1일',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: const Color(0xFF4C5364),
                                        letterSpacing: 0.25,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '금요일',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: const Color(0xFF4C5364),
                                    letterSpacing: 0.25,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
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
              // 뒤로가기 버튼
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 1,
                    right: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: const Offset(0, 2),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: IconButton(
                    // color: Colors.white,
                    icon: SvgPicture.asset(
                      'assets/icon/jam_chevron_left.svg',
                      // colorFilter:
                      //     ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Positioned.fill(
                top: 0,
                child: Row(
                  //상단 가운데
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      // child: Container(
                      //   color: Colors.white,
                      //   child: InfiniteTimeDial(
                      //     initialMinutesOffset: 0,
                      //     width: constraints.maxWidth,
                      //     height: 20,
                      //     onTimeChanged: (double minutes) {
                      //       // print('Time changed: $minutes');
                      //     },
                      //   ),
                      child: Container(
                        width: 200,
                        height: 40,
                        // color: Colors.white,
                        child: Builder(builder: (context) {
                          var textStyle = myTextStyle(
                            fontSize: 16,
                            color: const Color(0xFF4C5364),
                            letterSpacing: 0.25,
                            fontWeight: FontWeight.w500,
                          );
                          return TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Colors.white,
                              ),
                            ),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  '${_mapTime.hour % 12}',
                                  style: textStyle,
                                ),
                                Text(
                                  '${_mapTime.minute}',
                                  style: textStyle,
                                ),
                                Text(
                                  _mapTime.hour < 12 ? 'AM' : 'PM',
                                  style: textStyle,
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
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
