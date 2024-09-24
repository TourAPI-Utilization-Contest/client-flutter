import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'daily_itinerary_data.dart';

part 'itinerary_data.g.dart';

@JsonSerializable(explicitToJson: true)
class ItineraryData {
  String id;
  List<String> users;
  String title;
  String? description;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime startDate;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime endDate;
  // String? category;
  String? iconBase64; // svg icon
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color iconColor;
  List<DailyItinerary> dailyItineraries = [];

  ItineraryData({
    required this.id,
    required this.users,
    required this.title,
    this.description,
    required this.startDate,
    required this.endDate,
    // this.category,
    this.iconBase64,
    required this.iconColor,
  });

  static DateTime _dateTimeFromJson(String date) => DateTime.parse(date);
  static String _dateTimeToJson(DateTime date) => date.toIso8601String();

  static Color _colorFromJson(int color) => Color(color);
  static int _colorToJson(Color color) => color.value;

  factory ItineraryData.fromJson(Map<String, dynamic> json) =>
      _$ItineraryDataFromJson(json);

  Map<String, dynamic> toJson() => _$ItineraryDataToJson(this);
}
