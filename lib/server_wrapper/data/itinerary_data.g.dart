// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itinerary_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItineraryData _$ItineraryDataFromJson(Map<String, dynamic> json) =>
    ItineraryData(
      id: json['id'] as String,
      users: (json['users'] as List<dynamic>).map((e) => e as String).toList(),
      title: json['title'] as String,
      description: json['description'] as String?,
      startDate: ItineraryData._dateTimeFromJson(json['startDate'] as String),
      endDate: ItineraryData._dateTimeFromJson(json['endDate'] as String),
      iconBase64: json['iconBase64'] as String?,
      iconColor:
          ItineraryData._colorFromJson((json['iconColor'] as num).toInt()),
    )..dailyItineraries = (json['dailyItineraries'] as List<dynamic>)
        .map((e) => DailyItinerary.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$ItineraryDataToJson(ItineraryData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'users': instance.users,
      'title': instance.title,
      'description': instance.description,
      'startDate': ItineraryData._dateTimeToJson(instance.startDate),
      'endDate': ItineraryData._dateTimeToJson(instance.endDate),
      'iconBase64': instance.iconBase64,
      'iconColor': ItineraryData._colorToJson(instance.iconColor),
      'dailyItineraries':
          instance.dailyItineraries.map((e) => e.toJson()).toList(),
    };
