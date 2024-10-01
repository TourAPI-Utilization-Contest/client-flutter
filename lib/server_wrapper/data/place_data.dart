import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

part 'place_data.g.dart';

Color _colorFromJson(int? color) => Color(color ?? 0);
int _colorToJson(Color? color) => color?.value ?? 0;

@JsonSerializable()
class PlaceData {
  final String id; //contentid
  final String title;
  final String address;
  final double latitude;
  final double longitude;
  final String? description;
  final String? phoneNumber;
  final String? homepage;
  final String? tag;
  final String? imageUrl;
  final String? thumbnailUrl;
  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final Color? iconColor;

  PlaceData({
    required this.id,
    required this.title,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.description,
    this.phoneNumber,
    this.homepage,
    this.tag,
    this.imageUrl,
    this.thumbnailUrl,
    this.iconColor,
  });

  factory PlaceData.fromJson(Map<String, dynamic> json) =>
      _$PlaceDataFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceDataToJson(this);
}
