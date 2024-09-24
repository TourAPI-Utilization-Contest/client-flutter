import 'package:json_annotation/json_annotation.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserData {
  final String id;
  String? email;
  String? name;
  String? kakaoId;
  List<String> itineraries = [];

  UserData({
    required this.id,
    this.email,
    this.name,
    this.kakaoId,
    this.itineraries = const [],
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
