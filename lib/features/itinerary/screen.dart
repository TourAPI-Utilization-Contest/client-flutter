import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:dashed_line/dashed_line.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:toastification/toastification.dart';
// import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';
import 'package:tradule/common/color.dart';
import 'package:tradule/common/context_menu.dart';
import 'package:tradule/common/my_text_style.dart';
import 'package:tradule/common/single_child_scroll_fade_view.dart';
import 'package:tradule/google_map_routes/google_map_routes.dart';
import 'package:tradule/server_wrapper/data/daily_itinerary_data.dart';
import 'package:tradule/server_wrapper/data/itinerary_data.dart';
import 'package:tradule/server_wrapper/data/place_data.dart';
import 'package:tradule/server_wrapper/data/movement_data.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:tradule/server_wrapper/server_wrapper.dart';
import 'package:latlong2/latlong.dart' as latlng2;
import 'package:tradule/server_wrapper/tsp.dart';
// import 'package:wheel_picker/wheel_picker.dart';

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
  // var pixelRatio2 = kIsWeb ? 1.0 : pixelRatio;

  return BitmapDescriptor.bytes(
    await svgAssetToPngBytes(assetName, pixelRatio),
    imagePixelRatio: pixelRatio,
  );
}

class GoogleMapData {
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final Set<Circle> circles;
  final BitmapDescriptor markerIcon;
  final List<LatLng> expectedLocationList;
  final DateTime mapTime;
  final bool congestionToggle; // 혼잡도 표시

  GoogleMapData({
    this.markers = const {},
    this.polylines = const {},
    this.circles = const {},
    this.markerIcon = BitmapDescriptor.defaultMarker,
    this.expectedLocationList = const [],
    DateTime? mapTime,
    this.congestionToggle = false,
  }) : mapTime = mapTime ?? DateTime.now();

  //copyWith
  GoogleMapData copyWith({
    Set<Marker>? markers,
    Set<Polyline>? polylines,
    Set<Circle>? circles,
    BitmapDescriptor? markerIcon,
    List<LatLng>? expectedLocationList,
    DateTime? mapTime,
    bool? congestionToggle,
  }) {
    return GoogleMapData(
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      circles: circles ?? this.circles,
      markerIcon: markerIcon ?? this.markerIcon,
      expectedLocationList: expectedLocationList ?? this.expectedLocationList,
      mapTime: mapTime ?? this.mapTime,
      congestionToggle: congestionToggle ?? this.congestionToggle,
    );
  }
}

class GoogleMapCubit extends Cubit<GoogleMapData> {
  GoogleMapCubit(super.state);

  void update(GoogleMapData googleMapData) {
    emit(googleMapData);
  }

  void copyWith({
    Set<Marker>? markers,
    Set<Polyline>? polylines,
    Set<Circle>? circles,
    BitmapDescriptor? markerIcon,
    List<LatLng>? expectedLocationList,
    DateTime? mapTime,
    bool? congestionToggle,
  }) {
    emit(state.copyWith(
      markers: markers,
      polylines: polylines,
      circles: circles,
      markerIcon: markerIcon,
      expectedLocationList: expectedLocationList,
      mapTime: mapTime,
      congestionToggle: congestionToggle,
    ));
  }
}

// class SelectCubit extends Cubit<List<List<bool>>> {
//   SelectCubit(super.state);
//
//   void update(List<List<bool>> selectList) {
//     emit(selectList);
//   }
// }

