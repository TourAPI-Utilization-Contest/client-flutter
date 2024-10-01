import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'place_data.dart';

part 'daily_itinerary_data.freezed.dart';
part 'daily_itinerary_data.g.dart';

// @JsonSerializable(explicitToJson: true)
// class DailyItinerary {
//   String dailyItineraryId;
//   @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
//   DateTime date;
//   List<PlaceData> places = [];
//
//   DailyItinerary({
//     required this.dailyItineraryId,
//     required this.date,
//     places = const [],
//   });
//
//   shiftDate(int shiftDays) {
//     return DailyItinerary(
//       dailyItineraryId: dailyItineraryId,
//       date: date.add(Duration(days: shiftDays)),
//       places: places,
//     );
//   }
//
//   static DateTime _dateTimeFromJson(String date) => DateTime.parse(date);
//   static String _dateTimeToJson(DateTime date) => date.toIso8601String();
//
//   factory DailyItinerary.fromJson(Map<String, dynamic> json) =>
//       _$DailyItineraryFromJson(json);
//
//   Map<String, dynamic> toJson() => _$DailyItineraryToJson(this);
// }

DateTime _dateTimeFromJson(String date) => DateTime.parse(date);
String _dateTimeToJson(DateTime date) => date.toIso8601String();

@freezed
class DailyItineraryData with _$DailyItinerary {
  const factory DailyItineraryData({
    required String dailyItineraryId,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    required DateTime date,
    @Default([]) List<PlaceData> places,
  }) = _DailyItinerary;

  const DailyItineraryData._();
  DailyItineraryData shiftDate(int shiftDays) {
    return copyWith(date: date.add(Duration(days: shiftDays)));
  }

  factory DailyItineraryData.fromJson(Map<String, dynamic> json) =>
      _$DailyItineraryFromJson(json);
}

class DailyItineraryCubit extends Cubit<DailyItineraryData> {
  DailyItineraryCubit(DailyItineraryData state) : super(state);

  void addPlace(PlaceData place) {
    emit(state.copyWith(places: [...state.places, place]));
  }

  void removePlace(PlaceData place) {
    emit(
        state.copyWith(places: state.places.where((p) => p != place).toList()));
  }
}
