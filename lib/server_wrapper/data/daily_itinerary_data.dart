import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'place_data.dart';

part 'daily_itinerary_data.freezed.dart';
part 'daily_itinerary_data.g.dart';

DateTime _dateTimeFromJson(String date) => DateTime.parse(date);
String _dateTimeToJson(DateTime date) => date.toIso8601String();

@freezed
class DailyItineraryData with _$DailyItineraryData {
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
      _$DailyItineraryDataFromJson(json);
}

class DailyItineraryCubit extends Cubit<DailyItineraryData> {
  DailyItineraryCubit(super.state);

  void shiftDate(int shiftDays) {
    emit(state.shiftDate(shiftDays));
  }

  void addPlace(PlaceData place) {
    emit(state.copyWith(places: [...state.places, place]));
  }

  void removePlace(PlaceData place) {
    emit(
        state.copyWith(places: state.places.where((p) => p != place).toList()));
  }
}
