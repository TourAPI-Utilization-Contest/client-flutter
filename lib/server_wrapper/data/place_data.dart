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

@freezed
class PlaceData with _$PlaceData {
  const factory PlaceData({
    required String id, // contentid
    required String title,
    required String address,
    required double latitude,
    required double longitude,
    @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
    Duration? stayTime,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? visitDate,
    String? description,
    String? phoneNumber,
    String? homepage,
    String? tag,
    String? imageUrl,
    String? thumbnailUrl,
    @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson) Color? iconColor,
  }) = _PlaceData;

  factory PlaceData.fromJson(Map<String, dynamic> json) =>
      _$PlaceDataFromJson(json);
}

class PlaceCubit extends Cubit<PlaceData> {
  PlaceCubit(PlaceData state) : super(state);

  void update(PlaceData place) {
    emit(place);
  }
}
