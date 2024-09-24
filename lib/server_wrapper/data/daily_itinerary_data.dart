import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'place_data.dart';

part 'daily_itinerary_data.g.dart';

@JsonSerializable(explicitToJson: true)
class DailyItinerary {
  String itineraryId;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime date;
  List<PlaceData> places = [];

  DailyItinerary({
    required this.itineraryId,
    required this.date,
    places = const [],
  });

  static DateTime _dateTimeFromJson(String date) => DateTime.parse(date);
  static String _dateTimeToJson(DateTime date) => date.toIso8601String();

  factory DailyItinerary.fromJson(Map<String, dynamic> json) =>
      _$DailyItineraryFromJson(json);

  Map<String, dynamic> toJson() => _$DailyItineraryToJson(this);
}