class _ItineraryEditorState extends State<ItineraryEditor>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  double _bottomSheetHeight = 100; // 바텀 시트 초기 높이
  double _bottomSheetMinHeight = 100; // 바텀 시트 최소 높이
  GlobalKey _mapKey = GlobalKey();
  String _cloudMapId = lightMapId; // 기본 스타일
  String? _style = aubergine;

  // DateTime _mapTime = DateTime.now();
  // TabController? _tabController;
  TabControllerCubit? _tabControllerCubit;
  // final GoogleMapCubit _globalGoogleMapCubit = GoogleMapCubit(GoogleMapData());

  @override
  void initState() {
    super.initState();
    // _createCustomMarkerBitmap('Hello World', 2).then((BitmapDescriptor bitmap) {
    //   _markerIcon = bitmap;
    //   setState(() {});
    // });
    svgToBitmapDescriptor('assets/icon/iconamoon_location_pin_fill.svg')
        .then((BitmapDescriptor bitmap) {
      // _markerIcon = bitmap;
      _globalGoogleMapCubit.update(
        _globalGoogleMapCubit.state.copyWith(markerIcon: bitmap),
      );
      _refreshRoute(_globalGoogleMapCubit, widget.itineraryCubit.state, 0);
      // setState(() {});
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
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: _globalGoogleMapCubit,
          ),
          BlocProvider.value(
            value: widget.itineraryCubit,
          ),
          // BlocProvider.value(
          //   value: _selectCubit,
          // ),
        ],
        child: BlocBuilder<ItineraryCubit, ItineraryData?>(
            builder: (context, itinerary) {
          // var _tabController = _tabControllerCubit.state.tabController;
          if (_tabControllerCubit == null) {
            _tabControllerCubit = TabControllerCubit(
              tabController: TabController(
                vsync: this,
                length: itinerary!.dailyItineraryCubitList.length + 1,
                initialIndex: 0,
              )..addListener(() {
                  tabControllerListener(context.read<ItineraryCubit>());
                }),
            );
          } else {
            var tabController = _tabControllerCubit!.state.tabController;
            if (tabController.length !=
                itinerary!.dailyItineraryCubitList.length + 1) {
              tabController.dispose();
              _tabControllerCubit = TabControllerCubit(
                tabController: TabController(
                  vsync: this,
                  length: itinerary.dailyItineraryCubitList.length + 1,
                  initialIndex: 0,
                )..addListener(() {
                    tabControllerListener(context.read<ItineraryCubit>());
                  }),
              );
            }
          }
          // _selectCubit.update(List.generate(
          //   itinerary!.dailyItineraryCubitList.length + 1,
          //       (index) => List.generate(
          //     itinerary.dailyItineraryCubitList[index].state.placeList.length,
          //         (index) => false,
          //   ),
          // ));
          return BlocProvider.value(
            value: _tabControllerCubit!,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double mapHeight =
                    constraints.maxHeight - _bottomSheetHeight;
                final padding = MediaQuery.of(context).padding;
                var markers = context.watch<GoogleMapCubit>().state.markers;
                var polylines = context.watch<GoogleMapCubit>().state.polylines;
                var circles = context.watch<GoogleMapCubit>().state.circles;
                return Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: mapHeight,
                      child: Builder(builder: (context) {
                        // var index = _tabController!.index;
                        // if (index > 0) {
                        //   var dailyItineraryCubit =
                        //       itinerary!.dailyItineraryCubitList[index - 1];
                        //   dailyItineraryCubit.
                        //   // context.watch<DailyItineraryCubit>().state;
                        // }
                        return GoogleMap(
                          // onLongPress: (LatLng latLng) {
                          //   print('Map long pressed: $latLng');
                          // },
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
                          markers: markers,
                          polylines: polylines,
                          circles: circles,
                        );
                      }),
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
                                _Body(tabControllerCubit: _tabControllerCubit!),
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

                    //검색 버튼
                    Positioned(
                      top: 15 + padding.top,
                      right: 15,
                      child: TextButton(
                        // color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 1,
                            right: 2,
                          ),
                          child: SvgPicture.asset(
                            'assets/icon/search.svg',
                            colorFilter:
                                ColorFilter.mode(cDark, BlendMode.srcIn),
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
                          // Navigator.pop(context);
                          Navigator.pushNamed(context, '/search_place');
                        },
                      ),
                    ),

                    //지도 위에 화면이 있을 때, 지도가 클릭되는 것을 방지
                    if (!(ModalRoute.of(context)?.isCurrent ?? false))
                      PointerInterceptor(
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                    //지도 시간 설정
                    Positioned(
                      // top: padding.top,
                      right: 0,
                      left: 0,
                      bottom: _bottomSheetHeight + 20,
                      child: Opacity(
                        opacity: 0.7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PointerInterceptor(
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _globalGoogleMapCubit.update(
                                      _globalGoogleMapCubit.state.copyWith(
                                        congestionToggle: !_globalGoogleMapCubit
                                            .state.congestionToggle,
                                      ),
                                    );
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all(cPrimary),
                                  shadowColor: WidgetStateProperty.all(
                                    Colors.black.withOpacity(0.25),
                                  ),
                                  elevation: WidgetStateProperty.all(10),
                                  padding: WidgetStateProperty.all(
                                    EdgeInsets.zero,
                                  ),
                                ),

                                // padding: const EdgeInsets.only(top: 15),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                        right: 10,
                                      ),
                                      child: Text(
                                        "혼잡도 " +
                                            (_globalGoogleMapCubit
                                                    .state.congestionToggle
                                                ? "ON"
                                                : "OFF"),
                                        style: myTextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          letterSpacing: 0.25,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: SizedBox(
                                        width: 150,
                                        height: 40,
                                        // color: Colors.white,
                                        child: Builder(builder: (context) {
                                          var mapTime = _globalGoogleMapCubit
                                              .state.mapTime;
                                          var textStyle = myTextStyle(
                                            fontSize: 16,
                                            color: const Color(0xFF4C5364),
                                            letterSpacing: 0.25,
                                            fontWeight: FontWeight.w500,
                                          );
                                          return TextButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateProperty.all(
                                                Colors.white,
                                              ),
                                              // shadowColor: WidgetStateProperty.all(
                                              //   Colors.black.withOpacity(0.25),
                                              // ),
                                              elevation:
                                                  WidgetStateProperty.all(10),
                                              padding: WidgetStateProperty.all(
                                                EdgeInsets.zero,
                                              ),
                                            ),
                                            onPressed: () {
                                              //시간 설정
                                              showTimePicker(
                                                context: context,
                                                // initialTime: _mapTime.timeOfDay,
                                                initialTime:
                                                    TimeOfDay.fromDateTime(
                                                        mapTime),

                                                cancelText: '취소',
                                                confirmText: '확인',
                                                helpText: '시간 설정',
                                                builder: (context, child) {
                                                  return Theme(
                                                    data: ThemeData.light()
                                                        .copyWith(
                                                      colorScheme:
                                                          ColorScheme.light(
                                                        primary: cPrimary,
                                                        onPrimary: Colors.white,
                                                        surface: Colors.white,
                                                        onSurface: Colors.black,
                                                      ),
                                                      dialogBackgroundColor:
                                                          Colors.white,
                                                    ),
                                                    child: child!,
                                                  );
                                                },
                                              ).then((time) {
                                                if (time != null) {
                                                  setState(() {
                                                    _globalGoogleMapCubit
                                                        .copyWith(
                                                      mapTime: DateTime(
                                                        mapTime.year,
                                                        mapTime.month,
                                                        mapTime.day,
                                                        time.hour,
                                                        time.minute,
                                                      ),
                                                    );
                                                    _refreshRoute(
                                                        _globalGoogleMapCubit,
                                                        itinerary,
                                                        _tabControllerCubit!
                                                            .state
                                                            .tabController
                                                            .index);
                                                  });
                                                }
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    _globalGoogleMapCubit
                                                        .copyWith(
                                                      mapTime:
                                                          _globalGoogleMapCubit
                                                              .state.mapTime
                                                              .subtract(
                                                        const Duration(
                                                            minutes: 1),
                                                      ),
                                                    );
                                                    _refreshRoute(
                                                        _globalGoogleMapCubit,
                                                        itinerary,
                                                        _tabControllerCubit!
                                                            .state
                                                            .tabController
                                                            .index);
                                                    setState(() {});
                                                  },
                                                  style: ButtonStyle(
                                                    padding:
                                                        WidgetStateProperty.all(
                                                      EdgeInsets.zero,
                                                    ),
                                                    minimumSize:
                                                        WidgetStateProperty.all(
                                                      const Size(40, 40),
                                                    ),
                                                    fixedSize:
                                                        WidgetStateProperty.all(
                                                      const Size(40, 40),
                                                    ),
                                                  ),
                                                  child: SvgPicture.asset(
                                                    'assets/icon/m.svg',
                                                  ),
                                                ),
                                                Text(
                                                  '${mapTime.hour}',
                                                  style: textStyle,
                                                ),
                                                Text(
                                                  ':',
                                                  style: textStyle,
                                                ),
                                                Text(
                                                  '${mapTime.minute}',
                                                  style: textStyle,
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    _globalGoogleMapCubit
                                                        .copyWith(
                                                      mapTime:
                                                          _globalGoogleMapCubit
                                                              .state.mapTime
                                                              .add(
                                                        const Duration(
                                                            minutes: 1),
                                                      ),
                                                    );
                                                    _refreshRoute(
                                                        _globalGoogleMapCubit,
                                                        itinerary,
                                                        _tabControllerCubit!
                                                            .state
                                                            .tabController
                                                            .index);
                                                    setState(() {});
                                                  },
                                                  style: ButtonStyle(
                                                    padding:
                                                        WidgetStateProperty.all(
                                                      EdgeInsets.zero,
                                                    ),
                                                    minimumSize:
                                                        WidgetStateProperty.all(
                                                      const Size(40, 40),
                                                    ),
                                                    fixedSize:
                                                        WidgetStateProperty.all(
                                                      const Size(40, 40),
                                                    ),
                                                  ),
                                                  child: SvgPicture.asset(
                                                    'assets/icon/p.svg',
                                                  ),
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
                            ),
                          ],
                        ),
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

  void tabControllerListener(ItineraryCubit itineraryCubit) {
    var tabController = _tabControllerCubit!.state.tabController;
    var itinerary = itineraryCubit.state;
    _refreshRoute(_globalGoogleMapCubit, itinerary, tabController.index);
    // setState(() {});
  }

  @override
  void dispose() {
    // _tabController?.dispose();
    _tabControllerCubit?.state.tabController.dispose();
    super.dispose();
  }
}

GoogleMapCubit _globalGoogleMapCubit = GoogleMapCubit(GoogleMapData());
// late ItineraryData _globalItinerary;
void refreshRoute(ItineraryData itinerary) {
  _refreshRoute(_globalGoogleMapCubit, itinerary, 0);
}

//리프레쉬 경로 (경로를 다시 그림)
void _refreshRoute(
    GoogleMapCubit googleMapCubit, ItineraryData itinerary, int index) {
  // print('refreshRoute');
  var markerIcon = googleMapCubit.state.markerIcon;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  Set<Circle> circle = {};
  var iMax = index == 0 ? itinerary.dailyItineraryCubitList.length : index;
  var iMin = index == 0 ? 0 : index - 1;
  for (var i = iMin; i < iMax; i++) {
    var dailyItineraryCubit = itinerary.dailyItineraryCubitList[i];
    for (var placeCubit in dailyItineraryCubit.state.placeList) {
      markers.add(
        Marker(
          markerId: MarkerId(placeCubit.state.id.toString()),
          icon: markerIcon,
          position:
              LatLng(placeCubit.state.latitude, placeCubit.state.longitude),
          draggable: false,
          infoWindow: InfoWindow(
            title: placeCubit.state.title,
            snippet: placeCubit.state.address,
            // anchor: Offset(0.5, 0.5),
          ),
        ),
      );
    }
    // print('dailyItineraryCubit: ${dailyItineraryCubit.state.toJson()}');
    for (var movementCubit in dailyItineraryCubit.state.movementList) {
      // print('movementCubit: ${movementCubit.state.toJson()}');
      DateTime startTime = movementCubit.state.startTime;
      DateTime currentTime = startTime;
      DateTime nextTime = currentTime;
      for (var movementDetail in movementCubit.state.details) {
        nextTime = currentTime.add(movementDetail.duration);
        var latlngList = PolylinePoints()
            .decodePolyline(movementDetail.path)
            .map((e) => LatLng(e.latitude, e.longitude))
            .toList();
        polylines.add(
          Polyline(
            polylineId: PolylineId(Random().nextInt(100000).toString()),
            points: latlngList,
            jointType: JointType.round,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            zIndex: 2,
            color: cPrimary,
            width: 7,
          ),
        );
        polylines.add(
          Polyline(
            polylineId: PolylineId(Random().nextInt(100000).toString()),
            points: latlngList,
            jointType: JointType.round,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            zIndex: 1,
            color: Colors.white,
            width: 10,
          ),
        );
        //예상 위치 계산
        LatLng? expectedLocation = interpolatePosition(
          latlngList,
          currentTime,
          nextTime,
          googleMapCubit.state.mapTime,
        );
        if (expectedLocation != null) {
          circle.add(
            Circle(
              circleId: CircleId(Random().nextInt(100000).toString()),
              center: expectedLocation,
              zIndex: 3,
              radius: 100,
              fillColor: cPrimary.withAlpha(50),
              strokeColor: cPrimary.withAlpha(100),
              strokeWidth: 2,
            ),
          );
          circle.add(
            Circle(
              circleId: CircleId(Random().nextInt(100000).toString()),
              center: expectedLocation,
              zIndex: 4,
              radius: 30,
              fillColor: Colors.white,
              strokeColor: cPrimary,
              strokeWidth: 6,
            ),
          );
        }
        currentTime = nextTime;
      }
    }
  }

  googleMapCubit.update(
    googleMapCubit.state.copyWith(
      markers: markers,
      polylines: polylines,
      circles: circle,
    ),
  );
}

void _refreshRouteWithServer(
    GoogleMapCubit googleMapCubit, ItineraryData itinerary, int index) {
  _refreshRoute(googleMapCubit, itinerary, index);
  if (index == 0) return;
  ServerWrapper.putScheduleDetail(
    itinerary.id,
    itinerary.dailyItineraryCubitList[index - 1],
  );
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
    return Stack(
      children: [
        Column(
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
                                  ? '일정 모아보기'
                                  : titleDateFormat.format(itinerary.startDate
                                      .add(Duration(
                                          days: tabController.index - 1))),
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
                                ? '일정 모아보기'
                                : dateFormat.format(itinerary.startDate.add(
                                    Duration(days: tabController.index - 2))),
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
                              print('right');
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
        ),
        if (tabController.tabController.index > 0)
          Positioned(
            right: 10,
            top: 10,
            child: TextButton(
              onPressed: () {
                autoArrange(context);
              },
              child: const Text("일정 순서 최적화"),
            ),
          ),
      ],
    );
  }

  Future<bool> autoArrange(BuildContext context) async {
    var tabController = context.read<TabControllerCubit>().state.tabController;
    // List<PlaceData> placeList = [];
    var index = tabController.index - 1;
    if (index < 0) return false;
    var dailyItineraryCubit =
        context.read<ItineraryCubit>().state.dailyItineraryCubitList[index];
    List<List<(double, double)>> latlngList = [];
    var latlngIndex = 0;
    var latlngIndexList = [];
    var pass = true;
    for (var placeCubit in dailyItineraryCubit.state.placeList) {
      var placeData = placeCubit.state;
      if (placeData.isSelected) {
        if (pass) {
          latlngList.add([]);
          latlngIndexList.add(latlngIndex);
          pass = false;
        }
        // placeList.add(placeData);
        latlngList.last.add(
          (placeData.latitude, placeData.longitude),
        );
      } else {
        pass = true;
      }
      latlngIndex++;
    }

    if (latlngList.length < 1) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        title: Text("일정 순서 최적화 실패"),
        description: Text("최적화 할 장소를 선택해주세요."),
        alignment: Alignment.center,
        autoCloseDuration: const Duration(seconds: 3),
        icon: Icon(Iconsax.alarm_copy),
        borderRadius: BorderRadius.circular(12.0),
        dragToClose: true,
        applyBlurEffect: true,
        showProgressBar: false,
        // boxShadow: lowModeShadow,
      );
      return false;
    }
    for (var i = 0; i < latlngList.length; i++) {
      if (latlngList[i].length < 2) {
        toastification.show(
          context: context,
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
          title: Text("일정 순서 최적화 실패"),
          description: Text("최적화 할 장소를 2곳 이상 연속하여 선택해주세요."),
          alignment: Alignment.center,
          autoCloseDuration: const Duration(seconds: 3),
          icon: Icon(Iconsax.alarm_copy),
          borderRadius: BorderRadius.circular(12.0),
          dragToClose: true,
          applyBlurEffect: true,
          showProgressBar: false,
          // boxShadow: lowModeShadow,
        );
        return false;
      }
    }

    //경유지 순서 계산
    var indexList = await TspRouteFinder.findTspRoute(latlngList);
    if (!context.mounted) return false;

    //경유지 순서에 따라 장소 순서 변경
    var oldPlaceList =
        dailyItineraryCubit.state.placeList.map((e) => e.state).toList();
    var newPlaceList = List<PlaceData>.from(oldPlaceList);
    for (var i = 0; i < latlngIndexList.length; i++) {
      var latlngIndex = latlngIndexList[i];
      var length = indexList[i].length;
      for (var j = 0; j < length; j++) {
        newPlaceList[latlngIndex + j] = oldPlaceList[indexList[i][j]];
        if (j != 0) {
          dailyItineraryCubit.resetMovement(latlngIndex + j - 1);
          dailyItineraryCubit.processingMovement(latlngIndex + j - 1);
        }
      }
    }

    //장소 순서 변경
    for (var i = 0; i < newPlaceList.length; i++) {
      dailyItineraryCubit.state.placeList[i].update(newPlaceList[i]);
    }

    //서버로 일정 업데이트
    ServerWrapper.putScheduleDetail(
      context.read<ItineraryCubit>().state.id,
      dailyItineraryCubit,
    );

    //경로 계산
    List<Future<bool?>> futures = [];
    for (var i = 0; i < latlngIndexList.length; i++) {
      var startIndex = latlngIndexList[i];
      var count = indexList[i].length;
      futures.add(autoRoute(
        dailyItineraryCubit,
        startIndex,
        count,
        context,
      ));
    }

    var results = await Future.wait(futures);
    ServerWrapper.putScheduleDetail(
      context.read<ItineraryCubit>().state.id,
      dailyItineraryCubit,
    );
    return results.every((element) => element == true);
  }

  Future<bool> autoRoute(DailyItineraryCubit dailyItineraryCubit,
      int startIndex, int count, BuildContext context) async {
    //경로 계산(getGoogleMapRoutes)
    var placeList = dailyItineraryCubit.state.placeList;
    // var movementList = dailyItineraryCubit.state.movementList;

    for (var i = 0; i < count - 1; i++) {
      var startPlace = placeList[startIndex + i].state;
      var endPlace = placeList[startIndex + i + 1].state;
      var movementCubit =
          dailyItineraryCubit.state.movementList[startIndex + i];
      var movementData = await getGoogleMapRoutes(startPlace, endPlace);
      if (!context.mounted) return false;
      dailyItineraryCubit.processingMovement(startIndex + i, processing: false);
      if (movementData == null) {
        return false;
      }
      movementCubit.update(movementData);
      _refreshRoute(
        context.read<GoogleMapCubit>(),
        context.read<ItineraryCubit>().state,
        context.read<TabControllerCubit>().state.tabController.index,
      );
      //다음 장소 도착 시간 계산
      var startTime = movementCubit.state.startTime;
      var endTime = startTime.add(movementData.duration);
      var endPlaceCubit = placeList[startIndex + i + 1];
      endPlaceCubit.update(
        endPlace.copyWith(
          visitTime: TimeOfDay.fromDateTime(endTime),
        ),
      );
    }
    return true;
  }
}

class _Body extends StatefulWidget {
  final TabControllerCubit tabControllerCubit;
  const _Body({
    required this.tabControllerCubit,
    super.key,
  });

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with TickerProviderStateMixin {
  // final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    // var tabController = context.watch<TabControllerCubit>().state;
    var itinerary = context.read<ItineraryCubit>().state;
    return Expanded(
      child: TabBarView(
        controller: widget.tabControllerCubit.state.tabController,
        children: [
          //// 전체 일정
          // SingleChildScrollFadeView(
          //   scrollController: _scrollController,
          //   child: Column(
          //     children: [
          //       Text(
          //         'Itinerary',
          //         style: myTextStyle(
          //           fontSize: 24,
          //           color: Colors.black,
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          ItineraryAllView(
            itineraryCubit: context.read<ItineraryCubit>(),
          ),

          //하루 일정
          for (var i = 0; i < itinerary.dailyItineraryCubitList.length; i++)
            DailyItineraryEditor(
              dailyItineraryCubit: itinerary.dailyItineraryCubitList[i],
              tabIndex: i + 1,
            ),
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

class ItineraryAllView extends StatefulWidget {
  final ItineraryCubit itineraryCubit;

  const ItineraryAllView({
    super.key,
    required this.itineraryCubit,
  });

  @override
  _ItineraryAllViewState createState() => _ItineraryAllViewState();
}

class _ItineraryAllViewState extends State<ItineraryAllView>
    with AutomaticKeepAliveClientMixin<ItineraryAllView> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider.value(
      value: widget.itineraryCubit,
      child: BlocBuilder<ItineraryCubit, ItineraryData>(
        builder: (context, itineraryData) {
          var list = <Widget>[];
          for (var i = 0;
              i < itineraryData.dailyItineraryCubitList.length;
              i++) {
            list.add(DailyItineraryEditor(
              dailyItineraryCubit: itineraryData.dailyItineraryCubitList[i],
              tabIndex: i + 1,
              viewMode: true,
            ));
          }
          return SingleChildScrollFadeView(
            child: Column(
              children: list,
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class DailyItineraryEditor extends StatefulWidget {
  final DailyItineraryCubit dailyItineraryCubit;
  final int tabIndex;
  final bool viewMode;

  const DailyItineraryEditor({
    super.key,
    required this.dailyItineraryCubit,
    required this.tabIndex,
    this.viewMode = false,
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
            viewMode: widget.viewMode,
            index: i * 2,
            tabIndex: widget.tabIndex,
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
            viewMode: widget.viewMode,
            index: i * 2 + 1,
            tabIndex: widget.tabIndex,
            place: false,
            movementCubit: dailyItineraryData.movementList[i],
          ));
        }

        if (widget.viewMode) {
          return Column(
            children: list,
          );
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

class DailyItineraryItem extends StatefulWidget {
  final PlaceCubit? placeCubit;
  final MovementCubit? movementCubit;
  final bool place;
  final bool first;
  final bool last;
  final bool dotLine;
  final int index;
  final int tabIndex;
  final bool viewMode;

  const DailyItineraryItem({
    super.key,
    required this.index,
    required this.tabIndex,
    this.placeCubit,
    this.movementCubit,
    this.place = false,
    this.first = false,
    this.last = false,
    this.dotLine = false,
    this.viewMode = false,
  });

  @override
  State<DailyItineraryItem> createState() => _DailyItineraryItemState();
}

class _DailyItineraryItemState extends State<DailyItineraryItem> {
  final Size jamChevronUpDownSize = const Size(20, 20);
  bool _expanded = false;
  // bool _checked = true;
  Offset? _tapPosition;

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
      clipBehavior: Clip.none,
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          //선 그리기
          // if (widget.dotLine)
          if (!widget.last)
            Positioned(
              left: 59,
              top: 43,
              bottom: widget.place ? -18 : -30,
              width: 1.5,
              child: Container(
                color: cPrimary,
              ),
            ),
          GestureDetector(
            onTapDown: (details) {
              _tapPosition = details.globalPosition;
            },
            child: ListTile(
              minTileHeight: 30,
              onTap: () {
                if (!widget.place) {
                  _expanded = !_expanded;
                  setState(() {});
                } else {
                  widget.placeCubit!.update(
                    widget.placeCubit!.state.copyWith(
                      isSelected: !widget.placeCubit!.state.isSelected,
                    ),
                  );
                  setState(() {});
                }
              },
              onLongPress: widget.place
                  ? () async {
                      var r = await showContextMenu(
                        context,
                        [
                          ContextMenuItem(
                            text: '삭제',
                            icon: Icons.delete,
                            color: Colors.red,
                            value: 1,
                          ),
                        ],
                        _tapPosition!,
                      );
                      if (r == 1) {
                        context
                            .read<DailyItineraryCubit>()
                            .removePlace(widget.placeCubit!);
                        _refreshRouteWithServer(
                          context.read<GoogleMapCubit>(),
                          context.read<ItineraryCubit>().state,
                          widget.tabIndex,
                        );
                      }
                    }
                  : null,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              // title: Text(placeData.title),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // TweenAnimationBuilder(
                      //   tween: Tween<double>(begin: 0, end: _checked ? 1 : 0),
                      //   duration: const Duration(milliseconds: 200),
                      //   builder: (context, value, child) {
                      //     return Opacity(
                      //       opacity: value, // Tween에 따라 투명도 조정
                      //       child: SvgPicture.asset(
                      //         _checked
                      //             ? "assets/icon/check_on.svg"
                      //             : "assets/icon/check_off.svg",
                      //         colorFilter: widget.place
                      //             ? null
                      //             : const ColorFilter.mode(
                      //                 Colors.transparent,
                      //                 BlendMode.srcIn,
                      //               ),
                      //       ),
                      //     );
                      //   },
                      // ),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 300), // 전환 애니메이션 지속 시간
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                        child: SvgPicture.asset(
                          // 상태에 따라 다른 SVG를 보여줌
                          widget.placeCubit?.state.isSelected ?? false
                              ? "assets/icon/check_on.svg"
                              : "assets/icon/check_off.svg",
                          key: ValueKey<bool>(
                              !(widget.placeCubit?.state.isSelected ?? !false)),
                          colorFilter: widget.place
                              ? null
                              : const ColorFilter.mode(
                                  Colors.transparent, BlendMode.srcIn),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Stack(
                        children: [
                          widget.place
                              ? SvgPicture.asset(
                                  "assets/icon/cc.svg",
                                  width: 35,
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 1),
                                  child: TweenAnimationBuilder(
                                    tween: Tween<double>(
                                        begin: 0, end: _expanded ? pi / 2 : 0),
                                    duration: const Duration(milliseconds: 200),
                                    builder: (context, double angle, child) {
                                      return Transform.rotate(
                                        angle: angle,
                                        child: SvgPicture.asset(
                                            "assets/icon/cc2.svg",
                                            width: 27),
                                      );
                                    },
                                  ),
                                ),
                          if (widget.place)
                            Positioned.fill(
                              child: Center(
                                child: Text(
                                  "${(widget.index / 2 + 1).truncate()}",
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
                  const SizedBox(width: 10),
                  if (widget.place)
                    DailyItineraryPlaceItem(
                      placeCubit: widget.placeCubit!,
                      index: widget.index,
                      place: widget.place,
                      first: widget.first,
                      last: widget.last,
                      dotLine: widget.dotLine,
                    ),
                  if (!widget.place)
                    DailyItineraryMovementItem(
                      movementCubit: widget.movementCubit!,
                      index: widget.index,
                      first: widget.first,
                      last: widget.last,
                      dotLine: widget.dotLine,
                      expanded: _expanded,
                    ),
                ],
              ),
              trailing: widget.place
                  ? ReorderableDragStartListener(
                      index: widget.index,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: !widget.first,
                            child: TextButton(
                              style: ButtonStyle(
                                padding:
                                    WidgetStateProperty.all(EdgeInsets.zero),
                                minimumSize: WidgetStateProperty.all(
                                    jamChevronUpDownSize),
                                fixedSize: WidgetStateProperty.all(
                                    jamChevronUpDownSize),
                              ),
                              child: SvgPicture.asset(
                                "assets/icon/jam_chevron_up.svg",
                                fit: BoxFit.contain,
                                width: jamChevronUpDownSize.width,
                                height: jamChevronUpDownSize.height,
                              ),
                              onPressed: () {
                                //위로
                                context
                                    .read<DailyItineraryCubit>()
                                    .reorderPlaces(
                                      widget.index ~/ 2,
                                      widget.index ~/ 2 - 1,
                                    );
                                _refreshRouteWithServer(
                                  context.read<GoogleMapCubit>(),
                                  context.read<ItineraryCubit>().state,
                                  context
                                      .read<TabControllerCubit>()
                                      .state
                                      .tabController
                                      .index,
                                );
                              },
                            ),
                          ),
                          Visibility(
                            visible: !widget.last,
                            child: TextButton(
                              style: ButtonStyle(
                                padding:
                                    WidgetStateProperty.all(EdgeInsets.zero),
                                minimumSize: WidgetStateProperty.all(
                                    jamChevronUpDownSize),
                                fixedSize: WidgetStateProperty.all(
                                    jamChevronUpDownSize),
                              ),
                              onPressed: () {
                                //아래로(reorderPlaces)
                                context
                                    .read<DailyItineraryCubit>()
                                    .reorderPlaces(
                                      widget.index ~/ 2,
                                      widget.index ~/ 2 + 1,
                                    );
                                _refreshRouteWithServer(
                                  context.read<GoogleMapCubit>(),
                                  context.read<ItineraryCubit>().state,
                                  context
                                      .read<TabControllerCubit>()
                                      .state
                                      .tabController
                                      .index,
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
          ),
          //처리중인지
          if (widget.movementCubit != null)
            BlocProvider.value(
              value: widget.movementCubit!,
              child: BlocSelector<MovementCubit, MovementData, bool>(
                  selector: (state) => state.processing,
                  builder: (context, processing) {
                    if (processing) {
                      return Positioned.fill(
                        child: Container(
                          color: Colors.black.withAlpha(50),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      );
                    }
                    return Container();
                  }),
            ),
        ],
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
          var timeFormat4 = DateFormat('mm');
          var timeFormat5 = DateFormat('HH:mm');
          String timeFormatFunc1(DateTime dateTime) {
            if (dateTime.hour == 0) {
              return timeFormat1.format(dateTime);
            } else if (dateTime.minute == 0) {
              return timeFormat3.format(dateTime);
            } else {
              return timeFormat2.format(dateTime);
            }
          }

          String timeFormatFunc2(DateTime dateTime) {
            if (dateTime.hour == 0) {
              return "00:${timeFormat4.format(dateTime)}";
            } else {
              return timeFormat5.format(dateTime);
            }
          }

          //도착 시간
          DateTime visitTime = DateTime(
            dateTime.year,
            dateTime.month,
            dateTime.day,
            placeData.visitTime?.hour ?? 0,
            placeData.visitTime?.minute ?? 0,
          );
          //출발 시간
          DateTime startTime =
              visitTime.add(placeData.stayTime ?? const Duration());

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
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/icon/jam_pencil_f.svg',
                        width: 20,
                      ),
                      onPressed: () async {
                        var itineraryCubit = context.read<ItineraryCubit>();
                        var dailyItineraryCubit =
                            context.read<DailyItineraryCubit>();
                        //수정
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return PlaceEditDialog(
                              placeCubit: placeCubit,
                              itineraryCubit: itineraryCubit,
                              dailyItineraryCubit: dailyItineraryCubit,
                            );
                          },
                        );
                      },
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(
                        minWidth: 0,
                        minHeight: 0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  spacing: 10,
                  children: [
                    Text(
                      placeData.visitTime == null
                          ? '??:?? 도착'
                          : (first
                              ? "${timeFormatFunc2(startTime)} 출발"
                              : "${timeFormatFunc2(visitTime)} 도착"),
                      style: myTextStyle(
                        fontSize: 9,
                        color: cPrimaryDark,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    if (!first && !last)
                      Text(
                        //시간 표시
                        placeData.stayTime != null &&
                                placeData.stayTime!.inMinutes > 0
                            ? '${timeFormatFunc1(dateTime.add(placeData.stayTime!))} 관광'
                            : '관광 시간 미정',
                        style: myTextStyle(
                          fontSize: 9,
                          color: cPrimaryDark,
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

class PlaceEditDialog extends StatefulWidget {
  final PlaceCubit placeCubit;
  final ItineraryCubit itineraryCubit;
  final DailyItineraryCubit dailyItineraryCubit;
  const PlaceEditDialog({
    required this.placeCubit,
    required this.itineraryCubit,
    required this.dailyItineraryCubit,
    super.key,
  });

  @override
  _PlaceEditDialogState createState() => _PlaceEditDialogState();
}

class _PlaceEditDialogState extends State<PlaceEditDialog> {
  late TextEditingController _titleController;
  late TextEditingController _addressController;
  late TimeOfDay _visitTime;
  late Duration _stayTime;

  @override
  void initState() {
    super.initState();
    var placeData = widget.placeCubit.state;
    _titleController = TextEditingController(text: placeData.title);
    _addressController = TextEditingController(text: placeData.address);
    _visitTime = placeData.visitTime ?? const TimeOfDay(hour: 0, minute: 0);
    _stayTime = placeData.stayTime ?? Duration.zero;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text('장소 수정'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: '장소명',
            ),
          ),
          TextField(
            controller: _addressController,
            decoration: InputDecoration(
              labelText: '주소',
            ),
          ),
          Row(
            children: [
              Text('방문 시간: '),
              TextButton(
                onPressed: () async {
                  var time = await showTimePicker(
                    context: context,
                    initialTime: _visitTime,
                    cancelText: '취소',
                    confirmText: '확인',
                    helpText: '방문 시간 선택',
                  );
                  if (time != null) {
                    setState(() {
                      _visitTime = time;
                    });
                  }
                },
                child: Text(
                  // DateFormat('HH:mm').format(_visitTime),
                  _visitTime.format(context),
                ),
              ),
              // SizedBox(
              //   height: 20,
              //   width: 100,
              //   child: WheelPicker(
              //     itemCount: 7,
              //     builder: (context, index) => Text(
              //       '${index + 1}시',
              //       style: myTextStyle(
              //         fontSize: 16,
              //         color: Colors.black,
              //         fontWeight: FontWeight.w400,
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 50,
              //   width: 100,
              //   child: ScrollDateTimePicker(
              //       itemExtent: 50,
              //       onChange: (DateTime dateTime) {
              //         setState(() {
              //           _visitTime = TimeOfDay.fromDateTime(dateTime);
              //         });
              //       },
              //       infiniteScroll: true,
              //       wheelOption: DateTimePickerWheelOption(
              //         perspective: 0.01,
              //         diameterRatio: 1.5,
              //         squeeze: 10,
              //         offAxisFraction: 1.0,
              //         physics: BouncingScrollPhysics(),
              //       ),
              //       dateOption: DateTimePickerOption(
              //         maxDate: DateTime(1970, 1, 1, 23, 59),
              //         minDate: DateTime(1970, 1, 1, 0, 0),
              //         dateFormat: DateFormat('HHmm'),
              //       )),
              // ),
            ],
          ),
          Row(
            children: [
              Text('관광 시간: '),
              TextButton(
                onPressed: () async {
                  var time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                      hour: _stayTime.inHours,
                      minute: _stayTime.inMinutes % 60,
                    ),
                    cancelText: '취소',
                    confirmText: '확인',
                    helpText: '관광 시간 선택',
                    builder: (BuildContext context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: true),
                        child: child!,
                      );
                    },
                  );
                  if (time != null) {
                    setState(() {
                      _stayTime = Duration(
                        hours: time.hour,
                        minutes: time.minute,
                      );
                    });
                  }
                },
                child: Text(
                  '${_stayTime.inHours}시간 ${_stayTime.inMinutes % 60}분',
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('취소'),
        ),
        TextButton(
          onPressed: () {
            widget.placeCubit.update(
              widget.placeCubit.state.copyWith(
                title: _titleController.text,
                address: _addressController.text,
                visitTime: _visitTime,
                stayTime: _stayTime,
              ),
            );
            ServerWrapper.putScheduleDetail(
              widget.itineraryCubit.state.id,
              widget.dailyItineraryCubit,
            );
            Navigator.of(context).pop();
          },
          child: Text('확인'),
        ),
      ],
    );
  }
}

class DailyItineraryMovementItem extends StatelessWidget {
  final MovementCubit movementCubit;
  final bool first;
  final bool last;
  final bool dotLine;
  final int index;
  final bool expanded;
  const DailyItineraryMovementItem({
    required this.movementCubit,
    required this.index,
    this.first = false,
    this.last = false,
    this.dotLine = false,
    required this.expanded,
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

          var distance = (movementData.distance < 1000)
              ? "${movementData.distance.toInt()}m"
              : ((movementData.distance < 10000)
                  ? "${(movementData.distance / 1000).toStringAsFixed(2)}km"
                  : "${(movementData.distance / 1000).toStringAsFixed(1)}km");

          return Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "${TimeFormat(dateTime.add(movementData.duration))} 동안 $distance 이동",
                      style: myTextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.all(7),
                      iconSize: 15,
                      constraints: const BoxConstraints(
                        minWidth: 10,
                        minHeight: 10,
                      ),
                      icon: Icon(Icons.refresh),
                      onPressed: () async {
                        //새로고침
                        var placeIndex = index ~/ 2;
                        var placeList =
                            context.read<DailyItineraryCubit>().state.placeList;
                        var movementData = await getGoogleMapRoutes(
                          placeList[placeIndex].state,
                          placeList[placeIndex + 1].state,
                        );
                        // print(jsonEncode(movementData.toJson()));
                        if (movementData == null) return;
                        movementCubit.update(movementData);
                        _refreshRouteWithServer(
                          context.read<GoogleMapCubit>(),
                          context.read<ItineraryCubit>().state,
                          context
                              .read<TabControllerCubit>()
                              .state
                              .tabController
                              .index,
                        );
                      },
                    ),
                  ],
                ),

                DailyItineraryMovementDetailItem(
                  key: Key('DailyItineraryMovementDetailItem-$index'),
                  movementCubit: movementCubit,
                  index: index,
                  expanded: expanded,
                ),
                // DailyItineraryMovementDetailItem(
                //   movementCubit: movementCubit,
                //   index: index,
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DailyItineraryMovementDetailItem extends StatefulWidget {
  final MovementCubit movementCubit;
  final int index;
  final bool expanded;

  const DailyItineraryMovementDetailItem({
    super.key,
    required this.movementCubit,
    required this.index,
    required this.expanded,
  });

  @override
  State<DailyItineraryMovementDetailItem> createState() =>
      _DailyItineraryMovementDetailItemState();
}

class _DailyItineraryMovementDetailItemState
    extends State<DailyItineraryMovementDetailItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 초기화
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300), // 애니메이션 지속 시간
    );

    // 투명도 애니메이션
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // 높이 애니메이션
    _sizeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.expanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    return BlocProvider.value(
      value: widget.movementCubit,
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

          var children = <Widget>[];
          for (var i = 0; i < movementData.details.length; i++) {
            var movementDetail = movementData.details[i];
            var method = movementDetail.method;

            var distance = (movementDetail.distance < 1000)
                ? "${movementDetail.distance.toInt()}m"
                : ((movementDetail.distance < 10000)
                    ? "${(movementDetail.distance / 1000).toStringAsFixed(2)}km"
                    : "${(movementDetail.distance / 1000).toStringAsFixed(1)}km");
            String methodText;
            if (method == 'WALK') {
              methodText = '도보';
            } else if (method == 'BUS') {
              methodText = '버스';
            } else if (method == 'SUBWAY') {
              methodText = '지하철';
            } else if (method == 'TRAIN') {
              methodText = '기차';
            } else if (method == 'HEAVY_RAIL') {
              methodText = '기차';
            } else if (method == 'CAR') {
              methodText = '자동차';
            } else {
              methodText = '기타';
            }
            children.add(
              Wrap(
                spacing: 12,
                children: [
                  RoundText(text: methodText),
                  if (movementDetail.nameShort != null)
                    RoundText(text: movementDetail.nameShort!),
                  if (movementDetail.nameShort == null &&
                      movementDetail.name != null)
                    RoundText(text: movementDetail.name!),
                  Text(
                    "${TimeFormat(dateTime.add(movementDetail.duration))} 동안 $distance 이동",
                    style: myTextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          }

          if (children.isEmpty) {
            children.add(
              Column(
                children: [
                  Text(
                    '이동 경로가 없어요!',
                    style: myTextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      //새로고침
                      var placeIndex = widget.index ~/ 2;
                      var placeList =
                          context.read<DailyItineraryCubit>().state.placeList;
                      var movementData = await getGoogleMapRoutes(
                        placeList[placeIndex].state,
                        placeList[placeIndex + 1].state,
                      );
                      if (movementData == null) return;
                      print(jsonEncode(movementData.toJson()));
                      widget.movementCubit.update(movementData);
                    },
                    child: Text(
                      '경로 계산하기',
                      style: myTextStyle(
                        fontSize: 12,
                        color: cPrimary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return FadeTransition(
            opacity: _fadeAnimation,
            child: SizeTransition(
              axisAlignment: -1.0,
              sizeFactor: _sizeAnimation,
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: children,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class RoundText extends StatelessWidget {
  final String text;

  const RoundText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 1,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: cPrimary,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: myTextStyle(
          fontSize: 12,
          color: cPrimary,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

LatLng? interpolatePosition(List<LatLng> points, DateTime startTime,
    DateTime endTime, DateTime targetTime) {
  // 시간 범위 확인
  if (targetTime.isBefore(startTime) || targetTime.isAfter(endTime)) {
    return null;
  }

  // 총 시간 간격 (초 단위)
  final totalDuration = endTime.difference(startTime).inSeconds;

  // 목표 시간이 시작 시간에서 얼마나 지났는지 (초 단위)
  final elapsedDuration = targetTime.difference(startTime).inSeconds;

  // 경과된 시간 비율 (0.0 ~ 1.0 사이)
  final timeRatio = elapsedDuration / totalDuration;

  // 거리 계산을 위한 도구 (Haversine 공식 사용)
  final latlng2.Distance distance = latlng2.Distance();

  // 전체 경로 길이 계산
  double totalDistance = 0.0;
  List<double> segmentDistances = [];

  for (int i = 0; i < points.length - 1; i++) {
    // double segmentLength = distance(points[i], points[i + 1]);
    double segmentLength = distance(
        latlng2.LatLng(points[i].latitude, points[i].longitude),
        latlng2.LatLng(points[i + 1].latitude, points[i + 1].longitude));
    segmentDistances.add(segmentLength);
    totalDistance += segmentLength;
  }

  // 목표 위치가 전체 경로의 어느 지점인지 계산
  double targetDistance = totalDistance * timeRatio;

  // 해당 지점이 포함된 선분 찾기
  double accumulatedDistance = 0.0;
  for (int i = 0; i < segmentDistances.length; i++) {
    double segmentLength = segmentDistances[i];

    if (accumulatedDistance + segmentLength >= targetDistance) {
      // 현재 선분 내에서의 위치 비율 계산
      double segmentRatio =
          (targetDistance - accumulatedDistance) / segmentLength;

      // 해당 선분 내 위치 보간
      final lat = points[i].latitude +
          (points[i + 1].latitude - points[i].latitude) * segmentRatio;
      final lng = points[i].longitude +
          (points[i + 1].longitude - points[i].longitude) * segmentRatio;

      return LatLng(lat, lng);
    }

    accumulatedDistance += segmentLength;
  }

  return null; // 모든 경로를 지나치면 null
}
