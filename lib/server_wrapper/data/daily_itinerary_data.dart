import 'dart:math';

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
      {required int dailyItineraryId,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      required DateTime date,
      @Default([])
      @JsonKey(
          fromJson: _placeDataCubitListFromJson,
          toJson: _placeDataCubitListToJson)
      List<PlaceCubit> placeList,
      @Default([])
      @JsonKey(fromJson: _movementCubitFromJson, toJson: _movementCubitToJson)
      List<MovementCubit> movementList}) = _DailyItinerary;

  const DailyItineraryData._();
  DailyItineraryData shiftDate(int shiftDays) {
    return copyWith(date: date.add(Duration(days: shiftDays)));
  }

  // factory DailyItineraryData.fromJson(Map<String, dynamic> json) =>
  //     _$DailyItineraryDataFromJson(json);

  factory DailyItineraryData.fromJson(Map<String, dynamic> json) =>
      _DailyItineraryDataFromJson(json);

  factory DailyItineraryData.initial() => DailyItineraryData(
        dailyItineraryId: 0,
        date: DateTime.now(),
        placeList: [],
        movementList: [],
      );

  static DailyItineraryData _DailyItineraryDataFromJson(
      Map<String, dynamic> json) {
    var dud = _$DailyItineraryDataFromJson(json);
    if (dud.movementList.length < dud.placeList.length - 1) {
      var newMovementList = List<MovementCubit>.from(dud.movementList);
      while (newMovementList.length < dud.placeList.length - 1) {
        newMovementList.add(MovementCubit(MovementData.initial()));
      }
      dud = dud.copyWith(movementList: newMovementList);
    }
    return dud;
  }
}

class DailyItineraryCubit extends Cubit<DailyItineraryData> {
  DailyItineraryCubit(super.state);

  void shiftDate(int shiftDays) {
    emit(state.shiftDate(shiftDays));
  }

  void addPlace(PlaceCubit place) {
    if (state.placeList.isNotEmpty) {
      emit(state.copyWith(placeList: [
        ...state.placeList,
        place
      ], movementList: [
        ...state.movementList,
        MovementCubit(MovementData.initial())
      ]));
    } else {
      emit(state.copyWith(placeList: [place], movementList: []));
    }
  }

  void removePlace(PlaceCubit place) {
    // emit(state.copyWith(
    //     placeList: state.placeList.where((p) => p != place).toList()));
    var index = state.placeList.indexOf(place);
    if (index == -1) return;
    var newPlaces = List<PlaceCubit>.from(state.placeList);
    newPlaces.removeAt(index);
    var newMovements = List<MovementCubit>.from(state.movementList);
    if (index < newMovements.length) {
      newMovements.removeAt(index);
    } else if (0 < index) {
      newMovements.removeAt(index - 1);
    }
    if (0 < index && index <= newMovements.length) {
      newMovements[index - 1] = MovementCubit(MovementData.initial());
    }
    emit(state.copyWith(placeList: newPlaces, movementList: newMovements));
  }

  void updatePlace(PlaceCubit place) {
    emit(state.copyWith(
        placeList:
            state.placeList.map((p) => p == place ? place : p).toList()));
  }

  bool reorderPlaces(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return false;
    if (oldIndex < 0 || oldIndex >= state.placeList.length) return false;
    if (newIndex < 0 || newIndex >= state.placeList.length) return false;
    if (state.placeList.length - 1 != state.movementList.length) {
      print('placeList와 movementList의 길이가 다릅니다.');
      return false;
    }
    var length = state.placeList.length;
    var newPlaces = List<PlaceCubit>.from(state.placeList);
    final place = newPlaces.removeAt(oldIndex);
    newPlaces.insert(newIndex, place);
    // 영향을 받는 movement 수정
    var newMovements = List<MovementCubit>.from(state.movementList);
    var oldMovementIndex = min(oldIndex, length - 2);
    var newMovementIndex = min(newIndex, length - 2);
    final movement = newMovements.removeAt(oldMovementIndex);
    newMovements.insert(newMovementIndex, movement);
    if (oldIndex < newIndex) {
      if (0 < oldIndex) {
        newMovements[oldIndex - 1] = MovementCubit(MovementData.initial());
      }
      newMovements[newIndex - 1] = MovementCubit(MovementData.initial());
      if (newIndex < length - 1) {
        newMovements[newIndex] = MovementCubit(MovementData.initial());
      }
    } else {
      if (oldIndex < length - 1) {
        newMovements[oldIndex] = MovementCubit(MovementData.initial());
      }
      newMovements[newIndex] = MovementCubit(MovementData.initial());
      if (0 < newIndex) {
        newMovements[newIndex - 1] = MovementCubit(MovementData.initial());
      }
    }
    emit(state.copyWith(placeList: newPlaces, movementList: newMovements));
    return true;
  }

  void addMovement(MovementCubit movement) {
    emit(state.copyWith(movementList: [...state.movementList, movement]));
  }

  void removeMovement(MovementCubit movement) {
    emit(state.copyWith(
        movementList: state.movementList.where((m) => m != movement).toList()));
  }

  void setDailyItinerary(DailyItineraryData dailyItineraryData) {
    emit(dailyItineraryData.copyWith());
  }

  void resetMovement(int index, {MovementData? movementData}) {
    if (index < 0 || index >= state.movementList.length) return;
    var newMovements = List<MovementCubit>.from(state.movementList);
    newMovements[index] = MovementCubit(movementData ?? MovementData.initial());
    emit(state.copyWith(movementList: newMovements));
  }

  void processingMovement(int index, {bool processing = true}) {
    if (index < 0 || index >= state.movementList.length) return;
    var newMovements = List<MovementCubit>.from(state.movementList);
    newMovements[index] = MovementCubit(
        newMovements[index].state.copyWith(processing: processing));
    emit(state.copyWith(movementList: newMovements));
  }
}
