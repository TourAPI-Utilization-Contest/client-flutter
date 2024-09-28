// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_itinerary_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyItineraryImpl _$$DailyItineraryImplFromJson(Map<String, dynamic> json) =>
    _$DailyItineraryImpl(
      dailyItineraryId: json['dailyItineraryId'] as String,
      date: _dateTimeFromJson(json['date'] as String),
      places: (json['places'] as List<dynamic>?)
              ?.map((e) => PlaceData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$DailyItineraryImplToJson(
        _$DailyItineraryImpl instance) =>
    <String, dynamic>{
      'dailyItineraryId': instance.dailyItineraryId,
      'date': _dateTimeToJson(instance.date),
      'places': instance.places,
    };
