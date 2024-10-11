import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:tradule/server_wrapper/data/itinerary_data.dart';

import 'my_text_style.dart';
import 'shadow_box.dart';
import 'color.dart';

class ItineraryCard extends StatefulWidget {
  final ItineraryCubit itineraryCubit;
  final void Function()? onBodyPressed;
  final void Function()? onEditPressed;
  final bool preview;

  const ItineraryCard({
    super.key,
    required this.itineraryCubit,
    this.onBodyPressed,
    this.onEditPressed,
    this.preview = false,
  });

  @override
  _ItineraryCardState createState() => _ItineraryCardState();
}

class _ItineraryCardState extends State<ItineraryCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ItineraryCubit>.value(
      value: widget.itineraryCubit,
      child: BlocBuilder<ItineraryCubit, ItineraryData?>(
        builder: (context, itineraryData) {
          String startDate =
              DateFormat('yyyy.MM.dd').format(itineraryData!.startDate);
          String endDate =
              DateFormat('yyyy.MM.dd').format(itineraryData.endDate);
          String dateRange = '$startDate   -   $endDate';
          return Stack(
            children: [
              ShadowBox(
                onPressed: widget.onBodyPressed,
                height: widget.preview ? 70 : 100,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    itineraryData.iconColor.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  color: itineraryData.iconColor,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: itineraryData.iconColor
                                        .withOpacity(0.1),
                                    blurRadius: 1,
                                    spreadRadius: 6,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: SvgPicture.asset(
                                itineraryData.iconPath ?? 'assets/icon/기본.svg',
                                width: widget.preview ? 30 : 40,
                                colorFilter: ColorFilter.mode(
                                  itineraryData.iconColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                spacing: widget.preview ? 0 : 4,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: Text(
                                          itineraryData.title, // 여행 제목
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: myTextStyle(
                                            fontSize: widget.preview ? 16 : 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      if (!widget.preview)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4.0), // 텍스트와 아이콘 간의 최소 간격
                                          child: IconButton(
                                            icon: SvgPicture.asset(
                                              'assets/icon/jam_pencil_f.svg',
                                              width: 20,
                                            ),
                                            onPressed: () {
                                              if (widget.onEditPressed !=
                                                  null) {
                                                widget.onEditPressed!();
                                              }
                                            },
                                            padding: const EdgeInsets.all(4),
                                            constraints: const BoxConstraints(
                                              minWidth: 0,
                                              minHeight: 0,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  Text(
                                    dateRange, // 여행 기간
                                    style: myTextStyle(
                                      color: cGray3,
                                      fontSize: widget.preview ? 10 : 12,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // IconButton(
                      //   onPressed: () {
                      //     setState(() {
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => ItineraryInfoScreen(
                      //               itineraryCubit: widget.itineraryCubit),
                      //         ),
                      //       );
                      //     });
                      //   },
                      //   icon: SvgPicture.asset(
                      //     'assets/icon/jam_write.svg',
                      //   ),
                      // ),
                      if (!widget.preview)
                        SvgPicture.asset(
                          'assets/icon/jam_write.svg',
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
  }
}
