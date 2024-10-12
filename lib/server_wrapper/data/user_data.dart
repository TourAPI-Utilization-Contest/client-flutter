import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tradule/server_wrapper/data/place_data.dart';

part 'user_data.freezed.dart';
part 'user_data.g.dart';

// @JsonSerializable()
@freezed
class UserData with _$UserData {
  const UserData._();

  @JsonSerializable(explicitToJson: true)
  factory UserData({
    required int id,
    String? email,
    String? nickname,
    String? kakaoId,
    String? profileUrl,
    @Default([]) List<int> itineraries,
    @Default({}) Map<int, PlaceData> places,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}

class UserCubit extends Cubit<UserData?> {
  UserCubit() : super(null);

  void setUser(UserData? user) {
    emit(user);
  }

  void addItinerary(int itineraryId) {
    if (state != null) {
      emit(state!.copyWith(itineraries: [...state!.itineraries, itineraryId]));
    }
  }

  void removeItinerary(int itineraryId) {
    if (state != null) {
      emit(state!.copyWith(
          itineraries:
              state!.itineraries.where((id) => id != itineraryId).toList()));
    }
  }

  void updateNickname(String value) {
    if (state != null) {
      emit(state!.copyWith(nickname: value));
    }
  }

  void addPlace(PlaceData place) {
    if (state != null) {
      emit(state!.copyWith(places: {...state!.places, place.id: place}));
    }
  }

  void removePlace(PlaceData place) {
    if (state != null) {
      emit(state!.copyWith(places: Map.from(state!.places)..remove(place.id)));
    }
  }

  bool isPlaceExist(int placeId) {
    if (state != null) {
      return state!.places.containsKey(placeId);
    }
    return false;
  }
}
