// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_itinerary_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyItineraryImpl _$$DailyItineraryImplFromJson(Map<String, dynamic> json) =>
    _$DailyItineraryImpl(
      dailyItineraryId: json['dailyItineraryId'] as String,
      date: _dateTimeFromJson(json['date'] as String),
      placeList: json['placeList'] == null
          ? const []
          : _placeDataCubitListFromJson(json['placeList'] as List),
      movementList: json['movementList'] == null
          ? const []
          : _movementCubitFromJson(json['movementList'] as List),
    );

Map<String, dynamic> _$$DailyItineraryImplToJson(
        _$DailyItineraryImpl instance) =>
    <String, dynamic>{
      'dailyItineraryId': instance.dailyItineraryId,
      'date': _dateTimeToJson(instance.date),
      'placeList': _placeDataCubitListToJson(instance.placeList),
      'movementList': _movementCubitToJson(instance.movementList),
    };
