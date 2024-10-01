import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'movement_data.freezed.dart';
part 'movement_data.g.dart';

DateTime _dateTimeFromJson(String date) => DateTime.parse(date);
String _dateTimeToJson(DateTime date) => date.toIso8601String();

Duration _durationFromJson(int duration) => Duration(seconds: duration);
int _durationToJson(Duration duration) => duration.inSeconds;

Duration? _durationWithNullFromJson(int? duration) =>
    duration == null ? null : Duration(seconds: duration);
int? _durationWithNullToJson(Duration? duration) => duration?.inSeconds;

@unfreezed
class MovementData with _$MovementData {
  factory MovementData({
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    required DateTime startTime,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    required DateTime endTime,
    @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
    required Duration duration,
    @JsonKey(
        fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
    Duration? minDuration,
    @JsonKey(
        fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
    Duration? maxDuration,
    double? startLatitude,
    double? startLongitude,
    double? endLatitude,
    double? endLongitude,
    required String method, // 이동수단
    required String source, // 경로 출처(Google, Kakao)
  }) = _MovementData;

  factory MovementData.fromJson(Map<String, dynamic> json) =>
      _$MovementDataFromJson(json);
}

class MovementCubit extends Cubit<MovementData> {
  MovementCubit(MovementData state) : super(state);
}
