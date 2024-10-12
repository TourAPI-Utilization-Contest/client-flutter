import 'package:flutter/material.dart';

import 'color.dart';
import 'my_text_style.dart';

class TagFilterButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback? onPressed;
  final String? badgeText;

  const TagFilterButton({
    required this.text,
    required this.isSelected,
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
            side: MaterialStateProperty.all(
              BorderSide(
                width: 1,
                color: isSelected ? cPrimaryColor : cGray,
              ),
            ),
            foregroundColor: MaterialStateProperty.all(
              isSelected ? cDark : cGray,
            ),
          ),
          child: Text(
            text,
            style: myTextStyle(
              fontSize: 15,
            ),
          ),
        ),
        if (badgeText != null)
          Positioned(
            right: 0,
            top: 0,
            width: 10,
            height: 10,
            // 클릭 이벤트 무시
            child: IgnorePointer(
              child: Stack(
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: isSelected ? cPrimaryColor : cGray,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0) +
                                const EdgeInsets.only(bottom: 2),
                            child: Text(
                              badgeText!,
                              style: myTextStyle(
                                color: Colors.white,
                                height: 1,
                                fontSize: 12,
                              ),
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
