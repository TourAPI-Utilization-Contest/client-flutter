import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'movement_detail_data.dart';

part 'movement_data.freezed.dart';
part 'movement_data.g.dart';

DateTime _dateTimeFromJson(String date) => DateTime.parse(date);
String _dateTimeToJson(DateTime date) => date.toIso8601String();

Duration _durationFromJson(int duration) => Duration(seconds: duration);
int _durationToJson(Duration duration) => duration.inSeconds;

Duration? _durationWithNullFromJson(int? duration) =>
    duration == null ? null : Duration(seconds: duration);
int? _durationWithNullToJson(Duration? duration) => duration?.inSeconds;

@freezed
class MovementData with _$MovementData {
  @JsonSerializable(explicitToJson: true)
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
    required double distance,
    double? startLatitude,
    double? startLongitude,
    double? endLatitude,
    double? endLongitude,
    required String method, // 이동수단
    required String source, // 경로 출처(Google, Kakao)
    @Default([]) List<MovementDetailData> details,
    @Default(false)
    @JsonKey(includeFromJson: false, includeToJson: false)
    bool processing,
  }) = _MovementData;

  factory MovementData.initial() => MovementData(
        startTime: DateTime(1970, 1, 1, 0, 0),
        endTime: DateTime(1970, 1, 1, 0, 0),
        duration: Duration.zero,
        minDuration: null,
        maxDuration: null,
        distance: 0,
        startLatitude: null,
        startLongitude: null,
        endLatitude: null,
        endLongitude: null,
        method: 'work',
        source: 'unknown',
      );

  factory MovementData.fromJson(Map<String, dynamic> json) =>
      _$MovementDataFromJson(json);
}

class MovementCubit extends Cubit<MovementData> {
  MovementCubit(super.state) {
    print('MovementCubit: $state');
  }

  void update(MovementData movement) {
    emit(movement);
  }
}
