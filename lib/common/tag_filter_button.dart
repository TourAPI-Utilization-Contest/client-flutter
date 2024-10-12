import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'color.dart';
import 'my_text_style.dart';

class TagFilterButton extends StatelessWidget {
  final String text;
  // final Widget child;
  // final Widget? icon;
  final String? iconPath;
  final String? iconTooltip;
  final VoidCallback? iconOnPressed;
  final bool isSelected;
  final VoidCallback? onPressed;
  final String? badgeText;

  const TagFilterButton({
    required this.text,
    // required this.child,
    required this.isSelected,
    // this.icon,
    this.iconPath,
    this.iconTooltip,
    this.iconOnPressed,
    this.onPressed,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
            padding: iconPath == null
                ? null
                : WidgetStatePropertyAll(
                    EdgeInsets.only(top: 6, bottom: 6, left: 12, right: 6),
                  ),
            minimumSize: iconPath == null
                ? null
                : WidgetStatePropertyAll(
                    Size.zero,
                  ),
            side: WidgetStatePropertyAll(
              BorderSide(
                width: 1,
                color: isSelected ? cPrimary : cGray,
              ),
            ),
            foregroundColor: WidgetStatePropertyAll(
              isSelected ? cDark : cGray,
            ),
          ),
          // child: Text(
          //   text,
          //   style: myTextStyle(
          //     fontSize: 15,
          //   ),
          // ),
          child: Row(
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              if (iconPath != null) ...[
                Tooltip(
                  message: iconTooltip ?? '',
                  child: IconButton(
                    // onPressed: () {
                    //   Navigator.pushNamed(context, '/search');
                    // },
                    onPressed: iconOnPressed,
                    style: ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.all(8)),
                      minimumSize: WidgetStatePropertyAll(
                        Size.zero,
                      ),
                      maximumSize: WidgetStatePropertyAll(
                        Size(32, 32),
                      ),
                    ),
                    icon: SvgPicture.asset(
                      iconPath!,
                      color: isSelected ? cPrimary : cGray,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (badgeText != null)
          Positioned(
            right: 2,
            top: 4,
            width: 0,
            height: 0,
            // 클릭 이벤트 무시
            child: IgnorePointer(
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    width: 100,
                    height: 100,
                    child: Container(
                      alignment: Alignment.center,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected ? cPrimary : cGray,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0) +
                              const EdgeInsets.only(bottom: 1.2),
                          child: Text(
                            badgeText!,
                            style: myTextStyle(
                              color: Colors.white,
                              height: 0.8,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
