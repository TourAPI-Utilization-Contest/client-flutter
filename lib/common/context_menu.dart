import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';

import 'color.dart';
import 'my_text_style.dart';

Future<T?> showContextMenu<T>(
  BuildContext context,
  List<ContextMenuItem> items,
  Offset offset,
) async {
  final overlay = Overlay.of(context);
  final completer = Completer<T?>(); // 반환 값을 위한 Completer 생성

  OverlayEntry? overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => Stack(
      children: [
        ModalBarrier(
          color: Colors.transparent,
          dismissible: true,
          onDismiss: () {
            if (!completer.isCompleted) {
              completer.complete(null); // 아무 것도 선택하지 않으면 null 반환
            }
            overlayEntry!.remove();
          },
        ),
        Positioned(
          left: offset.dx,
          top: offset.dy,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
              child: Material(
                elevation: 0,
                color: Colors.white.withAlpha(150),
                child: Container(
                  color: Colors.blue.withAlpha(20),
                  child: IntrinsicWidth(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: items.map((title) {
                        return ListTile(
                          leading: title.icon != null
                              ? Icon(
                                  title.icon,
                                  color: title.color,
                                )
                              : null,
                          title: Text(
                            title.text,
                            style: myTextStyle(
                              color: title.color,
                              fontSize: 14,
                            ),
                          ),
                          onTap: () {
                            completer
                                .complete(title.value); // 선택된 값을 Completer에 저장
                            overlayEntry!.remove();
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
      ],
    ),
  );

  overlay.insert(overlayEntry);

  return completer.future; // 선택된 값을 기다리고 반환
}

class ContextMenuItem<T> {
  final String text;
  final T value;
  final Color color;
  final IconData? icon;

  ContextMenuItem({
    required this.text,
    required this.value,
    this.color = Colors.black,
    this.icon,
  });
}
