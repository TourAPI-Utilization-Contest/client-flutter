// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movement_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovementData _$MovementDataFromJson(Map<String, dynamic> json) => MovementData(
      startTime: MovementData._dateTimeFromJson(json['startTime'] as String),
      endTime: MovementData._dateTimeFromJson(json['endTime'] as String),
      duration:
          MovementData._durationFromJson((json['duration'] as num).toInt()),
      minDuration: MovementData._durationWithNullFromJson(
          (json['minDuration'] as num?)?.toInt()),
      maxDuration: MovementData._durationWithNullFromJson(
          (json['maxDuration'] as num?)?.toInt()),
      startLatitude: (json['startLatitude'] as num).toDouble(),
      startLongitude: (json['startLongitude'] as num).toDouble(),
      endLatitude: (json['endLatitude'] as num).toDouble(),
      endLongitude: (json['endLongitude'] as num).toDouble(),
      method: json['method'] as String,
      source: json['source'] as String,
    );

Map<String, dynamic> _$MovementDataToJson(MovementData instance) =>
    <String, dynamic>{
      'startTime': MovementData._dateTimeToJson(instance.startTime),
      'endTime': MovementData._dateTimeToJson(instance.endTime),
      'duration': MovementData._durationToJson(instance.duration),
      'minDuration': MovementData._durationWithNullToJson(instance.minDuration),
      'maxDuration': MovementData._durationWithNullToJson(instance.maxDuration),
      'startLatitude': instance.startLatitude,
      'startLongitude': instance.startLongitude,
      'endLatitude': instance.endLatitude,
      'endLongitude': instance.endLongitude,
      'method': instance.method,
      'source': instance.source,
    };
