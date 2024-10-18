import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'dart:convert';

import 'congestion_place.dart';

List<List<dynamic>> globalCongestionCsvData = [];
Future<bool> fetchCongestionData() async {
  if (globalCongestionCsvData.isNotEmpty) return true;
  final response =
      await http.get(Uri.parse('https://congestion-iubedabnlq-du.a.run.app'));

  if (response.statusCode == 200) {
    final csvBody = response.body;
    List<List<dynamic>> csvTable =
        CsvToListConverter().convert(csvBody, eol: '\n');
    globalCongestionCsvData = csvTable;
    return true;
  } else {
    print('Failed to load congestion data');
  }
  return false;
}

class CongestionData {
  final DateTime time;
  final double minCongestion;
  final double maxCongestion;
  final String level;
  final Color fillColor;
  final Color strokeColor;
  final double latitude;
  final double longitude;

  CongestionData(
      {required this.time,
      required this.minCongestion,
      required this.maxCongestion,
      required this.level,
      required this.fillColor,
      required this.strokeColor,
      required this.latitude,
      required this.longitude});
}

List<CongestionData> getAllCongestionData(DateTime time) {
  if (globalCongestionCsvData.isEmpty) return [];
  List<CongestionData> congestionDataList = [];
  int weekday = time.weekday;
  int rowIdx = (weekday - 1) * 24 * 12 + time.hour * 12 + time.minute ~/ 5 + 1;
  if (rowIdx >= globalCongestionCsvData.length) return [];
  var row = globalCongestionCsvData[rowIdx];
  var length = globalCongestionPlaceList.length;
  for (var i = 0; i < length; i++) {
    Map<String, dynamic> place = globalCongestionPlaceList[i];
    Color fillColor;
    var level = row[i * 3 + 1];
    switch (level) {
      case '여유':
        fillColor = const Color(0xFF9CEFFF).withOpacity(0.3);
        break;
      case '보통':
        fillColor = const Color(0xFFC8FF9C).withOpacity(0.3);
        break;
      case '약간 붐빔':
        fillColor = const Color(0xFFFFD29C).withOpacity(0.3);
        break;
      case '붐빔':
        fillColor = const Color(0xFFFF9C9C).withOpacity(0.3);
        break;
      default:
        fillColor = Colors.grey.withOpacity(0.3);
    }
    Color strokeColor;
    switch (level) {
      case '여유':
        strokeColor = const Color(0xFF0BB2D1);
        break;
      case '보통':
        strokeColor = const Color(0xFF09AB19);
        break;
      case '약간 붐빔':
        strokeColor = const Color(0xFFFFA63D);
        break;
      case '붐빔':
        strokeColor = const Color(0xFFFF8686);
        break;
      default:
        strokeColor = Colors.grey;
    }
    congestionDataList.add(CongestionData(
        time: time,
        minCongestion: row[i * 3 + 2],
        maxCongestion: row[i * 3 + 3],
        level: level,
        fillColor: fillColor,
        strokeColor: strokeColor,
        latitude: place['latitude'],
        longitude: place['longitude']));
  }
  return congestionDataList;
}
