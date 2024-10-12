// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserDataImpl _$$UserDataImplFromJson(Map<String, dynamic> json) =>
    _$UserDataImpl(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String?,
      nickname: json['nickname'] as String?,
      kakaoId: json['kakaoId'] as String?,
      profileUrl: json['profileUrl'] as String?,
      itineraries: (json['itineraries'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      places: (json['places'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                int.parse(k), PlaceData.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

Map<String, dynamic> _$$UserDataImplToJson(_$UserDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'nickname': instance.nickname,
      'kakaoId': instance.kakaoId,
      'profileUrl': instance.profileUrl,
      'itineraries': instance.itineraries,
      'places':
          instance.places.map((k, e) => MapEntry(k.toString(), e.toJson())),
    };
