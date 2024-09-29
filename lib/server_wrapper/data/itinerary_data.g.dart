// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itinerary_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ItineraryDataImpl _$$ItineraryDataImplFromJson(Map<String, dynamic> json) =>
    _$ItineraryDataImpl(
      id: json['id'] as String,
      users: (json['users'] as List<dynamic>).map((e) => e as String).toList(),
      title: json['title'] as String,
      description: json['description'] as String?,
      startDate: _dateTimeFromJson(json['startDate'] as String),
      endDate: _dateTimeFromJson(json['endDate'] as String),
      iconBase64: json['iconBase64'] as String?,
      iconColor: _colorFromJson((json['iconColor'] as num).toInt()),
      dailyItineraries: (json['dailyItineraries'] as List<dynamic>?)
              ?.map((e) => DailyItinerary.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ItineraryDataImplToJson(_$ItineraryDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'users': instance.users,
      'title': instance.title,
      'description': instance.description,
      'startDate': _dateTimeToJson(instance.startDate),
      'endDate': _dateTimeToJson(instance.endDate),
      'iconBase64': instance.iconBase64,
      'iconColor': _colorToJson(instance.iconColor),
      'dailyItineraries': instance.dailyItineraries,
    };
