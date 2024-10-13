// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movement_detail_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MovementDetailDataImpl _$$MovementDetailDataImplFromJson(
        Map<String, dynamic> json) =>
    _$MovementDetailDataImpl(
      duration: _durationFromJson((json['duration'] as num).toInt()),
      distance: (json['distance'] as num).toDouble(),
      path: json['path'] as String,
      method: json['method'] as String,
      source: json['source'] as String,
      stopCount: (json['stopCount'] as num?)?.toInt(),
      busNumber: json['busNumber'] as String?,
    );

Map<String, dynamic> _$$MovementDetailDataImplToJson(
        _$MovementDetailDataImpl instance) =>
    <String, dynamic>{
      'duration': _durationToJson(instance.duration),
      'distance': instance.distance,
      'path': instance.path,
      'method': instance.method,
      'source': instance.source,
      'stopCount': instance.stopCount,
      'busNumber': instance.busNumber,
    };
