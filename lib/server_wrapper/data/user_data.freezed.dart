// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return _UserData.fromJson(json);
}

/// @nodoc
mixin _$UserData {
  int get id => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get nickname => throw _privateConstructorUsedError;
  String? get kakaoId => throw _privateConstructorUsedError;
  String? get profileUrl => throw _privateConstructorUsedError;
  List<int> get itineraries => throw _privateConstructorUsedError;
  Map<int, PlaceData> get places => throw _privateConstructorUsedError;

  /// Serializes this UserData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserDataCopyWith<UserData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDataCopyWith<$Res> {
  factory $UserDataCopyWith(UserData value, $Res Function(UserData) then) =
      _$UserDataCopyWithImpl<$Res, UserData>;
  @useResult
  $Res call(
      {int id,
      String? email,
      String? nickname,
      String? kakaoId,
      String? profileUrl,
      List<int> itineraries,
      Map<int, PlaceData> places});
}

/// @nodoc
class _$UserDataCopyWithImpl<$Res, $Val extends UserData>
    implements $UserDataCopyWith<$Res> {
  _$UserDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = freezed,
    Object? nickname = freezed,
    Object? kakaoId = freezed,
    Object? profileUrl = freezed,
    Object? itineraries = null,
    Object? places = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      nickname: freezed == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      kakaoId: freezed == kakaoId
          ? _value.kakaoId
          : kakaoId // ignore: cast_nullable_to_non_nullable
              as String?,
      profileUrl: freezed == profileUrl
          ? _value.profileUrl
          : profileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      itineraries: null == itineraries
          ? _value.itineraries
          : itineraries // ignore: cast_nullable_to_non_nullable
              as List<int>,
      places: null == places
          ? _value.places
          : places // ignore: cast_nullable_to_non_nullable
              as Map<int, PlaceData>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserDataImplCopyWith<$Res>
    implements $UserDataCopyWith<$Res> {
  factory _$$UserDataImplCopyWith(
          _$UserDataImpl value, $Res Function(_$UserDataImpl) then) =
      __$$UserDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String? email,
      String? nickname,
      String? kakaoId,
      String? profileUrl,
      List<int> itineraries,
      Map<int, PlaceData> places});
}

/// @nodoc
class __$$UserDataImplCopyWithImpl<$Res>
    extends _$UserDataCopyWithImpl<$Res, _$UserDataImpl>
    implements _$$UserDataImplCopyWith<$Res> {
  __$$UserDataImplCopyWithImpl(
      _$UserDataImpl _value, $Res Function(_$UserDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = freezed,
    Object? nickname = freezed,
    Object? kakaoId = freezed,
    Object? profileUrl = freezed,
    Object? itineraries = null,
    Object? places = null,
  }) {
    return _then(_$UserDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      nickname: freezed == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      kakaoId: freezed == kakaoId
          ? _value.kakaoId
          : kakaoId // ignore: cast_nullable_to_non_nullable
              as String?,
      profileUrl: freezed == profileUrl
          ? _value.profileUrl
          : profileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      itineraries: null == itineraries
          ? _value._itineraries
          : itineraries // ignore: cast_nullable_to_non_nullable
              as List<int>,
      places: null == places
          ? _value._places
          : places // ignore: cast_nullable_to_non_nullable
              as Map<int, PlaceData>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$UserDataImpl extends _UserData {
  _$UserDataImpl(
      {required this.id,
      this.email,
      this.nickname,
      this.kakaoId,
      this.profileUrl,
      final List<int> itineraries = const [],
      final Map<int, PlaceData> places = const {}})
      : _itineraries = itineraries,
        _places = places,
        super._();

  factory _$UserDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserDataImplFromJson(json);

  @override
  final int id;
  @override
  final String? email;
  @override
  final String? nickname;
  @override
  final String? kakaoId;
  @override
  final String? profileUrl;
  final List<int> _itineraries;
  @override
  @JsonKey()
  List<int> get itineraries {
    if (_itineraries is EqualUnmodifiableListView) return _itineraries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_itineraries);
  }

  final Map<int, PlaceData> _places;
  @override
  @JsonKey()
  Map<int, PlaceData> get places {
    if (_places is EqualUnmodifiableMapView) return _places;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_places);
  }

  @override
  String toString() {
    return 'UserData(id: $id, email: $email, nickname: $nickname, kakaoId: $kakaoId, profileUrl: $profileUrl, itineraries: $itineraries, places: $places)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.kakaoId, kakaoId) || other.kakaoId == kakaoId) &&
            (identical(other.profileUrl, profileUrl) ||
                other.profileUrl == profileUrl) &&
            const DeepCollectionEquality()
                .equals(other._itineraries, _itineraries) &&
            const DeepCollectionEquality().equals(other._places, _places));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      nickname,
      kakaoId,
      profileUrl,
      const DeepCollectionEquality().hash(_itineraries),
      const DeepCollectionEquality().hash(_places));

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserDataImplCopyWith<_$UserDataImpl> get copyWith =>
      __$$UserDataImplCopyWithImpl<_$UserDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserDataImplToJson(
      this,
    );
  }
}

abstract class _UserData extends UserData {
  factory _UserData(
      {required final int id,
      final String? email,
      final String? nickname,
      final String? kakaoId,
      final String? profileUrl,
      final List<int> itineraries,
      final Map<int, PlaceData> places}) = _$UserDataImpl;
  _UserData._() : super._();

  factory _UserData.fromJson(Map<String, dynamic> json) =
      _$UserDataImpl.fromJson;

  @override
  int get id;
  @override
  String? get email;
  @override
  String? get nickname;
  @override
  String? get kakaoId;
  @override
  String? get profileUrl;
  @override
  List<int> get itineraries;
  @override
  Map<int, PlaceData> get places;

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserDataImplCopyWith<_$UserDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
