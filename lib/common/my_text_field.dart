import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'color.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool autoFocus = true;
  final void Function()? onTap;
  final void Function(PointerDownEvent event)? onTapOutside;
  final void Function(String value)? onSubmitted;
  final void Function(String value)? onChanged;
  final String? hintText;

  MyTextField({
    super.key,
    required this.controller,
    this.focusNode,
    this.onTap,
    this.onTapOutside,
    this.onSubmitted,
    this.onChanged,
    this.hintText,
    // this.hintText = ''
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  String _previousText = '';

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: widget.controller,
      // padding: const MaterialStatePropertyAll<EdgeInsets>(
      //     EdgeInsets.symmetric(horizontal: 16.0)),
      focusNode: widget.focusNode,
      autoFocus: widget.autoFocus,
      onTap: () {
        widget.onTap?.call();
        setState(() {});
      },
      onTapOutside: widget.onTapOutside == null
          ? null
          : (PointerDownEvent event) {
              widget.onTapOutside!(event);
              setState(() {});
            },
      onSubmitted: (value) async {
        widget.onSubmitted?.call(value);
        setState(() {});
      },
      onChanged: (_) {
        // var text = widget.controller.value;
        // if (text.composing.isCollapsed) {
        //   widget.onChanged?.call(text.text);
        // } else {
        //   if (text.text.length > _previousText.length &&
        //       _previousText.isNotEmpty) widget.onChanged?.call(_previousText);
        // }
        // _previousText = text.text;
        widget.onChanged?.call(widget.controller.text);
        setState(() {});
      },
      side: const WidgetStatePropertyAll<BorderSide>(
        BorderSide(
          color: cAqua,
          width: 2.0,
        ),
      ),
      constraints: const BoxConstraints(
        maxHeight: 50.0,
        minHeight: 50.0,
      ),
      backgroundColor: const WidgetStatePropertyAll<Color>(
        cGray2,
      ),
      hintText: widget.hintText,
      hintStyle: const WidgetStatePropertyAll<TextStyle>(
        TextStyle(
          // color: _focusNode.hasFocus ? Colors.black38 : cGray,
          color: cGray,
          fontSize: 16,
          fontFamily: 'NotoSansKR',
          fontVariations: [FontVariation('wght', 200)],
        ),
      ),

      // leading: const Icon(Icons.search),
      // surfaceTintColor: const WidgetStatePropertyAll<Color>(
      //   Colors.white,
      // ),
      overlayColor: const WidgetStatePropertyAll<Color>(
        Colors.transparent,
      ),
      trailing: <Widget>[
        widget.controller.text.isEmpty
            ? Tooltip(
                message: '검색하기',
                child: IconButton(
                  // isSelected: isDark,
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    'assets/icon/search.svg',
                    colorFilter: const ColorFilter.mode(cGray, BlendMode.srcIn),
                    height: 19.9,
                  ),
                ),
              )
            : Tooltip(
                message: '초기화',
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/icon/jam_close_circle_f.svg',
                    colorFilter: const ColorFilter.mode(cGray, BlendMode.srcIn),
                    height: 19.9,
                  ),
                  onPressed: () {
                    // _controller.closeView(null);
                    widget.controller!.clear();
                    setState(() {});
                  },
                ),
              )
      ],
    );
  }
}
