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

DailyItineraryData _$DailyItineraryFromJson(Map<String, dynamic> json) {
  return _DailyItinerary.fromJson(json);
}

/// @nodoc
mixin _$DailyItinerary {
  String get dailyItineraryId => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime get date => throw _privateConstructorUsedError;
  List<PlaceData> get places => throw _privateConstructorUsedError;

  /// Serializes this DailyItinerary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyItinerary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyItineraryCopyWith<DailyItineraryData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyItineraryCopyWith<$Res> {
  factory $DailyItineraryCopyWith(
          DailyItineraryData value, $Res Function(DailyItineraryData) then) =
      _$DailyItineraryCopyWithImpl<$Res, DailyItineraryData>;
  @useResult
  $Res call(
      {String dailyItineraryId,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime date,
      List<PlaceData> places});
}

/// @nodoc
class _$DailyItineraryCopyWithImpl<$Res, $Val extends DailyItineraryData>
    implements $DailyItineraryCopyWith<$Res> {
  _$DailyItineraryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyItinerary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dailyItineraryId = null,
    Object? date = null,
    Object? places = null,
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
      places: null == places
          ? _value.places
          : places // ignore: cast_nullable_to_non_nullable
              as List<PlaceData>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyItineraryImplCopyWith<$Res>
    implements $DailyItineraryCopyWith<$Res> {
  factory _$$DailyItineraryImplCopyWith(_$DailyItineraryImpl value,
          $Res Function(_$DailyItineraryImpl) then) =
      __$$DailyItineraryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String dailyItineraryId,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime date,
      List<PlaceData> places});
}

/// @nodoc
class __$$DailyItineraryImplCopyWithImpl<$Res>
    extends _$DailyItineraryCopyWithImpl<$Res, _$DailyItineraryImpl>
    implements _$$DailyItineraryImplCopyWith<$Res> {
  __$$DailyItineraryImplCopyWithImpl(
      _$DailyItineraryImpl _value, $Res Function(_$DailyItineraryImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyItinerary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dailyItineraryId = null,
    Object? date = null,
    Object? places = null,
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
      places: null == places
          ? _value._places
          : places // ignore: cast_nullable_to_non_nullable
              as List<PlaceData>,
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
      final List<PlaceData> places = const []})
      : _places = places,
        super._();

  factory _$DailyItineraryImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyItineraryImplFromJson(json);

  @override
  final String dailyItineraryId;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime date;
  final List<PlaceData> _places;
  @override
  @JsonKey()
  List<PlaceData> get places {
    if (_places is EqualUnmodifiableListView) return _places;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_places);
  }

  @override
  String toString() {
    return 'DailyItinerary(dailyItineraryId: $dailyItineraryId, date: $date, places: $places)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyItineraryImpl &&
            (identical(other.dailyItineraryId, dailyItineraryId) ||
                other.dailyItineraryId == dailyItineraryId) &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(other._places, _places));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, dailyItineraryId, date,
      const DeepCollectionEquality().hash(_places));

  /// Create a copy of DailyItinerary
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
      final List<PlaceData> places}) = _$DailyItineraryImpl;
  const _DailyItinerary._() : super._();

  factory _DailyItinerary.fromJson(Map<String, dynamic> json) =
      _$DailyItineraryImpl.fromJson;

  @override
  String get dailyItineraryId;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime get date;
  @override
  List<PlaceData> get places;

  /// Create a copy of DailyItinerary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyItineraryImplCopyWith<_$DailyItineraryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
