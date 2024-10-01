import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'place_data.dart';
import 'movement_data.dart';

part 'daily_itinerary_data.freezed.dart';
part 'daily_itinerary_data.g.dart';

DateTime _dateTimeFromJson(String date) => DateTime.parse(date);
String _dateTimeToJson(DateTime date) => date.toIso8601String();

List<PlaceCubit> _placeDataCubitListFromJson(List<dynamic> placeDataList) {
  return placeDataList
      .map((placeData) => PlaceCubit(PlaceData.fromJson(placeData)))
      .toList();
}

List<dynamic> _placeDataCubitListToJson(List<PlaceCubit> places) {
  return places.map((cubit) => cubit.state.toJson()).toList();
}

List<MovementCubit> _movementCubitFromJson(List<dynamic> movementDataList) {
  return movementDataList
      .map((movementData) => MovementCubit(MovementData.fromJson(movementData)))
      .toList();
}

List<dynamic> _movementCubitToJson(List<MovementCubit> movements) {
  return movements.map((cubit) => cubit.state.toJson()).toList();
}

@freezed
class DailyItineraryData with _$DailyItineraryData {
  const factory DailyItineraryData(
      {required String dailyItineraryId,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      required DateTime date,
      // @Default([]) List<PlaceData> places,
      @Default([])
      @JsonKey(
          fromJson: _placeDataCubitListFromJson,
          toJson: _placeDataCubitListToJson)
      List<PlaceCubit> placeList,
      //MovementCubit
      @Default([])
      @JsonKey(fromJson: _movementCubitFromJson, toJson: _movementCubitToJson)
      List<MovementCubit> movementList}) = _DailyItinerary;

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

  void addPlace(PlaceCubit place) {
    emit(state.copyWith(placeList: [...state.placeList, place]));
  }

  void removePlace(PlaceCubit place) {
    emit(state.copyWith(
        placeList: state.placeList.where((p) => p != place).toList()));
  }

  void updatePlace(PlaceCubit place) {
    emit(state.copyWith(
        placeList:
            state.placeList.map((p) => p == place ? place : p).toList()));
  }

  void reorderPlaces(int oldIndex, int newIndex) {
    var newPlaces = List<PlaceCubit>.from(state.placeList);
    final place = newPlaces.removeAt(oldIndex);
    newPlaces.insert(newIndex, place);
    emit(state.copyWith(placeList: newPlaces));
  }
}
