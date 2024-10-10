import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'movement_detail_data.freezed.dart';
part 'movement_detail_data.g.dart';

DateTime _dateTimeFromJson(String date) => DateTime.parse(date);
String _dateTimeToJson(DateTime date) => date.toIso8601String();

Duration _durationFromJson(int duration) => Duration(seconds: duration);
int _durationToJson(Duration duration) => duration.inSeconds;

@freezed
class MovementDetailData with _$MovementDetailData {
  factory MovementDetailData({
    @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
    required Duration duration,
    required double distance,
    required String path, // 경로
    required String method, // 이동수단
    required String source, // 경로 출처(Google, Kakao)
  }) = _MovementDetailData;

  factory MovementDetailData.initial() => MovementDetailData(
        duration: Duration.zero,
        distance: 0,
        path: '',
        method: 'work',
        source: 'unknown',
      );

  factory MovementDetailData.fromJson(Map<String, dynamic> json) =>
      _$MovementDetailDataFromJson(json);
}

// class MovementDetailCubit extends Cubit<MovementDetailData> {
//   MovementDetailCubit(super.state);
//
//   void update(MovementDetailData movementDetailData) {
//     emit(movementDetailData);
//   }
// }
