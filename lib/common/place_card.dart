import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tradule/common/itinerary_card.dart';
import 'package:tradule/common/single_child_scroll_fade_view.dart';
import 'package:tradule/server_wrapper/data/daily_itinerary_data.dart';
import 'package:tradule/server_wrapper/data/itinerary_data.dart';
import 'package:tradule/server_wrapper/data/place_data.dart';
import 'package:tradule/server_wrapper/server_wrapper.dart';

import 'my_text_style.dart';
import 'shadow_box.dart';
import 'color.dart';

class PlaceCard extends StatefulWidget {
  final PlaceData placeData;
  const PlaceCard({
    required this.placeData,
    super.key,
  });

  @override
  State<PlaceCard> createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {
  bool isHearted = false;

  @override
  void initState() {
    super.initState();
    isHearted = ServerWrapper.getUser()?.places[widget.placeData.id] != null;
  }

  @override
  Widget build(BuildContext context) {
    return ShadowBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // SvgPicture.asset(
            //   itineraryData.iconPath ?? 'assets/icon/기본.svg',
            //   // color: Theme.of(context).colorScheme.primary,
            // ),
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(54),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1,
                ),
              ),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: cGray4,
                  borderRadius: BorderRadius.circular(54),
                ),
                child: Center(
                  child: Stack(
                    children: [
                      Center(
                        child: SvgPicture.asset(
                          'assets/logo/tradule_text.svg',
                          height: 7,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFFADB0BB),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      if (widget.placeData.thumbnailUrl != null &&
                          widget.placeData.thumbnailUrl!.isNotEmpty)
                        Image.network(
                          widget.placeData.thumbnailUrl!,
                          width: 54,
                          height: 54,
                          fit: BoxFit.cover,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.placeData.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: myTextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          widget.placeData.address,
                          style: myTextStyle(
                            fontSize: 10,
                            color: cGray3,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                      Tooltip(
                        message: '관심 장소',
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            minimumSize: const Size(40, 40),
                          ),
                          onPressed: () {
                            setState(() {
                              if (!ServerWrapper.isLogin()) {
                                Navigator.of(context).pushNamed('/login');
                                return;
                              }
                              if (isHearted) {
                                ServerWrapper.userCubit
                                    .removePlace(widget.placeData);
                              } else {
                                ServerWrapper.userCubit
                                    .addPlace(widget.placeData);
                              }
                              ServerWrapper.putMyPlaceList();
                              isHearted = !isHearted;
                              setState(() {});
                            });
                          },
                          child: isHearted
                              ? SvgPicture.asset(
                                  'assets/icon/관심_장소_on.svg',
                                )
                              : SvgPicture.asset(
                                  'assets/icon/관심_장소_off.svg',
                                ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          overlayColor: Colors.black,
                          foregroundColor: Colors.white,
                          textStyle: myTextStyle(
                            height: 1.2,
                            fontSize: 8,
                            fontWeight: FontWeight.w400,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            // vertical: 10,
                          ),
                          minimumSize: const Size(68, 25),
                          // shadowColor: Colors.transparent,
                        ),
                        onPressed: () {
                          var showGeneralDialogResult =
                              selectItinerary(context);
                        },
                        child: Text(
                          '내 일정에 추가',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Object?> selectItinerary(BuildContext context) {
    //로그인 안되어있으면 로그인 페이지로 이동
    if (ServerWrapper.isLogin() == false) {
      return Navigator.of(context).pushNamed('/login');
    }
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.2),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) {
        return SelectItineraryWidget(placeData: widget.placeData);
      },
    );
  }
}

class SelectItineraryWidget extends StatefulWidget {
  final PlaceData placeData;

  const SelectItineraryWidget({
    required this.placeData,
    super.key,
  });

  @override
  State<SelectItineraryWidget> createState() => _SelectItineraryWidgetState();
}

class _SelectItineraryWidgetState extends State<SelectItineraryWidget>
    with SingleTickerProviderStateMixin {
  ItineraryCubit? selectedItineraryCubit;
  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tab2 = [];
    if (selectedItineraryCubit != null) {
      tabController!.animateTo(1);
      DateTime startDate = selectedItineraryCubit!.state.startDate;
      DateTime endDate = selectedItineraryCubit!.state.endDate;
      int days = endDate.difference(startDate).inDays + 1;
      for (var day = 0; day < days; day++) {
        tab2.add(ShadowBox(
          height: 70,
          onPressed: () async {
            // 일정에 장소 추가
            selectedItineraryCubit!.state.dailyItineraryCubitList[day]
                .addPlace(PlaceCubit(widget.placeData));
            //서버로 전송
            var itineraryId = selectedItineraryCubit!.state.id;
            await ServerWrapper.putScheduleDetail(
              itineraryId,
              selectedItineraryCubit!.state.dailyItineraryCubitList[day],
            );
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Day ${day + 1}',
                  style: myTextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    textAlign: TextAlign.center,
                    DateFormat('yy.MM.dd (E)').format(
                      startDate.add(Duration(days: day)),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: myTextStyle(
                      fontSize: 14,
                      color: cGray3,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
      }
    }

    final padding = MediaQuery.of(context).padding;
    return Stack(
      children: [
        Positioned(
          top: padding.top + 50,
          bottom: padding.bottom + 50,
          left: 50,
          right: 50,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Stack(
                children: [
                  Container(
                    // width: 300,
                    // height: 200,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '추가할 일정 선택',
                          style: myTextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: tabController,
                            children: [
                              SingleChildScrollFadeView(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Column(
                                    spacing: 10,
                                    children: [
                                      for (var itinerary in ServerWrapper
                                          .itineraryCubitMapCubit.state.values)
                                        ItineraryCard(
                                          itineraryCubit: itinerary,
                                          preview: true,
                                          onBodyPressed: () async {
                                            await ServerWrapper
                                                .getScheduleDetailWithClear(
                                              itinerary,
                                            );
                                            selectedItineraryCubit = itinerary;
                                            setState(() {});
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              SingleChildScrollFadeView(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Column(
                                    spacing: 10,
                                    children: tab2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  //닫기 버튼
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.close),
                      color: cGray3,
                    ),
                  ),
                  //뒤로 가기 버튼
                  if (selectedItineraryCubit != null)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: IconButton(
                        onPressed: () {
                          selectedItineraryCubit = null;
                          tabController!.animateTo(0);
                          setState(() {});
                        },
                        padding: const EdgeInsets.all(5),
                        constraints: const BoxConstraints(
                          minWidth: 30,
                          minHeight: 30,
                        ),
                        icon: SvgPicture.asset(
                          'assets/icon/jam_chevron_left.svg',
                          width: 30,
                          height: 30,
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
  }
}
