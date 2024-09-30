// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GW.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchKeyword1RequestData _$SearchKeyword1RequestDataFromJson(
        Map<String, dynamic> json) =>
    SearchKeyword1RequestData(
      numOfRows: (json['numOfRows'] as num?)?.toInt(),
      pageNo: (json['pageNo'] as num?)?.toInt(),
      MobileApp: json['MobileApp'] as String? ?? 'TRADULE',
      type: json['_type'] as String?,
      listYN: json['listYN'] as String?,
      arrange: json['arrange'] as String?,
      keyword: json['keyword'] as String,
      contentTypeId: json['contentTypeId'] as String?,
      areaCode: json['areaCode'] as String?,
      sigunguCode: json['sigunguCode'] as String?,
      cat1: json['cat1'] as String?,
      cat2: json['cat2'] as String?,
      cat3: json['cat3'] as String?,
      serviceKey: json['serviceKey'] as String? ?? gwSearchKeyword1Key,
    );

Map<String, dynamic> _$SearchKeyword1RequestDataToJson(
        SearchKeyword1RequestData instance) =>
    <String, dynamic>{
      'numOfRows': instance.numOfRows,
      'pageNo': instance.pageNo,
      'MobileOS': instance.MobileOS,
      'MobileApp': instance.MobileApp,
      '_type': instance.type,
      'listYN': instance.listYN,
      'arrange': instance.arrange,
      'keyword': instance.keyword,
      'contentTypeId': instance.contentTypeId,
      'areaCode': instance.areaCode,
      'sigunguCode': instance.sigunguCode,
      'cat1': instance.cat1,
      'cat2': instance.cat2,
      'cat3': instance.cat3,
      'serviceKey': instance.serviceKey,
    };
