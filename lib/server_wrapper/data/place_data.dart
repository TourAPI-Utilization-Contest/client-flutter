import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'place_data.freezed.dart';
part 'place_data.g.dart';

Color _colorFromJson(int? color) => Color(color ?? 0);
int _colorToJson(Color? color) => color?.value ?? 0;

DateTime? _dateTimeFromJson(String? date) =>
    date != null ? DateTime.parse(date) : null;
String? _dateTimeToJson(DateTime? date) => date?.toIso8601String();

Duration _durationFromJson(int? duration) => Duration(minutes: duration ?? 0);
int _durationToJson(Duration? duration) => duration?.inMinutes ?? 0;

TimeOfDay? _timeOfDayFromJson(String? time) {
  if (time == null) return TimeOfDay(hour: 0, minute: 0);
  final parts = time.split(':');
  return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
}

String? _timeOfDayToJson(TimeOfDay? time) {
  if (time == null) return null;
  return '${time.hour}:${time.minute}';
}

@freezed
class PlaceData with _$PlaceData {
  const factory PlaceData({
    required int id, // contentid
    required String title,
    required String address,
    required double latitude,
    required double longitude,
    @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
    Duration? stayTime,
    @JsonKey(fromJson: _timeOfDayFromJson, toJson: _timeOfDayToJson)
    TimeOfDay? visitTime,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? createdTime,
    String? description,
    String? phoneNumber,
    String? homepage,
    // String? tag,
    @Default([]) List<String> tags,
    String? imageUrl,
    String? thumbnailUrl,
    @Default(false) bool isProvided,
    @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson) Color? iconColor,
    @Default(false)
    @JsonKey(includeFromJson: false, includeToJson: false)
    bool isSelected,
  }) = _PlaceData;

  factory PlaceData.fromJson(Map<String, dynamic> json) =>
      _$PlaceDataFromJson(json);
}

class PlaceCubit extends Cubit<PlaceData> {
  PlaceCubit(super.state);

  void update(PlaceData place) {
    emit(place);
  }
}
