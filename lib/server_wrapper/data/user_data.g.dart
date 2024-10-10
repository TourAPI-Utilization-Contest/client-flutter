// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String?,
      nickname: json['nickname'] as String?,
      kakaoId: json['kakaoId'] as String?,
      profileUrl: json['profileUrl'] as String?,
      itineraries: (json['itineraries'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'nickname': instance.nickname,
      'kakaoId': instance.kakaoId,
      'profileUrl': instance.profileUrl,
      'itineraries': instance.itineraries,
    };
