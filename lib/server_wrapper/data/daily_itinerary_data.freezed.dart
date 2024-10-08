// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_itinerary_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DailyItineraryData _$DailyItineraryDataFromJson(Map<String, dynamic> json) {
  return _DailyItinerary.fromJson(json);
}

/// @nodoc
mixin _$DailyItineraryData {
  String get dailyItineraryId => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime get date => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: _placeDataCubitListFromJson, toJson: _placeDataCubitListToJson)
  List<PlaceCubit> get placeList => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _movementCubitFromJson, toJson: _movementCubitToJson)
  List<MovementCubit> get movementList => throw _privateConstructorUsedError;

  /// Serializes this DailyItineraryData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyItineraryData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyItineraryDataCopyWith<DailyItineraryData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyItineraryDataCopyWith<$Res> {
  factory $DailyItineraryDataCopyWith(
          DailyItineraryData value, $Res Function(DailyItineraryData) then) =
      _$DailyItineraryDataCopyWithImpl<$Res, DailyItineraryData>;
  @useResult
  $Res call(
      {String dailyItineraryId,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime date,
      @JsonKey(
          fromJson: _placeDataCubitListFromJson,
          toJson: _placeDataCubitListToJson)
      List<PlaceCubit> placeList,
      @JsonKey(fromJson: _movementCubitFromJson, toJson: _movementCubitToJson)
      List<MovementCubit> movementList});
}

/// @nodoc
class _$DailyItineraryDataCopyWithImpl<$Res, $Val extends DailyItineraryData>
    implements $DailyItineraryDataCopyWith<$Res> {
  _$DailyItineraryDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyItineraryData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dailyItineraryId = null,
    Object? date = null,
    Object? placeList = null,
    Object? movementList = null,
  }) {
    return _then(_value.copyWith(
      dailyItineraryId: null == dailyItineraryId
          ? _value.dailyItineraryId
          : dailyItineraryId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      placeList: null == placeList
          ? _value.placeList
          : placeList // ignore: cast_nullable_to_non_nullable
              as List<PlaceCubit>,
      movementList: null == movementList
          ? _value.movementList
          : movementList // ignore: cast_nullable_to_non_nullable
              as List<MovementCubit>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyItineraryImplCopyWith<$Res>
    implements $DailyItineraryDataCopyWith<$Res> {
  factory _$$DailyItineraryImplCopyWith(_$DailyItineraryImpl value,
          $Res Function(_$DailyItineraryImpl) then) =
      __$$DailyItineraryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String dailyItineraryId,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime date,
      @JsonKey(
          fromJson: _placeDataCubitListFromJson,
          toJson: _placeDataCubitListToJson)
      List<PlaceCubit> placeList,
      @JsonKey(fromJson: _movementCubitFromJson, toJson: _movementCubitToJson)
      List<MovementCubit> movementList});
}

/// @nodoc
class __$$DailyItineraryImplCopyWithImpl<$Res>
    extends _$DailyItineraryDataCopyWithImpl<$Res, _$DailyItineraryImpl>
    implements _$$DailyItineraryImplCopyWith<$Res> {
  __$$DailyItineraryImplCopyWithImpl(
      _$DailyItineraryImpl _value, $Res Function(_$DailyItineraryImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyItineraryData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dailyItineraryId = null,
    Object? date = null,
    Object? placeList = null,
    Object? movementList = null,
  }) {
    return _then(_$DailyItineraryImpl(
      dailyItineraryId: null == dailyItineraryId
          ? _value.dailyItineraryId
          : dailyItineraryId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      placeList: null == placeList
          ? _value._placeList
          : placeList // ignore: cast_nullable_to_non_nullable
              as List<PlaceCubit>,
      movementList: null == movementList
          ? _value._movementList
          : movementList // ignore: cast_nullable_to_non_nullable
              as List<MovementCubit>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyItineraryImpl extends _DailyItinerary {
  const _$DailyItineraryImpl(
      {required this.dailyItineraryId,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      required this.date,
      @JsonKey(
          fromJson: _placeDataCubitListFromJson,
          toJson: _placeDataCubitListToJson)
      final List<PlaceCubit> placeList = const [],
      @JsonKey(fromJson: _movementCubitFromJson, toJson: _movementCubitToJson)
      final List<MovementCubit> movementList = const []})
      : _placeList = placeList,
        _movementList = movementList,
        super._();

  factory _$DailyItineraryImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyItineraryImplFromJson(json);

  @override
  final String dailyItineraryId;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime date;
  final List<PlaceCubit> _placeList;
  @override
  @JsonKey(
      fromJson: _placeDataCubitListFromJson, toJson: _placeDataCubitListToJson)
  List<PlaceCubit> get placeList {
    if (_placeList is EqualUnmodifiableListView) return _placeList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_placeList);
  }

  final List<MovementCubit> _movementList;
  @override
  @JsonKey(fromJson: _movementCubitFromJson, toJson: _movementCubitToJson)
  List<MovementCubit> get movementList {
    if (_movementList is EqualUnmodifiableListView) return _movementList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_movementList);
  }

  @override
  String toString() {
    return 'DailyItineraryData(dailyItineraryId: $dailyItineraryId, date: $date, placeList: $placeList, movementList: $movementList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyItineraryImpl &&
            (identical(other.dailyItineraryId, dailyItineraryId) ||
                other.dailyItineraryId == dailyItineraryId) &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality()
                .equals(other._placeList, _placeList) &&
            const DeepCollectionEquality()
                .equals(other._movementList, _movementList));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      dailyItineraryId,
      date,
      const DeepCollectionEquality().hash(_placeList),
      const DeepCollectionEquality().hash(_movementList));

  /// Create a copy of DailyItineraryData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyItineraryImplCopyWith<_$DailyItineraryImpl> get copyWith =>
      __$$DailyItineraryImplCopyWithImpl<_$DailyItineraryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyItineraryImplToJson(
      this,
    );
  }
}

abstract class _DailyItinerary extends DailyItineraryData {
  const factory _DailyItinerary(
      {required final String dailyItineraryId,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      required final DateTime date,
      @JsonKey(
          fromJson: _placeDataCubitListFromJson,
          toJson: _placeDataCubitListToJson)
      final List<PlaceCubit> placeList,
      @JsonKey(fromJson: _movementCubitFromJson, toJson: _movementCubitToJson)
      final List<MovementCubit> movementList}) = _$DailyItineraryImpl;
  const _DailyItinerary._() : super._();

  factory _DailyItinerary.fromJson(Map<String, dynamic> json) =
      _$DailyItineraryImpl.fromJson;

  @override
  String get dailyItineraryId;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime get date;
  @override
  @JsonKey(
      fromJson: _placeDataCubitListFromJson, toJson: _placeDataCubitListToJson)
  List<PlaceCubit> get placeList;
  @override
  @JsonKey(fromJson: _movementCubitFromJson, toJson: _movementCubitToJson)
  List<MovementCubit> get movementList;

  /// Create a copy of DailyItineraryData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyItineraryImplCopyWith<_$DailyItineraryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
