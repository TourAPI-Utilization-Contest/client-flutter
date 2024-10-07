import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: () {
                          print('내 일정에 추가');
                          ServerWrapper.itineraryCubitMapCubit.state['1']!.state
                              .dailyItineraryCubitList[0]
                              .addPlace(
                            PlaceCubit(placeData),
                          );
                        },
                        child: Text(
                          '내 일정에 추가',
                          style: myTextStyle(
                            // height: 17 / 8,
                            height: 1.2,
                            color: Colors.white,
                            fontSize: 8,
                          ),
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
}
