// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaceDataImpl _$$PlaceDataImplFromJson(Map<String, dynamic> json) =>
    _$PlaceDataImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      stayTime: _durationFromJson((json['stayTime'] as num?)?.toInt()),
      description: json['description'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      homepage: json['homepage'] as String?,
      tag: json['tag'] as String?,
      imageUrl: json['imageUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
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
      'description': instance.description,
      'phoneNumber': instance.phoneNumber,
      'homepage': instance.homepage,
      'tag': instance.tag,
      'imageUrl': instance.imageUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'iconColor': _colorToJson(instance.iconColor),
    };
