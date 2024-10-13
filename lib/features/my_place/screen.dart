import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tradule/common/app_bar_blur.dart';
import 'package:tradule/common/color.dart';
import 'package:tradule/common/my_text_field.dart';
import 'package:tradule/common/my_text_style.dart';
import 'package:tradule/common/place_card.dart';
import 'package:tradule/common/single_child_scroll_fade_view.dart';
import 'package:tradule/common/sort_widget.dart';
import 'package:tradule/features/itinerary/screen.dart';
import 'package:tradule/server_wrapper/data/place_data.dart';
import 'package:tradule/server_wrapper/data/user_data.dart';
import 'package:tradule/server_wrapper/server_wrapper.dart';
import 'package:tradule/common/tag_filter_button.dart';

class MyPlaceScreen extends StatefulWidget {
  const MyPlaceScreen({super.key});

  @override
  State<MyPlaceScreen> createState() => _MyPlaceScreenState();
}

class _MyPlaceScreenState extends State<MyPlaceScreen>
    with AutomaticKeepAliveClientMixin<MyPlaceScreen> {
  // final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _selectedAllPlace = true;
  bool _selectedProvidedPlace = false;
  bool _selectedMyPlace = false;
  int _providedPlaceCount = 0;
  int _myPlaceCount = 0;
  // List<PlaceData> _providedPlaceList = [];
  // List<PlaceData> _myPlaceList = [];
  List<PlaceData> _searchedPlaceList = [];
  final List<String> _sortTypes = [
    '추가한 순',
    '이름순',
  ];
  final bool _initialAscending = false;
  bool _lastAscending = false;
  int _lastSortIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('내 장소'),
        // scrollController: _scrollController,
        // clipper: const InvertedCornerClipper(arcRadius: 10),
        // preferredSize: const Size.fromHeight(kToolbarHeight + 10),
      ),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: BlocBuilder<UserCubit, UserData?>(
          builder: (context, userData) {
            if (userData == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            _searchPlace(_searchController.text);

            _providedPlaceCount =
                _searchedPlaceList.where((place) => place.isProvided).length;
            _myPlaceCount =
                _searchedPlaceList.where((place) => !place.isProvided).length;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: <Widget>[
                MyTextField(
                  controller: _searchController,
                  hintText: '장소 이름, 태그로 검색',
                  onSubmitted: (_) {
                    // _searchPlace(_searchController.text);
                    setState(() {});
                  },
                  onChanged: (value) {
                    // _searchPlace(value);
                    setState(() {});
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    // spacing: 8,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          clipBehavior: Clip.none,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            spacing: 8,
                            children: <Widget>[
                              TagFilterButton(
                                text: '전체',
                                badgeText: (_providedPlaceCount + _myPlaceCount)
                                    .toString(),
                                isSelected: _selectedAllPlace,
                                onPressed: () {
                                  setState(() {
                                    _selectedAllPlace = true;
                                    _selectedProvidedPlace = false;
                                    _selectedMyPlace = false;
                                  });
                                },
                              ),
                              TagFilterButton(
                                text: '공개 장소',
                                iconPath: 'assets/icon/search.svg',
                                iconTooltip: '장소 검색',
                                iconOnPressed: () {
                                  Navigator.pushNamed(context, '/search_place');
                                },
                                badgeText: _providedPlaceCount.toString(),
                                isSelected: _selectedProvidedPlace,
                                onPressed: () {
                                  setState(() {
                                    _selectedAllPlace = false;
                                    _selectedProvidedPlace = true;
                                    _selectedMyPlace = false;
                                  });
                                },
                              ),
                              TagFilterButton(
                                text: '나만의 장소',
                                iconPath: 'assets/icon/jam_plus.svg',
                                iconOnPressed: () {
                                  // Navigator.pushNamed(context, '/add_place');
                                  addMyPlace(context);
                                },
                                iconTooltip: '나만의 장소 추가',
                                badgeText: _myPlaceCount.toString(),
                                isSelected: _selectedMyPlace,
                                onPressed: () {
                                  setState(() {
                                    _selectedAllPlace = false;
                                    _selectedProvidedPlace = false;
                                    _selectedMyPlace = true;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SortWidget(
                        sortTypes: _sortTypes,
                        changeSortType: (index, ascending) {
                          _lastSortIndex = index;
                          _lastAscending = ascending;
                          // _sortPlace(index, ascending);
                          setState(() {});
                        },
                        ascending: _initialAscending,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollFadeView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 4),
                      child: Column(
                        spacing: 16,
                        children: <Widget>[
                          for (var place in _searchedPlaceList)
                            if (_selectedAllPlace ||
                                (_selectedProvidedPlace && place.isProvided) ||
                                (_selectedMyPlace && !place.isProvided))
                              PlaceCard(
                                key: ValueKey(place.id),
                                placeData: place,
                              ),
                          if (_searchedPlaceList.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                '더 이상 장소가 없어요!',
                                style: myTextStyle(
                                  color: cPrimaryDark,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          if (_searchedPlaceList.isEmpty)
                            if (_searchController.text.isEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  '아직 추가한 장소가 없어요!',
                                  style: myTextStyle(
                                    color: cPrimaryDark,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                          if (_searchedPlaceList.isEmpty)
                            if (_searchController.text.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  '검색 결과가 없어요!',
                                  style: myTextStyle(
                                    color: cPrimaryDark,
                                    fontSize: 14,
                                  ),
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
      ),
      // // 내 장소 추가 버튼
      // floatingActionButton: Tooltip(
      //   message: '장소 추가',
      //   child: FloatingActionButton(
      //     backgroundColor: cPrimary.withAlpha(130),
      //     hoverColor: cPrimary.withAlpha(150),
      //     shape: const CircleBorder(),
      //     elevation: 0,
      //     hoverElevation: 0,
      //     focusElevation: 0,
      //     highlightElevation: 0,
      //     onPressed: () {
      //       Navigator.pushNamed(context, '/add_place');
      //     },
      //     child: SvgPicture.asset(
      //       'assets/icon/jam_plus.svg',
      //       color: Colors.white,
      //     ),
      //   ),
      // ),
    );
  }

  void _searchPlace(String value) {
    if (value.isEmpty) {
      _searchedPlaceList = ServerWrapper.getUser()!.places.values.toList();
      _sortPlace(_lastSortIndex, _lastAscending);
      return;
    }
    _searchedPlaceList = ServerWrapper.getUser()!
        .places
        .values
        .where((place) =>
            place.title.contains(value) || place.tags.contains(value))
        .toList();
    _sortPlace(_lastSortIndex, _lastAscending);
  }

  void _sortPlace(int index, bool ascending) {
    _lastAscending = ascending;
    _lastSortIndex = index;
    switch (index) {
      case 0:
        // createdTime 기준으로 정렬 (null 값을 처리하고 ascending 적용)
        _searchedPlaceList.sort((a, b) {
          if (a.createdTime == null && b.createdTime == null) {
            return 0; // 둘 다 null이면 같은 순서 유지
          } else if (a.createdTime == null) {
            return ascending ? 1 : -1; // a가 null이면 뒤로 보냄
          } else if (b.createdTime == null) {
            return ascending ? -1 : 1; // b가 null이면 뒤로 보냄
          } else {
            return ascending
                ? a.createdTime!.compareTo(b.createdTime!)
                : b.createdTime!.compareTo(a.createdTime!);
          }
        });
        break;
      case 1:
        // title 기준으로 정렬 (ascending 적용)
        _searchedPlaceList.sort((a, b) {
          return ascending
              ? a.title.compareTo(b.title)
              : b.title.compareTo(a.title);
        });
        break;
    }
  }

  @override
  bool get wantKeepAlive => true;
}

Future<Object?> addMyPlace(BuildContext context) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black.withOpacity(0.2),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation1, animation2) {
      return AddMyPlaceDialog();
    },
  );
}

class AddMyPlaceDialog extends StatefulWidget {
  const AddMyPlaceDialog({super.key});

  @override
  State<AddMyPlaceDialog> createState() => _AddMyPlaceDialogState();
}

class _AddMyPlaceDialogState extends State<AddMyPlaceDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final List<String> _tags = [];
  final List<String> _tagSuggestions = [
    '카페',
    '식당',
    '마트',
    '병원',
    '학교',
    '공원',
    '박물관',
    '도서관',
    '영화관',
    '쇼핑몰',
    '헬스장',
    '수영장',
    '공연장',
  ].toList();
  BitmapDescriptor _markerIcon = BitmapDescriptor.defaultMarker;
  LatLng _markerPosition = const LatLng(37.5662952, 126.9779451);

  @override
  void initState() {
    super.initState();
    svgToBitmapDescriptor('assets/icon/iconamoon_location_pin_fill.svg')
        .then((BitmapDescriptor bitmap) {
      _markerIcon = bitmap;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          Positioned(
            top: padding.top + 50,
            left: 50,
            right: 50,
            bottom: padding.bottom + 50,
            child: Material(
              elevation: 0,
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  spacing: 8,
                  children: <Widget>[
                    Text(
                      '나만의 장소 추가',
                      style: myTextStyle(
                        color: cPrimaryDark,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollFadeView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            spacing: 16,
                            children: <Widget>[
                              MyTextFormField(
                                controller: _titleController,
                                hintText: '장소 이름',
                              ),
                              MyTextFormField(
                                controller: _descriptionController,
                                hintText: '장소 설명',
                              ),
                              // 위경도 표시
                              Row(
                                children: [
                                  Expanded(
                                    child: MyTextFormField(
                                      key: Key('latitude'),
                                      controller: TextEditingController(
                                          text: _markerPosition.latitude
                                              .toString()),
                                      hintText: '위도',
                                      // keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        _markerPosition = LatLng(
                                          double.parse(value),
                                          _markerPosition.longitude,
                                        );
                                        // setState(() {});
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: MyTextFormField(
                                      key: Key('longitude'),
                                      controller: TextEditingController(
                                          text: _markerPosition.longitude
                                              .toString()),
                                      hintText: '경도',
                                      // keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        _markerPosition = LatLng(
                                          _markerPosition.latitude,
                                          double.parse(value),
                                        );
                                        // setState(() {});
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              //구글 지도
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 300,
                                          child: GoogleMap(
                                            gestureRecognizers: {
                                              Factory<OneSequenceGestureRecognizer>(
                                                  () =>
                                                      EagerGestureRecognizer())
                                            },
                                            initialCameraPosition:
                                                const CameraPosition(
                                              target: LatLng(
                                                  37.5662952, 126.9779451),
                                              zoom: 12,
                                            ),
                                            markers: {
                                              Marker(
                                                markerId: const MarkerId('1'),
                                                position: const LatLng(
                                                    37.5662952, 126.9779451),
                                                icon: _markerIcon,
                                                draggable: true,
                                                onDrag: (LatLng latLng) {
                                                  _markerPosition = latLng;
                                                  setState(() {});
                                                },
                                              ),
                                            },
                                          ),
                                        ),
                                        //장소 검색
                                        Positioned(
                                          top: 10,
                                          left: 10,
                                          right: 10,
                                          child: MyTextField(
                                            controller: TextEditingController(),
                                            hintText: '장소 검색',
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '핀을 드래그하여 이동할 수 있어요!',
                                      style: myTextStyle(
                                        color: cPrimary,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),

                              MyTextFormField(
                                controller: _tagController,
                                hintText: '태그 추가',
                                onSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    _tags.add(value);
                                    _tagController.clear();
                                    setState(() {});
                                  }
                                },
                              ),
                              Wrap(
                                spacing: 8,
                                children: <Widget>[
                                  for (var tag in _tags)
                                    Chip(
                                      label: Text(tag),
                                      onDeleted: () => setState(
                                          () => _tags.remove(tag)), // 삭제 기능
                                    ), // 태그 목록
                                ],
                              ),
                              Wrap(
                                spacing: 8,
                                children: <Widget>[
                                  for (var tag in _tagSuggestions)
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                      ),
                                      onPressed: () {
                                        _tags.add(tag);
                                        setState(() {});
                                      },
                                      child: Text(tag),
                                    ), // 태그 추천 목록
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('취소'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            final placeData = PlaceData(
                              id: Random().nextInt(1000000),
                              title: _titleController.text,
                              description: _descriptionController.text,
                              latitude: _markerPosition.latitude,
                              longitude: _markerPosition.longitude,
                              address: '주소 없음',
                              tags: _tags,
                              isProvided: false,
                              createdTime: DateTime.now(),
                            );
                            ServerWrapper.userCubit.addPlace(placeData);
                            ServerWrapper.putMyPlaceList();
                            Navigator.pop(context);
                          },
                          child: const Text('추가'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
