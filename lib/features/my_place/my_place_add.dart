import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tradule/common/app_bar_blur.dart';
import 'package:tradule/common/color.dart';
import 'package:tradule/common/my_text_field.dart';
import 'package:tradule/common/my_text_style.dart';
import 'package:tradule/common/place_card.dart';
import 'package:tradule/common/single_child_scroll_fade_view.dart';
import 'package:tradule/common/sort_widget.dart';
import 'package:tradule/server_wrapper/data/place_data.dart';
import 'package:tradule/server_wrapper/data/user_data.dart';
import 'package:tradule/server_wrapper/server_wrapper.dart';
import 'package:tradule/common/tag_filter_button.dart';

class MyPlaceAddScreen extends StatefulWidget {
  const MyPlaceAddScreen({super.key});

  @override
  State<MyPlaceAddScreen> createState() => _MyPlaceAddScreenState();
}

class _MyPlaceAddScreenState extends State<MyPlaceAddScreen> {
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
                                  Navigator.pushNamed(context, '/add_place');
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
}
