import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tradule/common/my_text_style.dart';
import 'package:tradule/features/search/screen.dart';

import 'color.dart';

Widget searchTextField(BuildContext context,
    {required bool readOnly,
    void Function(String value)? onEnter,
    void Function(String value)? onChange}) {
  FocusNode _focusNode = FocusNode();
  TextEditingController _searchController = TextEditingController();
  String previousText = '';

  return MouseRegion(
    cursor: readOnly ? SystemMouseCursors.click : SystemMouseCursors.basic,
    child: GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: readOnly
          ? () {
              _go(context);
            }
          : null,
      child: Container(
        height: 50,
        // padding: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.only(left: 16, right: 6),
        decoration: BoxDecoration(
          // color: const Color(0xFFF8F8F8),
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            // color: Theme.of(context).colorScheme.primary,
            color: const Color(0xFF9CEFFF),
            width: 2,
          ),
          boxShadow: readOnly
              ? const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                    blurRadius: 2,
                    offset: Offset(1, 1),
                  ),
                ]
              : null,
        ),
        child: IgnorePointer(
          ignoring: readOnly,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: KeyboardListener(
                    focusNode: _focusNode,
                    onKeyEvent: (event) {
                      if (!readOnly) return;
                      if (event is KeyDownEvent &&
                          event.logicalKey == LogicalKeyboardKey.enter) {
                        _go(context); // 엔터 키 눌렀을 때 실행할 동작
                      }
                    },
                    child: TextField(
                      autofocus: !readOnly,
                      readOnly: readOnly,
                      controller: _searchController,
                      onChanged: (value) {
                        var text = _searchController.value;
                        if (text.composing.isCollapsed) {
                          onChange?.call(text.text);
                        } else {
                          if (text.text.length > previousText.length) {
                            onChange?.call(text.text);
                          }
                        }
                        previousText = text.text;
                      },
                      onSubmitted: !readOnly ? onEnter : null,
                      decoration: InputDecoration(
                        hintText: '어디로 떠나볼까요?',
                        hintStyle: myTextStyle(
                          color: cGray,
                          fontSize: 16,
                          fontWeight: FontWeight.w200,
                          // fontFamily: 'NotoSansKR',
                          // fontVariations: [FontVariation('wght', 200)],
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => onEnter?.call(_searchController.text),
                icon: SvgPicture.asset(
                  'assets/icon/search.svg',
                  colorFilter: const ColorFilter.mode(cGray, BlendMode.srcIn),
                  height: 19.9,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

void _go(BuildContext context) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SearchScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 0.03);
        const end = Offset(0.0, 0.0);
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    ),
  );
}

// void previwSearch(String value) {
//   print('미리보기 검색어: $value');
// }
//
// void enterSearch(String value) {
//   print('검색어: $value');
// }
