import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'daily_itinerary_data.dart';

part 'itinerary_data.freezed.dart';
part 'itinerary_data.g.dart';

DateTime _dateTimeFromJson(String date) => DateTime.parse(date);
String _dateTimeToJson(DateTime date) => date.toIso8601String();

Color _colorFromJson(int color) => Color(color);
int _colorToJson(Color color) => color.value;

// @JsonSerializable(explicitToJson: true)
// class ItineraryData {
//   String id;
//   List<String> users;
//   String title;
//   String? description;
//   @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
//   DateTime _startDate;
//   DateTime get startDate => _startDate;
//   @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
//   DateTime _endDate;
//   DateTime get endDate => _endDate;
//   // String? category;
//   String? iconBase64; // svg icon
//   @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
//   Color iconColor;
//   List<DailyItinerary> dailyItineraries = [];
//
//   ItineraryData({
//     required this.id,
//     required this.users,
//     required this.title,
//     this.description,
//     required DateTime startDate,
//     required DateTime endDate,
//     // this.category,
//     this.iconBase64,
//     required this.iconColor,
//   })  : _startDate = startDate,
//         _endDate = endDate {
//     int daysDifference = endDate.difference(startDate).inDays;
//     for (int i = 0; i <= daysDifference; i++) {
//       dailyItineraries.add(DailyItinerary(
//         dailyItineraryId: id,
//         date: startDate.add(Duration(days: i)),
//       ));
//     }
//   }
//
//   void updateDates(DateTime newStartDate, DateTime newEndDate) {
//     int oldDays = _endDate.difference(_startDate).inDays;
//     int newDays = newEndDate.difference(newStartDate).inDays;
//
//     // 일정 쉬프팅
//     if (newStartDate.isAfter(_startDate)) {
//       int shiftDays = newStartDate.difference(_startDate).inDays;
//       dailyItineraries = dailyItineraries
//           .map((itinerary) => itinerary.shiftDate(shiftDays))
//           .toList();
//     } else if (newStartDate.isBefore(_startDate)) {
//       int shiftDays = _startDate.difference(newStartDate).inDays;
//       dailyItineraries = dailyItineraries
//           .map((itinerary) => itinerary.shiftDate(-shiftDays))
//           .toList();
//     }
//
//     // 일정이 길어졌다면 새로운 일정을 추가
//     if (newDays > oldDays) {
//       for (int i = oldDays + 1; i <= newDays; i++) {
//         dailyItineraries.add(DailyItinerary(
//           dailyItineraryId: id,
//           date: newStartDate.add(Duration(days: i)),
//         ));
//       }
//     }
//
//     // 일정이 줄어들었다면 마지막 일정을 삭제
//     if (newDays < oldDays) {
//       dailyItineraries.removeRange(newDays + 1, oldDays + 1);
//     }
//
//     _startDate = newStartDate;
//     _endDate = newEndDate;
//   }
//
//   factory ItineraryData.fromJson(Map<String, dynamic> json) =>
//       _$ItineraryDataFromJson(json);
//
//   Map<String, dynamic> toJson() => _$ItineraryDataToJson(this);
// }

@unfreezed
class ItineraryData with _$ItineraryData {
  const ItineraryData._(); // Private constructor for custom methods

  factory ItineraryData({
    required String id,
    required List<String> users,
    required String title,
    String? description,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    required DateTime startDate,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    required DateTime endDate,
    String? iconPath, // svg icon
    @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
    required Color iconColor,
    @Default([]) List<DailyItinerary> dailyItineraries,
  }) = _ItineraryData;

  void updateDates(DateTime newStartDate, DateTime newEndDate) {
    int oldDays = endDate.difference(startDate).inDays;
    int newDays = newEndDate.difference(newStartDate).inDays;

    // 일정 쉬프팅
    if (newStartDate.isAfter(startDate)) {
      int shiftDays = newStartDate.difference(startDate).inDays;
      dailyItineraries = dailyItineraries
          .map((itinerary) => itinerary.shiftDate(shiftDays))
          .toList();
    } else if (newStartDate.isBefore(startDate)) {
      int shiftDays = startDate.difference(newStartDate).inDays;
      dailyItineraries = dailyItineraries
          .map((itinerary) => itinerary.shiftDate(-shiftDays))
          .toList();
    }

    // 일정이 길어졌다면 새로운 일정을 추가
    if (newDays > oldDays) {
      for (int i = oldDays + 1; i <= newDays; i++) {
        dailyItineraries.add(DailyItinerary(
          dailyItineraryId: id,
          date: newStartDate.add(Duration(days: i)),
        ));
      }
    }

    // 일정이 줄어들었다면 마지막 일정을 삭제
    if (newDays < oldDays) {
      dailyItineraries.removeRange(newDays + 1, oldDays + 1);
    }

    startDate = newStartDate;
    endDate = newEndDate;
  }

  factory ItineraryData.fromJson(Map<String, dynamic> json) =>
      _$ItineraryDataFromJson(json);
}

class ItineraryCubit extends Cubit<ItineraryData?> {
  ItineraryCubit(super.itinerary);

  void setItinerary(ItineraryData? itinerary) {
    emit(itinerary);
  }

  void changeDate(DateTime startDate, DateTime endDate) {
    if (state == null) return;
    emit(state);
  }
}
