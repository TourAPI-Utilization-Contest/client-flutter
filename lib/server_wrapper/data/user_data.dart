import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserData {
  final String id;
  String? email;
  String? name;
  String? kakaoId;
  List<String> itineraries = [];

  UserData({
    required this.id,
    this.email,
    this.name,
    this.kakaoId,
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

  void addItinerary(String itineraryId) {
    if (state != null) {
      state!.itineraries.add(itineraryId);
      emit(state);
    }
  }

  void removeItinerary(String itineraryId) {
    if (state != null) {
      state!.itineraries.remove(itineraryId);
      emit(state);
    }
  }
}
