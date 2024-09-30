import 'package:json_annotation/json_annotation.dart';

part 'place_data.g.dart';

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
  final String? imageUrl; // svg icon
  final int iconColor;

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
    required this.iconColor,
  });

  factory PlaceData.fromJson(Map<String, dynamic> json) =>
      _$PlaceDataFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceDataToJson(this);
}
