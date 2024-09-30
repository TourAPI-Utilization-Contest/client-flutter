import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tradule/server_wrapper/data/place_data.dart';

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
            placeData.imageUrl!.isEmpty
                ? Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: cGray4,
                      borderRadius: BorderRadius.circular(54),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Stack(
                        children: [
                          SvgPicture.asset(
                            'assets/logo/tradule_text.svg',
                            height: 7,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFFADB0BB),
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Image.network(
                    placeData.imageUrl!,
                    width: 54,
                    height: 54,
                  ),
            const SizedBox(width: 32),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  placeData.title,
                  style: myTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      placeData.address,
                      style: myTextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/icon/관심_장소_off.svg',
                      // width: 16,
                      // height: 16,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        textStyle: myTextStyle(
                          height: 1.2,
                          fontSize: 8,
                          fontWeight: FontWeight.w400,
                        ),
                        minimumSize: Size(46, 17),
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () {
                        print('관심장소');
                      },
                      child: Text(
                        '내 일정에 추가',
                        style: myTextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
