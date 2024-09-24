// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceData _$PlaceDataFromJson(Map<String, dynamic> json) => PlaceData(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      description: json['description'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      homepage: json['homepage'] as String?,
      category: json['category'] as String?,
      iconBase64: json['iconBase64'] as String?,
      iconColor: (json['iconColor'] as num).toInt(),
    );

Map<String, dynamic> _$PlaceDataToJson(PlaceData instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'description': instance.description,
      'phoneNumber': instance.phoneNumber,
      'homepage': instance.homepage,
      'category': instance.category,
      'iconBase64': instance.iconBase64,
      'iconColor': instance.iconColor,
    };
