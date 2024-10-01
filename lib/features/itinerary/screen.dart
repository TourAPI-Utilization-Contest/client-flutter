import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tradule/common/color.dart';
import 'package:tradule/common/my_text_style.dart';
import 'package:tradule/server_wrapper/data/daily_itinerary_data.dart';
import 'package:tradule/server_wrapper/data/itinerary_data.dart';

import 'bloc.dart';
import 'map_style.dart';
import 'time_dial.dart';

class ItineraryEditor extends StatefulWidget {
  final ItineraryCubit itineraryCubit;

  const ItineraryEditor({
    super.key,
    required this.itineraryCubit,
  });

  @override
  _ItineraryEditorState createState() => _ItineraryEditorState();
}

class _ItineraryEditorState extends State<ItineraryEditor>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  double _bottomSheetHeight = 100; // 바텀 시트 초기 높이
  double _bottomSheetMinHeight = 100; // 바텀 시트 최소 높이
  GlobalKey _mapKey = GlobalKey();
  String _cloudMapId = lightMapId; // 기본 스타일
  String? _style = aubergine;
  BitmapDescriptor _markerIcon = BitmapDescriptor.defaultMarker;
  DateTime _mapTime = DateTime.now();
  TabController? _tabController;

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
      textDirection: ui.TextDirection.ltr,
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
    return Scaffold(
      body: BlocProvider.value(
        value: widget.itineraryCubit,
        child: BlocBuilder<ItineraryCubit, ItineraryData?>(
            builder: (context, itinerary) {
          _tabController ??= TabController(
            initialIndex: 0,
            length: itinerary!.dailyItineraryCubitList.length + 1,
            vsync: this,
          );
          return BlocProvider(
            create: (context) =>
                TabControllerCubit(tabController: _tabController!),
            child: LayoutBuilder(
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
                                _bottomSheetMinHeight,
                                constraints.maxHeight / 2);
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
                                _Body(tabController: _tabController!),
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
                          backgroundColor:
                              WidgetStateProperty.all(Colors.white),
                          minimumSize:
                              const WidgetStatePropertyAll(Size(40, 40)),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
        }),
      ),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}

class _Header extends StatelessWidget {
  // final TabController tabController;
  const _Header({
    // required this.tabController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var tabController = context.watch<TabControllerCubit>().state;
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
          child: BlocBuilder<TabControllerCubit, TabControllerData>(
            builder: (context, tabControllerData) {
              var itinerary = context.read<ItineraryCubit>().state;
              var dateFormat = DateFormat('yyyy.MM.dd');
              var titleDateFormat = DateFormat('MM.dd');
              var tabController = tabControllerData.tabController;
              return Stack(
                children: [
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          tabController.index == 0
                              ? '전체보기'
                              : titleDateFormat.format(itinerary.startDate.add(
                                  Duration(days: tabController.index - 1))),
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
                  if (tabController.index > 0)
                    Positioned(
                      left: 0,
                      top: 0,
                      child: _LR(
                        text: tabController.index == 1
                            ? '전체보기'
                            : dateFormat.format(itinerary.startDate
                                .add(Duration(days: tabController.index - 2))),
                        onPressed: () {
                          tabController.index -= 1;
                        },
                      ),
                    ),
                  if (tabController.index <
                      itinerary.dailyItineraryCubitList.length)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: _LR(
                        text: dateFormat.format(itinerary.startDate
                            .add(Duration(days: tabController.index))),
                        reverse: true,
                        onPressed: () {
                          tabController.index += 1;
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Body extends StatefulWidget {
  final TabController tabController;
  const _Body({
    required this.tabController,
    super.key,
  });

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // var tabController = context.watch<TabControllerCubit>().state;
    var itinerary = context.read<ItineraryCubit>().state;
    return Expanded(
      child: TabBarView(
        controller: widget.tabController,
        children: [
          //전체 일정
          SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Itinerary',
                  style: myTextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          //하루 일정
          for (var dailyItineraryCubit in itinerary.dailyItineraryCubitList)
            DailyItineraryEditor(dailyItineraryCubit: dailyItineraryCubit),
        ],
      ),
    );
    return Container();
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
  final DailyItineraryCubit dailyItineraryCubit;

  const DailyItineraryEditor({
    super.key,
    required this.dailyItineraryCubit,
  });

  @override
  _DailyItineraryEditorState createState() => _DailyItineraryEditorState();
}

class _DailyItineraryEditorState extends State<DailyItineraryEditor>
    with AutomaticKeepAliveClientMixin<DailyItineraryEditor> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Daily Itinerary',
            style: myTextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Date: ${widget.dailyItineraryCubit.state.date}',
            style: myTextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
