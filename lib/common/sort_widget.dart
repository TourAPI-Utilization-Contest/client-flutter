import 'dart:ui';

import 'package:flutter/material.dart';

import 'color.dart';
import 'my_text_style.dart';

class SortWidget extends StatefulWidget {
  final List<String> sortTypes;
  final void Function(int, bool) changeSortType;
  final bool ascending;

  SortWidget({
    required this.sortTypes,
    required this.changeSortType,
    this.ascending = true,
  });

  @override
  _SortWidgetState createState() => _SortWidgetState();
}

class _SortWidgetState extends State<SortWidget>
    with SingleTickerProviderStateMixin {
  bool ascending = true;
  int selectedSortTypeIndex = 0;
  OverlayEntry? _overlayEntry;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _sizeAnimation;
  double screenWidth = 0;

  @override
  void initState() {
    super.initState();
    ascending = widget.ascending;

    // 애니메이션 컨트롤러 초기화
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300), // 애니메이션 지속 시간
    );

    // 투명도 애니메이션
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // 높이 애니메이션
    _sizeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  void _toggleSortMenu(BuildContext context) {
    if (_overlayEntry != null) {
      _controller.reverse().then((_) => _removeOverlay()); // 닫힐 때 애니메이션
      return;
    }

    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    screenWidth = MediaQuery.of(context).size.width;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          ModalBarrier(
            color: Colors.transparent,
            dismissible: true,
            onDismiss: () {
              _controller.reverse().then((_) => _removeOverlay());
            },
          ),
          Positioned(
            right: screenWidth - (offset.dx + size.width),
            top: offset.dy + size.height,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SizeTransition(
                sizeFactor: _sizeAnimation, // 높이 애니메이션 추가
                axisAlignment: -1.0, // 위에서 아래로 커지도록 설정
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                  child: Material(
                    elevation: 0,
                    color: Colors.white.withAlpha(150),
                    child: Container(
                      color: cPrimaryDark.withAlpha(20),
                      child: IntrinsicWidth(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children:
                              widget.sortTypes.asMap().entries.map((entry) {
                            return ListTile(
                              title: Text(
                                entry.value,
                                style: myTextStyle(
                                  color: entry.key == selectedSortTypeIndex
                                      ? Colors.blue
                                      : Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  selectedSortTypeIndex = entry.key;
                                  widget.changeSortType(
                                      selectedSortTypeIndex, ascending);
                                  _controller.reverse().then(
                                      (_) => _removeOverlay()); // 닫힐 때 애니메이션
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _controller.forward(); // 열릴 때 애니메이션
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            minimumSize: MaterialStateProperty.all(Size.zero),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 3, left: 12),
                child: Text(
                  widget.sortTypes[selectedSortTypeIndex],
                  style: myTextStyle(
                    color: cPrimaryDark,
                    fontSize: 11,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    ascending = !ascending;
                    widget.changeSortType(selectedSortTypeIndex, ascending);
                  });
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                  minimumSize: MaterialStateProperty.all(Size.zero),
                ),
                child: Icon(
                  ascending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: cPrimaryDark,
                  size: 22,
                ),
              ),
            ],
          ),
          onPressed: () {
            _toggleSortMenu(context); // 메뉴 토글
          },
        ),
      ],
    );
  }
}
