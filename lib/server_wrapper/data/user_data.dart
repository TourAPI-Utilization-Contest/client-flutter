import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserData {
  final int id;
  String? email;
  String? nickname;
  String? kakaoId;
  String? profileUrl;
  List<int> itineraries = [];

  UserData({
    required this.id,
    this.email,
    this.nickname,
    this.kakaoId,
    this.profileUrl,
    this.itineraries = const [],
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

class UserCubit extends Cubit<UserData?> {
  UserCubit() : super(null);

  void setUser(UserData? user) {
    emit(user);
  }

  void addItinerary(int itineraryId) {
    if (state != null) {
      state!.itineraries.add(itineraryId);
      emit(state);
    }
  }

  void removeItinerary(int itineraryId) {
    if (state != null) {
      state!.itineraries.remove(itineraryId);
      emit(state);
    }
  }

  void updateNickname(String value) {
    if (state != null) {
      state!.nickname = value;
      emit(state);
    }
  }
}
