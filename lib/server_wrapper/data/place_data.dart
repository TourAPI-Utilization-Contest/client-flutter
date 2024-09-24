import 'package:json_annotation/json_annotation.dart';

part 'place_data.g.dart';

@JsonSerializable()
class PlaceData {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? description;
  final String? phoneNumber;
  final String? homepage;
  final String? category;
  final String? iconBase64; // svg icon
  final int iconColor;

  PlaceData({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.description,
    this.phoneNumber,
    this.homepage,
    this.category,
    this.iconBase64,
    required this.iconColor,
  });

  factory PlaceData.fromJson(Map<String, dynamic> json) =>
      _$PlaceDataFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceDataToJson(this);
}
