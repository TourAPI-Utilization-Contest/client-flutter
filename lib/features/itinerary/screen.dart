import 'dart:math';
import 'dart:ui' as ui;
import 'package:avs_svg_provider/avs_svg_provider.dart';
import 'package:dashed_line/dashed_line.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tradule/common/color.dart';
import 'package:tradule/common/my_text_style.dart';
import 'package:tradule/common/single_child_scroll_fade_view.dart';
import 'package:tradule/server_wrapper/data/daily_itinerary_data.dart';
import 'package:tradule/server_wrapper/data/itinerary_data.dart';
import 'package:tradule/server_wrapper/data/place_data.dart';
import 'package:tradule/server_wrapper/data/movement_data.dart';

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

Future<Uint8List> svgAssetToPngBytes(
  // The SVG file path
  String svgPath,
  // The pixelRatio
  double pixelRatio,
) async {
  final SvgAssetLoader svg = SvgAssetLoader(svgPath);
  final PictureInfo pictureInfo = await vg.loadPicture(svg, null);
  final ui.Picture picture = pictureInfo.picture;
  final ui.PictureRecorder recorder = ui.PictureRecorder();
  final double targetWidth = pictureInfo.size.width * pixelRatio;
  final double targetHeight = pictureInfo.size.height * pixelRatio;
  final ui.Canvas canvas = Canvas(recorder,
      Rect.fromPoints(Offset.zero, Offset(targetWidth, targetHeight)));
  canvas.scale(pixelRatio, pixelRatio);
  canvas.drawPicture(picture);
  final ui.Image imgByteData = await recorder
      .endRecording()
      .toImage(targetWidth.ceil(), targetHeight.ceil());
  final ByteData? bytesData =
      await imgByteData.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List imageData = bytesData?.buffer.asUint8List() ?? Uint8List(0);
  pictureInfo.picture.dispose();
  return imageData;
}

