// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movement_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MovementDataImpl _$$MovementDataImplFromJson(Map<String, dynamic> json) =>
    _$MovementDataImpl(
      startTime: _dateTimeFromJson(json['startTime'] as String),
      endTime: _dateTimeFromJson(json['endTime'] as String),
      duration: _durationFromJson((json['duration'] as num).toInt()),
      minDuration:
          _durationWithNullFromJson((json['minDuration'] as num?)?.toInt()),
      maxDuration:
          _durationWithNullFromJson((json['maxDuration'] as num?)?.toInt()),
      distance: (json['distance'] as num).toDouble(),
      startLatitude: (json['startLatitude'] as num?)?.toDouble(),
      startLongitude: (json['startLongitude'] as num?)?.toDouble(),
      endLatitude: (json['endLatitude'] as num?)?.toDouble(),
      endLongitude: (json['endLongitude'] as num?)?.toDouble(),
      method: json['method'] as String,
      source: json['source'] as String,
    );

Map<String, dynamic> _$$MovementDataImplToJson(_$MovementDataImpl instance) =>
    <String, dynamic>{
      'startTime': _dateTimeToJson(instance.startTime),
      'endTime': _dateTimeToJson(instance.endTime),
      'duration': _durationToJson(instance.duration),
      'minDuration': _durationWithNullToJson(instance.minDuration),
      'maxDuration': _durationWithNullToJson(instance.maxDuration),
      'distance': instance.distance,
      'startLatitude': instance.startLatitude,
      'startLongitude': instance.startLongitude,
      'endLatitude': instance.endLatitude,
      'endLongitude': instance.endLongitude,
      'method': instance.method,
      'source': instance.source,
    };
