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
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      iconBase64: json['iconBase64'] as String?,
      iconColor: _colorFromJson((json['iconColor'] as num).toInt()),
    )..dailyItineraries = (json['dailyItineraries'] as List<dynamic>)
        .map((e) => DailyItinerary.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$ItineraryDataToJson(ItineraryData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'users': instance.users,
      'title': instance.title,
      'description': instance.description,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'iconBase64': instance.iconBase64,
      'iconColor': _colorToJson(instance.iconColor),
      'dailyItineraries':
          instance.dailyItineraries.map((e) => e.toJson()).toList(),
    };
