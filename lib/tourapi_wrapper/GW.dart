import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

import 'key.dart';

part 'GW.g.dart';

String _getMobileOS() {
  if (kIsWeb) {
    return 'WEB';
  } else if (Platform.isIOS) {
    return 'IOS';
  } else if (Platform.isAndroid) {
    return 'AND';
  } else if (Platform.isWindows) {
    return 'WIN';
  } else {
    return 'ETC'; // 기타 OS
  }
}

@JsonSerializable()
class SearchKeyword1RequestData {
  final int? numOfRows;
  final int? pageNo;
  @JsonKey(includeToJson: true)
  final String MobileOS;
  final String MobileApp;
  @JsonKey(name: '_type')
  final String? type;
  final String? listYN;
  final String? arrange;
  final String keyword;
  final String? contentTypeId;
  final String? areaCode;
  final String? sigunguCode;
  final String? cat1;
  final String? cat2;
  final String? cat3;
  final String serviceKey;

  SearchKeyword1RequestData({
    this.numOfRows,
    this.pageNo,
    this.MobileApp = 'TRADULE',
    this.type,
    this.listYN,
    this.arrange,
    required this.keyword,
    this.contentTypeId,
    this.areaCode,
    this.sigunguCode,
    this.cat1,
    this.cat2,
    this.cat3,
    this.serviceKey = gwSearchKeyword1Key,
  }) : MobileOS = _getMobileOS();

  factory SearchKeyword1RequestData.fromJson(Map<String, dynamic> json) =>
      _$SearchKeyword1RequestDataFromJson(json);

  Map<String, dynamic> toJson() => _$SearchKeyword1RequestDataToJson(this);
}

Future<String> searchKeyword1Request(SearchKeyword1RequestData data) async {
  final queryParameters = data.toJson();
  queryParameters.removeWhere((key, value) => value == null);
  final stringQueryParameters =
      queryParameters.map((key, value) => MapEntry(key, value.toString()));
  final uri = Uri.https('api.visitkorea.or.kr',
      '/openapi/service/rest/KorService/searchKeyword', stringQueryParameters);
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    return utf8.decode(response.bodyBytes);
  } else {
    throw Exception('Failed to load data');
  }
}
