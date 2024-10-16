// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaceDataImpl _$$PlaceDataImplFromJson(Map<String, dynamic> json) =>
    _$PlaceDataImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      stayTime: _durationFromJson((json['stayTime'] as num?)?.toInt()),
      visitTime: _timeOfDayFromJson(json['visitTime'] as String?),
      createdTime: _dateTimeFromJson(json['createdTime'] as String?),
      description: json['description'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      homepage: json['homepage'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      imageUrl: json['imageUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      isProvided: json['isProvided'] as bool? ?? false,
      iconColor: _colorFromJson((json['iconColor'] as num?)?.toInt()),
    );

Map<String, dynamic> _$$PlaceDataImplToJson(_$PlaceDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'stayTime': _durationToJson(instance.stayTime),
      'visitTime': _timeOfDayToJson(instance.visitTime),
      'createdTime': _dateTimeToJson(instance.createdTime),
      'description': instance.description,
      'phoneNumber': instance.phoneNumber,
      'homepage': instance.homepage,
      'tags': instance.tags,
      'imageUrl': instance.imageUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'isProvided': instance.isProvided,
      'iconColor': _colorToJson(instance.iconColor),
    };
