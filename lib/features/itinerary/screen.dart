import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tradule/common/color.dart';
import 'package:tradule/common/my_text_style.dart';
import 'package:tradule/server_wrapper/data/daily_itinerary_data.dart';
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
      style: myTextStyle(
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
                    child: Material(
                      child: Column(
                        children: [
                          _Header(),
                          TabBarView(
                            children: [
                              // DailyItineraryEditor(
                              //   dailyItineraryCubit: widget.itineraryCubit,
                              // ),
                              for (var dailyItinerary in widget.itineraryCubit!
                                  .state.itinerary.dailyItineraries)
                                DailyItineraryEditor(
                                  dailyItineraryCubit: widget.itineraryCubit,
                                  dailyItinerary: dailyItinerary,
                                ),
                            ],
                          ),
                          // Expanded(
                          //   child: ListView(
                          //     padding: EdgeInsets.all(8),
                          //     children: [
                          //       Center(
                          //         child: Text(
                          //           '상세 정보',
                          //           style: TextStyle(fontSize: 24),
                          //         ),
                          //       ),
                          //       ListTile(
                          //         title: Text('정보 1'),
                          //         onTap: () {
                          //           // Navigator.push(
                          //           //   context,
                          //           //   MaterialPageRoute(
                          //           //     builder: (context) => DetailScreen(),
                          //           //   ),
                          //           // );
                          //         },
                          //       ),
                          //       ListTile(
                          //         title: Text('정보 2'),
                          //       ),
                          //       ListTile(
                          //         title: Text('정보 3'),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // 뒤로가기 버튼
              Positioned(
                top: 15,
                left: 15,
                child: TextButton(
                  // color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 1,
                      right: 2,
                    ),
                    child: SvgPicture.asset(
                      'assets/icon/jam_chevron_left.svg',
                      // colorFilter:
                      //     ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    minimumSize: const WidgetStatePropertyAll(Size(40, 40)),
                    fixedSize: const WidgetStatePropertyAll(Size(40, 40)),
                    // shape: WidgetStateProperty.all(
                    //   RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    // ),
                    shadowColor: WidgetStateProperty.all(
                      Colors.black.withOpacity(0.25),
                    ),
                    elevation: WidgetStateProperty.all(10),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
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
                      child: SizedBox(
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
                              backgroundColor: WidgetStateProperty.all(
                                Colors.white,
                              ),
                              shadowColor: WidgetStateProperty.all(
                                Colors.black.withOpacity(0.25),
                              ),
                              elevation: WidgetStateProperty.all(10),
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

class _Header extends StatelessWidget {
  const _Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // 슬라이더
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: FractionallySizedBox(
              widthFactor: 0.15,
              child: Container(
                height: 2.67,
                color: cGray4,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        // 날짜 보기
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '10.03',
                      style: myTextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '내 일정1',
                      style: myTextStyle(
                        fontSize: 8,
                        color: cGray3,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                heightFactor: 1.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _LR(
                      text: '전체보기',
                      onPressed: () {},
                    ),
                    _LR(
                      text: '2024.10.04',
                      reverse: true,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LR extends StatelessWidget {
  final bool reverse;
  final void Function()? onPressed;
  final String text;
  const _LR({
    required this.text,
    this.reverse = false,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var row = [
      SizedBox(
        width: 21,
        height: 21,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.diagonal3Values(reverse ? -1 : 1, 1, 1),
          child: SvgPicture.asset(
            'assets/icon/jam_chevron_left.svg',
          ),
        ),
      ),
      const SizedBox(width: 8),
      Text(
        text,
        style: myTextStyle(
          fontSize: 12,
          color: cGray3,
          letterSpacing: 0.25,
          fontWeight: FontWeight.w400,
        ),
      ),
    ];
    return TextButton(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(EdgeInsets.only(
          left: reverse ? 18 : 8,
          right: reverse ? 8 : 18,
        )),
        backgroundColor: WidgetStateProperty.all(Colors.white),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: reverse ? row.reversed.toList() : row,
      ),
    );
  }
}

class DailyItineraryEditor extends StatefulWidget {
  final DailyItineraryCubit? dailyItineraryCubit;

  const DailyItineraryEditor({
    super.key,
    this.dailyItineraryCubit,
  });

  @override
  _DailyItineraryEditorState createState() => _DailyItineraryEditorState();
}
