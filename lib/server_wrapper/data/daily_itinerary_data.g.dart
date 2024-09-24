// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_itinerary_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyItinerary _$DailyItineraryFromJson(Map<String, dynamic> json) =>
    DailyItinerary(
      itineraryId: json['itineraryId'] as String,
      date: DailyItinerary._dateTimeFromJson(json['date'] as String),
      places: json['places'] ?? const [],
    );

Map<String, dynamic> _$DailyItineraryToJson(DailyItinerary instance) =>
    <String, dynamic>{
      'itineraryId': instance.itineraryId,
      'date': DailyItinerary._dateTimeToJson(instance.date),
      'places': instance.places.map((e) => e.toJson()).toList(),
    };
