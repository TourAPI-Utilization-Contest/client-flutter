import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movement_data.g.dart';

@JsonSerializable(explicitToJson: true)
class MovementData {
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime startTime;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime endTime;
  @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
  Duration duration;
  @JsonKey(fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
  Duration? minDuration;
  @JsonKey(fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
  Duration? maxDuration;
  double startLatitude;
  double startLongitude;
  double endLatitude;
  double endLongitude;
  String method; // 이동수단
  String source; // 경로 출처(Google, Kakao)
  //PathData pathData;

  MovementData({
    required this.startTime,
    required this.endTime,
    required this.duration,
    this.minDuration,
    this.maxDuration,
    required this.startLatitude,
    required this.startLongitude,
    required this.endLatitude,
    required this.endLongitude,
    required this.method,
    required this.source,
  });

  static DateTime _dateTimeFromJson(String date) => DateTime.parse(date);
  static String _dateTimeToJson(DateTime date) => date.toIso8601String();

  static Duration _durationFromJson(int duration) =>
      Duration(seconds: duration);
  static int _durationToJson(Duration duration) => duration.inSeconds;

  static Duration? _durationWithNullFromJson(int? duration) =>
      duration == null ? null : Duration(seconds: duration);
  static int? _durationWithNullToJson(Duration? duration) =>
      duration?.inSeconds;

  factory MovementData.fromJson(Map<String, dynamic> json) =>
      _$MovementDataFromJson(json);

  Map<String, dynamic> toJson() => _$MovementDataToJson(this);
}
