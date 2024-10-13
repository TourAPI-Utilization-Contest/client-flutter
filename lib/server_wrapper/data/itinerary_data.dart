import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../server_wrapper.dart';
import 'daily_itinerary_data.dart';

part 'itinerary_data.freezed.dart';
part 'itinerary_data.g.dart';

DateTime _dateTimeFromJson(String date) => DateTime.parse(date);
String _dateTimeToJson(DateTime date) => date.toIso8601String();
// DateTime _dateTimeFromJson(dynamic date) {
//   if (date is Timestamp) {
//     return date.toDate();
//   } else if (date is String) {
//     return DateTime.parse(date);
//   } else {
//     throw Exception('Unsupported date format');
//   }
// }
//
// Timestamp _dateTimeToJson(DateTime date) => Timestamp.fromDate(date);

Color _colorFromJson(int color) => Color(color);
int _colorToJson(Color color) => color.value;

List<DailyItineraryCubit> _dailyItineraryCubitListFromJson(
    List<dynamic> dailyItineraryDataList) {
  return dailyItineraryDataList
      .map((dailyItineraryData) =>
          DailyItineraryCubit(DailyItineraryData.fromJson(dailyItineraryData)))
      .toList();
}

List<DailyItineraryData> _dailyItineraryCubitListToJson(
    List<DailyItineraryCubit> dailyItineraryCubitList) {
  return dailyItineraryCubitList.map((cubit) => cubit.state).toList();
}

@unfreezed
class ItineraryData with _$ItineraryData {
  const ItineraryData._(); // Private constructor for custom methods

  factory ItineraryData({
    required int id,
    required List<int> users,
    required String title,
    String? description,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    required DateTime startDate,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    required DateTime endDate,
    String? iconPath, // svg icon
    @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
    required Color iconColor,
    // @Default([]) List<DailyItineraryData> dailyItinerariesData,
    // @Default([])
    // @JsonKey(includeToJson: false, includeFromJson: false)
    // List<DailyItineraryCubit> dailyItineraryCubitList,
    @Default([])
    @JsonKey(
        fromJson: _dailyItineraryCubitListFromJson,
        toJson: _dailyItineraryCubitListToJson)
    List<DailyItineraryCubit> dailyItineraryCubitList,
  }) = _ItineraryData;

  factory ItineraryData.fromJson(Map<String, dynamic> json) =>
      _$ItineraryDataFromJson(json);
}

class ItineraryCubit extends Cubit<ItineraryData> {
  ItineraryCubit(super.itinerary);

  // void updateDates(DateTime newStartDate, DateTime newEndDate) {
  //   int oldDays = state.endDate.difference(state.startDate).inDays;
  //   int newDays = newEndDate.difference(newStartDate).inDays;
  //
  //   // 일정 쉬프팅
  //   if (newStartDate.isAfter(state.startDate)) {
  //     int shiftDays = newStartDate.difference(state.startDate).inDays;
  //     state.dailyItineraryCubitList
  //         .map((itineraryCubit) => itineraryCubit.shiftDate(shiftDays));
  //   } else if (newStartDate.isBefore(state.startDate)) {
  //     int shiftDays = state.startDate.difference(newStartDate).inDays;
  //     state.dailyItineraryCubitList
  //         .map((itineraryCubit) => itineraryCubit.shiftDate(-shiftDays));
  //   }
  //
  //   // 일정이 길어졌다면 새로운 일정을 추가
  //   if (newDays > oldDays) {
  //     for (int i = oldDays + 1; i <= newDays; i++) {
  //       state.dailyItineraryCubitList.add(DailyItineraryCubit(
  //         DailyItineraryData(
  //           dailyItineraryId: state.id,
  //           date: newStartDate.add(Duration(days: i)),
  //         ),
  //       ));
  //     }
  //   }
  //
  //   // 일정이 줄어들었다면 마지막 일정을 삭제
  //   if (newDays < oldDays) {
  //     state.dailyItineraryCubitList.removeRange(newDays + 1, oldDays + 1);
  //   }
  //
  //   emit(state.copyWith(startDate: newStartDate, endDate: newEndDate));
  // }

  void setItinerary(ItineraryData itinerary) {
    emit(itinerary);
  }

  void clearDailyItineraryCubitList() {
    emit(state.copyWith(dailyItineraryCubitList: []));
  }

  void addDailyItineraryCubit(DailyItineraryCubit dailyItineraryCubit) {
    emit(state.copyWith(
      dailyItineraryCubitList: [
        ...state.dailyItineraryCubitList,
        dailyItineraryCubit
      ],
    ));
  }

  void changeDate(DateTime startDate, DateTime endDate) {
    emit(state.copyWith(startDate: startDate, endDate: endDate));
  }
}
