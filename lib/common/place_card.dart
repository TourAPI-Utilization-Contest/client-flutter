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

class PlaceCard extends StatelessWidget {
  final PlaceData placeData;
  const PlaceCard({
    required this.placeData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShadowBox(
      child: Padding(
        padding: const EdgeInsets.all(17),
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
                      if (placeData.thumbnailUrl != null &&
                          placeData.thumbnailUrl!.isNotEmpty)
                        Image.network(
                          placeData.thumbnailUrl!,
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
                    placeData.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: myTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          placeData.address,
                          style: myTextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/icon/관심_장소_off.svg',
                        // width: 16,
                        // height: 16,
                      ),
                      const SizedBox(width: 10),
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
                          // print('내 일정에 추가');
                          // // TODO: 일정 선택 다이얼로그
                          // ServerWrapper.itineraryCubitMapCubit.state['1']!.state
                          //     .dailyItineraryCubitList[0]
                          //     .addPlace(
                          //   PlaceCubit(placeData),
                          // );
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
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.2),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) {
        return SelectItineraryWidget(placeData: placeData);
      },
    );
  }

  // Future<Object?> selectDailyItinerary(
  //     BuildContext context, ItineraryCubit itineraryCubit) {
  //   return showGeneralDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     barrierLabel: '',
  //     barrierColor: Colors.black.withOpacity(0.2),
  //     transitionDuration: const Duration(milliseconds: 200),
  //     pageBuilder: (context, animation1, animation2) {
  //       return Stack(
  //         children: [
  //           Positioned(
  //             top: 50,
  //             bottom: 50,
  //             left: 50,
  //             right: 50,
  //             child: Center(
  //               child: Material(
  //                 color: Colors.transparent,
  //                 child: Stack(
  //                   children: [
  //                     Container(
  //                       // width: 300,
  //                       // height: 200,
  //                       padding: const EdgeInsets.all(20),
  //                       decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         borderRadius: BorderRadius.circular(20),
  //                       ),
  //                       child: Column(
  //                         spacing: 10,
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           Text(
  //                             '일정 선택',
  //                             style: myTextStyle(
  //                               fontSize: 20,
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                           ),
  //                           Expanded(
  //                             child: SingleChildScrollFadeView(
  //                               child: Padding(
  //                                 padding: const EdgeInsets.symmetric(
  //                                     horizontal: 10, vertical: 10),
  //                                 child: Column(
  //                                   spacing: 10,
  //                                   children: [
  //                                     for (var dailyItinerary in itineraryCubit
  //                                         .state.dailyItineraryCubitList)
  //                                       ShadowBox(
  //                                         child: Padding(
  //                                           padding: const EdgeInsets.all(10),
  //                                           child: Row(
  //                                             mainAxisAlignment:
  //                                                 MainAxisAlignment
  //                                                     .spaceBetween,
  //                                             children: [
  //                                               Text(
  //                                                 dailyItinerary.state.date
  //                                                     .toString(),
  //                                                 style: myTextStyle(
  //                                                   fontSize: 16,
  //                                                   fontWeight: FontWeight.w500,
  //                                                 ),
  //                                               ),
  //                                               ElevatedButton(
  //                                                 onPressed: () {
  //                                                   // print('장소 추가');
  //                                                   dailyItinerary.addPlace(
  //                                                     PlaceCubit(placeData),
  //                                                   );
  //                                                   Navigator.of(context).pop();
  //                                                 },
  //                                                 child: Text('추가'),
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                       ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           )
  //                         ],
  //                       ),
  //                       //닫기 버튼
  //                     ),
  //                     Positioned(
  //                       top: 10,
  //                       right: 10,
  //                       child: IconButton(
  //                         onPressed: () {
  //                           Navigator.of(context).pop();
  //                         },
  //                         icon: Icon(Icons.close),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
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
          onPressed: () {
            selectedItineraryCubit!.state.dailyItineraryCubitList[day]
                .addPlace(PlaceCubit(widget.placeData));
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

    return Stack(
      children: [
        Positioned(
          top: 50,
          bottom: 50,
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
                                          onBodyPressed: () {
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