Future<BitmapDescriptor> svgToBitmapDescriptor(String assetName,
    {double? scaleFactor}) async {
  // 디바이스의 픽셀 비율을 가져옴
  double pixelRatio = scaleFactor ??
      ui.PlatformDispatcher.instance.views.first.devicePixelRatio;

  //웹일 경우 픽셀 비율을 1로 설정
  var pixelRatio2 = kIsWeb ? 1.0 : pixelRatio;

  return BitmapDescriptor.bytes(
    await svgAssetToPngBytes(assetName, pixelRatio2),
    imagePixelRatio: pixelRatio,
  );
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
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    // _createCustomMarkerBitmap('Hello World', 2).then((BitmapDescriptor bitmap) {
    //   _markerIcon = bitmap;
    //   setState(() {});
    // });
    svgToBitmapDescriptor('assets/icon/iconamoon_location_pin_fill.svg')
        .then((BitmapDescriptor bitmap) {
      _markerIcon = bitmap;
      setState(() {});
      // _markers.add(
      //   Marker(
      //     markerId: MarkerId('marker_1'),
      //     icon: _markerIcon,
      //     position: LatLng(37.5662952, 126.9779451),
      //     draggable: false,
      //     onDrag: (LatLng position) {
      //       print('Marker position: $position');
      //     },
      //     infoWindow: InfoWindow(
      //       title: '서울특별시청',
      //       snippet: '서울특별시 중구 태평로1가 31',
      //       anchor: Offset(0.5, 0.5),
      //     ),
      //   ),
      // );
      //
      // _polylines.add(
      //   Polyline(
      //     polylineId: PolylineId('polyline_1'),
      //     points: [
      //       LatLng(37.5662952, 126.9779451),
      //       LatLng(37.55, 126.7),
      //       LatLng(37.6, 126.6),
      //     ],
      //     jointType: JointType.round,
      //     startCap: Cap.roundCap,
      //     endCap: Cap.roundCap,
      //     zIndex: 2,
      //     color: Theme.of(context).primaryColor,
      //     width: 7,
      //   ),
      // );
      // _polylines.add(
      //   Polyline(
      //     polylineId: PolylineId('polyline_2'),
      //     points: [
      //       LatLng(37.5662952, 126.9779451),
      //       LatLng(37.55, 126.7),
      //       LatLng(37.6, 126.6),
      //     ],
      //     jointType: JointType.round,
      //     startCap: Cap.roundCap,
      //     endCap: Cap.roundCap,
      //     zIndex: 1,
      //     color: Colors.white,
      //     width: 10,
      //   ),
      // );
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
      // imagePixelRatio: scaleFactor,
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
          )..addListener(() {
              // print('Tab previous index: ${_tabController!.previousIndex}');
              // print('Tab index: ${_tabController!.index}');
              _markers.clear();
              _polylines.clear();
              var dailyItineraryCubit = itinerary.dailyItineraryCubitList[
                  _tabController!.index == 0 ? 0 : _tabController!.index - 1];
              for (var placeCubit in dailyItineraryCubit.state.placeList) {
                _markers.add(
                  Marker(
                    markerId: MarkerId(placeCubit.state.id),
                    icon: _markerIcon,
                    position: LatLng(
                        placeCubit.state.latitude, placeCubit.state.longitude),
                    draggable: false,
                    infoWindow: InfoWindow(
                      title: placeCubit.state.title,
                      snippet: placeCubit.state.address,
                      anchor: Offset(0.5, 0.5),
                    ),
                  ),
                );
              }
              // for (var movementCubit in dailyItineraryCubit.state.movementList) {
              //   _polylines.add(
              //     Polyline(
              //       polylineId: PolylineId(movementCubit.state.id),
              //       points: movementCubit.state.latLngList,
              //       jointType: JointType.round,
              //       startCap: Cap.roundCap,
              //       endCap: Cap.roundCap,
              //       zIndex: 2,
              //       color: Theme.of(context).primaryColor,
              //       width: 7,
              //     ),
              //   );
              // }
            });
          return BlocProvider(
            create: (context) =>
                TabControllerCubit(tabController: _tabController!),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double mapHeight = constraints.maxHeight - _bottomSheetHeight;
                final padding = MediaQuery.of(context).padding;
                return Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: mapHeight,
                      child: GoogleMap(
                        onLongPress: (LatLng latLng) {
                          print('Map long pressed: $latLng');
                        },
                        key: _mapKey,
                        webGestureHandling: WebGestureHandling.greedy,
                        onMapCreated: (GoogleMapController controller) {
                          _mapController = controller;
                        },
                        // padding: EdgeInsets.only(bottom: _bottomSheetHeight),
                        initialCameraPosition: CameraPosition(
                          target: LatLng(37.5662952, 126.9779451),
                          zoom: 12,
                        ),
                        cloudMapId: _cloudMapId,
                        // style: _style,
                        // mapToolbarEnabled: true,
                        markers: _markers,
                        polylines: _polylines,
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
                                constraints.maxHeight * 0.8);
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
                            // color: Theme.of(context).primaryColor,
                            child: Column(
                              spacing: 10,
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
                      top: 15 + padding.top,
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
                          padding: WidgetStateProperty.all(EdgeInsets.zero),
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
                      top: padding.top,
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
                          tabController.index == 0
                              ? itinerary.title
                              : 'Day ${tabController.index}',
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
                        key: const Key('left'),
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
                        key: const Key('right'),
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
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    // var tabController = context.watch<TabControllerCubit>().state;
    var itinerary = context.read<ItineraryCubit>().state;
    return Expanded(
      child: TabBarView(
        controller: widget.tabController,
        children: [
          //전체 일정
          SingleChildScrollFadeView(
            scrollController: _scrollController,
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
    super.key,
    required this.text,
    this.reverse = false,
    this.onPressed,
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
    return BlocProvider.value(
      value: widget.dailyItineraryCubit,
      child: BlocBuilder<DailyItineraryCubit, DailyItineraryData>(
          builder: (context, dailyItineraryData) {
        var list = <Widget>[];
        for (var i = 0; i < dailyItineraryData.placeList.length; i++) {
          list.add(DailyItineraryItem(
            key: Key('${i * 2}'),
            index: i * 2,
            place: true,
            first: i == 0,
            last: i == dailyItineraryData.placeList.length - 1,
            placeCubit: dailyItineraryData.placeList[i],
          ));
          if (dailyItineraryData.movementList.length <= i) break;
          // if (dailyItineraryData.movementList.length <= i) {
          //   widget.dailyItineraryCubit.addMovement(
          //     MovementCubit(MovementData.initial()),
          //   );
          // }
          list.add(DailyItineraryItem(
            key: Key('${i * 2 + 1}'),
            index: i * 2 + 1,
            place: false,
            movementCubit: dailyItineraryData.movementList[i],
          ));
        }
        return SingleChildScrollFadeView(
          child: Column(
            children: list,
          ),
        );
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class DailyItineraryItem extends StatelessWidget {
  final PlaceCubit? placeCubit;
  final MovementCubit? movementCubit;
  final bool place;
  final bool first;
  final bool last;
  final bool dotLine;
  final int index;
  final Size jamChevronUpDownSize = const Size(20, 20);
  const DailyItineraryItem({
    required this.index,
    this.placeCubit,
    this.movementCubit,
    this.place = false,
    this.first = false,
    this.last = false,
    this.dotLine = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime(1970, 1, 1, 0, 0);
    var timeFormat1 = DateFormat('m분');
    var timeFormat2 = DateFormat('h시간 m분');
    var timeFormat3 = DateFormat('h시간');
    var timeFormat4 = DateFormat('hh:mm');
    String TimeFormat(DateTime dateTime) {
      if (dateTime.hour == 0) {
        return timeFormat1.format(dateTime);
      } else if (dateTime.minute == 0) {
        return timeFormat3.format(dateTime);
      } else {
        return timeFormat2.format(dateTime);
      }
    }

    return Material(
      child: ListTile(
        onTap: () {
          print('onTap: $index');
        },
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        // title: Text(placeData.title),
        title: Row(
          children: [
            Stack(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icon/check_on.svg",
                      colorFilter: place
                          ? null
                          : const ColorFilter.mode(
                              Colors.transparent, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 10),
                    Stack(
                      children: [
                        // SvgPicture.asset(
                        //     place ? "assets/icon/cc.svg" : "assets/icon/cc2.svg"),
                        place
                            ? SvgPicture.asset("assets/icon/cc.svg")
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: SvgPicture.asset("assets/icon/cc2.svg"),
                              ),
                        if (place)
                          Positioned.fill(
                            child: Center(
                              child: Text(
                                "${(index / 2 + 1).truncate()}",
                                style: myTextStyle(
                                  fontSize: 9,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 10),
            if (place)
              DailyItineraryPlaceItem(
                placeCubit: placeCubit!,
                index: index,
                place: place,
                first: first,
                last: last,
                dotLine: dotLine,
              ),
            if (!place)
              DailyItineraryMovementItem(
                movementCubit: movementCubit!,
                index: index,
                first: first,
                last: last,
                dotLine: dotLine,
              ),
          ],
        ),
        trailing: place
            ? ReorderableDragStartListener(
                index: index,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: !first,
                      child: TextButton(
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(EdgeInsets.zero),
                          minimumSize:
                              WidgetStateProperty.all(jamChevronUpDownSize),
                          fixedSize:
                              WidgetStateProperty.all(jamChevronUpDownSize),
                        ),
                        child: SvgPicture.asset(
                          "assets/icon/jam_chevron_up.svg",
                          fit: BoxFit.contain,
                          width: jamChevronUpDownSize.width,
                          height: jamChevronUpDownSize.height,
                        ),
                        onPressed: () {
                          //위로
                          context.read<DailyItineraryCubit>().reorderPlaces(
                                index ~/ 2,
                                index ~/ 2 - 1,
                              );
                        },
                      ),
                    ),
                    Visibility(
                      visible: !last,
                      child: TextButton(
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(EdgeInsets.zero),
                          minimumSize:
                              WidgetStateProperty.all(jamChevronUpDownSize),
                          fixedSize:
                              WidgetStateProperty.all(jamChevronUpDownSize),
                        ),
                        onPressed: () {
                          //아래로(reorderPlaces)
                          context.read<DailyItineraryCubit>().reorderPlaces(
                                index ~/ 2,
                                index ~/ 2 + 1,
                              );
                        },
                        child: Transform.flip(
                          flipY: true,
                          child: SvgPicture.asset(
                            "assets/icon/jam_chevron_up.svg",
                            fit: BoxFit.contain,
                            width: jamChevronUpDownSize.width,
                            height: jamChevronUpDownSize.height,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : null,
      ),
    );
  }
}

class DailyItineraryPlaceItem extends StatelessWidget {
  final PlaceCubit placeCubit;
  final bool place;
  final bool first;
  final bool last;
  final bool dotLine;
  final int index;
  const DailyItineraryPlaceItem({
    required this.placeCubit,
    required this.index,
    this.place = true,
    this.first = false,
    this.last = false,
    this.dotLine = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: placeCubit,
      child: BlocBuilder<PlaceCubit, PlaceData>(
        builder: (context, placeData) {
          DateTime dateTime = DateTime(1970, 1, 1, 0, 0);
          var timeFormat1 = DateFormat('m분');
          var timeFormat2 = DateFormat('h시간 m분');
          var timeFormat3 = DateFormat('h시간');
          var timeFormat4 = DateFormat('hh:mm');
          String TimeFormat(DateTime dateTime) {
            if (dateTime.hour == 0) {
              return timeFormat1.format(dateTime);
            } else if (dateTime.minute == 0) {
              return timeFormat3.format(dateTime);
            } else {
              return timeFormat2.format(dateTime);
            }
          }

          return Expanded(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      placeData.title,
                      style: myTextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 5),
                    SvgPicture.asset("assets/icon/jam_pencil_f.svg"),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  spacing: 10,
                  children: [
                    Text(
                      placeData.visitDate == null
                          ? '??:??'
                          : timeFormat4.format(placeData.visitDate!),
                      style: myTextStyle(
                        fontSize: 9,
                        color: const Color(0xFF0BB2D1),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      //시간 표시
                      placeData.stayTime != null &&
                              placeData.stayTime!.inMinutes > 0
                          ? '${TimeFormat(dateTime.add(placeData.stayTime!))} 관광'
                          : '관광 시간 미정',
                      style: myTextStyle(
                        fontSize: 9,
                        color: const Color(0xFF0BB2D1),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        placeData.address,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: myTextStyle(
                          fontSize: 9,
                          color: cGray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DailyItineraryMovementItem extends StatelessWidget {
  final MovementCubit movementCubit;
  final bool first;
  final bool last;
  final bool dotLine;
  final int index;
  const DailyItineraryMovementItem({
    required this.movementCubit,
    required this.index,
    this.first = false,
    this.last = false,
    this.dotLine = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: movementCubit,
      child: BlocBuilder<MovementCubit, MovementData>(
        builder: (context, movementData) {
          DateTime dateTime = DateTime(1970, 1, 1, 0, 0);
          var timeFormat1 = DateFormat('m분');
          var timeFormat2 = DateFormat('h시간 m분');
          var timeFormat3 = DateFormat('h시간');
          var timeFormat4 = DateFormat('hh:mm');
          String TimeFormat(DateTime dateTime) {
            if (dateTime.hour == 0) {
              return timeFormat1.format(dateTime);
            } else if (dateTime.minute == 0) {
              return timeFormat3.format(dateTime);
            } else {
              return timeFormat2.format(dateTime);
            }
          }

          return Row(
            children: [
              Text(
                TimeFormat(dateTime.add(movementData.duration)) +
                    " 동안 " +
                    movementData.distance.toString() +
                    "km 이동",
                style: myTextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 7),
              IconButton(
                padding: EdgeInsets.zero,
                iconSize: 15,
                constraints: const BoxConstraints(
                  minWidth: 10,
                  minHeight: 10,
                ),
                icon: Icon(Icons.refresh),
                onPressed: () {
                  //새로고침
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
