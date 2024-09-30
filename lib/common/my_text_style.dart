import 'package:flutter/material.dart';

//my_text_style.dart

const TextStyle _defaultTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 20,
  letterSpacing: -0.32,
  fontWeight: FontWeight.normal,
  fontFamily: 'NotoSansKR',
);

TextStyle createTextStyle(TextStyle override) {
  var height = override.height ??
      (21 / (override.fontSize ?? _defaultTextStyle.fontSize!));
  return _defaultTextStyle.copyWith(
    height: height,
    color: override.color,
    fontSize: override.fontSize,
    fontFamily: override.fontFamily,
    fontWeight: override.fontWeight,
    fontVariations: [
      FontVariation(
          'wght',
          ((override.fontWeight ?? _defaultTextStyle.fontWeight!).index + 1) *
              100),
    ],
  );
}

TextStyle myTextStyle({
  Color? color,
  double? fontSize,
  double? height,
  double? letterSpacing,
  FontWeight? fontWeight,
  String? fontFamily,
}) {
  height = height ?? (21 / (fontSize ?? _defaultTextStyle.fontSize!));
  var c = _defaultTextStyle.copyWith(
    height: height,
    color: color,
    fontSize: fontSize,
    fontFamily: fontFamily,
    fontWeight: fontWeight,
    letterSpacing: letterSpacing,
    fontVariations: [
      FontVariation('wght',
          ((fontWeight ?? _defaultTextStyle.fontWeight!).index + 1) * 100),
    ],
  );
  return c;
}
