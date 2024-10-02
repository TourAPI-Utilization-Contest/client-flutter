// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movement_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MovementData _$MovementDataFromJson(Map<String, dynamic> json) {
  return _MovementData.fromJson(json);
}

/// @nodoc
mixin _$MovementData {
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime get startTime => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  set startTime(DateTime value) => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime get endTime => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  set endTime(DateTime value) => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
  Duration get duration => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
  set duration(Duration value) => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
  Duration? get minDuration => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
  set minDuration(Duration? value) => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
  Duration? get maxDuration => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
  set maxDuration(Duration? value) => throw _privateConstructorUsedError;
  double get distance => throw _privateConstructorUsedError;
  set distance(double value) => throw _privateConstructorUsedError;
  double? get startLatitude => throw _privateConstructorUsedError;
  set startLatitude(double? value) => throw _privateConstructorUsedError;
  double? get startLongitude => throw _privateConstructorUsedError;
  set startLongitude(double? value) => throw _privateConstructorUsedError;
  double? get endLatitude => throw _privateConstructorUsedError;
  set endLatitude(double? value) => throw _privateConstructorUsedError;
  double? get endLongitude => throw _privateConstructorUsedError;
  set endLongitude(double? value) => throw _privateConstructorUsedError;
  String get method => throw _privateConstructorUsedError;
  set method(String value) => throw _privateConstructorUsedError; // 이동수단
  String get source => throw _privateConstructorUsedError; // 이동수단
  set source(String value) => throw _privateConstructorUsedError;

  /// Serializes this MovementData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MovementData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MovementDataCopyWith<MovementData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MovementDataCopyWith<$Res> {
  factory $MovementDataCopyWith(
          MovementData value, $Res Function(MovementData) then) =
      _$MovementDataCopyWithImpl<$Res, MovementData>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime startTime,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime endTime,
      @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
      Duration duration,
      @JsonKey(
          fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
      Duration? minDuration,
      @JsonKey(
          fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
      Duration? maxDuration,
      double distance,
      double? startLatitude,
      double? startLongitude,
      double? endLatitude,
      double? endLongitude,
      String method,
      String source});
}

/// @nodoc
class _$MovementDataCopyWithImpl<$Res, $Val extends MovementData>
    implements $MovementDataCopyWith<$Res> {
  _$MovementDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MovementData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = null,
    Object? endTime = null,
    Object? duration = null,
    Object? minDuration = freezed,
    Object? maxDuration = freezed,
    Object? distance = null,
    Object? startLatitude = freezed,
    Object? startLongitude = freezed,
    Object? endLatitude = freezed,
    Object? endLongitude = freezed,
    Object? method = null,
    Object? source = null,
  }) {
    return _then(_value.copyWith(
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      minDuration: freezed == minDuration
          ? _value.minDuration
          : minDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      maxDuration: freezed == maxDuration
          ? _value.maxDuration
          : maxDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
      startLatitude: freezed == startLatitude
          ? _value.startLatitude
          : startLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      startLongitude: freezed == startLongitude
          ? _value.startLongitude
          : startLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      endLatitude: freezed == endLatitude
          ? _value.endLatitude
          : endLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      endLongitude: freezed == endLongitude
          ? _value.endLongitude
          : endLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MovementDataImplCopyWith<$Res>
    implements $MovementDataCopyWith<$Res> {
  factory _$$MovementDataImplCopyWith(
          _$MovementDataImpl value, $Res Function(_$MovementDataImpl) then) =
      __$$MovementDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime startTime,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime endTime,
      @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
      Duration duration,
      @JsonKey(
          fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
      Duration? minDuration,
      @JsonKey(
          fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
      Duration? maxDuration,
      double distance,
      double? startLatitude,
      double? startLongitude,
      double? endLatitude,
      double? endLongitude,
      String method,
      String source});
}

/// @nodoc
class __$$MovementDataImplCopyWithImpl<$Res>
    extends _$MovementDataCopyWithImpl<$Res, _$MovementDataImpl>
    implements _$$MovementDataImplCopyWith<$Res> {
  __$$MovementDataImplCopyWithImpl(
      _$MovementDataImpl _value, $Res Function(_$MovementDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of MovementData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = null,
    Object? endTime = null,
    Object? duration = null,
    Object? minDuration = freezed,
    Object? maxDuration = freezed,
    Object? distance = null,
    Object? startLatitude = freezed,
    Object? startLongitude = freezed,
    Object? endLatitude = freezed,
    Object? endLongitude = freezed,
    Object? method = null,
    Object? source = null,
  }) {
    return _then(_$MovementDataImpl(
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      minDuration: freezed == minDuration
          ? _value.minDuration
          : minDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      maxDuration: freezed == maxDuration
          ? _value.maxDuration
          : maxDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
      startLatitude: freezed == startLatitude
          ? _value.startLatitude
          : startLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      startLongitude: freezed == startLongitude
          ? _value.startLongitude
          : startLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      endLatitude: freezed == endLatitude
          ? _value.endLatitude
          : endLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      endLongitude: freezed == endLongitude
          ? _value.endLongitude
          : endLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MovementDataImpl implements _MovementData {
  _$MovementDataImpl(
      {@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      required this.startTime,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      required this.endTime,
      @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
      required this.duration,
      @JsonKey(
          fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
      this.minDuration,
      @JsonKey(
          fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
      this.maxDuration,
      required this.distance,
      this.startLatitude,
      this.startLongitude,
      this.endLatitude,
      this.endLongitude,
      required this.method,
      required this.source});

  factory _$MovementDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$MovementDataImplFromJson(json);

  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime startTime;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime endTime;
  @override
  @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
  Duration duration;
  @override
  @JsonKey(fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
  Duration? minDuration;
  @override
  @JsonKey(fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
  Duration? maxDuration;
  @override
  double distance;
  @override
  double? startLatitude;
  @override
  double? startLongitude;
  @override
  double? endLatitude;
  @override
  double? endLongitude;
  @override
  String method;
// 이동수단
  @override
  String source;

  @override
  String toString() {
    return 'MovementData(startTime: $startTime, endTime: $endTime, duration: $duration, minDuration: $minDuration, maxDuration: $maxDuration, distance: $distance, startLatitude: $startLatitude, startLongitude: $startLongitude, endLatitude: $endLatitude, endLongitude: $endLongitude, method: $method, source: $source)';
  }

  /// Create a copy of MovementData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MovementDataImplCopyWith<_$MovementDataImpl> get copyWith =>
      __$$MovementDataImplCopyWithImpl<_$MovementDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MovementDataImplToJson(
      this,
    );
  }
}

abstract class _MovementData implements MovementData {
  factory _MovementData(
      {@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      required DateTime startTime,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      required DateTime endTime,
      @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
      required Duration duration,
      @JsonKey(
          fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
      Duration? minDuration,
      @JsonKey(
          fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
      Duration? maxDuration,
      required double distance,
      double? startLatitude,
      double? startLongitude,
      double? endLatitude,
      double? endLongitude,
      required String method,
      required String source}) = _$MovementDataImpl;

  factory _MovementData.fromJson(Map<String, dynamic> json) =
      _$MovementDataImpl.fromJson;

  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime get startTime;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  set startTime(DateTime value);
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime get endTime;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  set endTime(DateTime value);
  @override
  @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
  Duration get duration;
  @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
  set duration(Duration value);
  @override
  @JsonKey(fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
  Duration? get minDuration;
  @JsonKey(fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
  set minDuration(Duration? value);
  @override
  @JsonKey(fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
  Duration? get maxDuration;
  @JsonKey(fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
  set maxDuration(Duration? value);
  @override
  double get distance;
  set distance(double value);
  @override
  double? get startLatitude;
  set startLatitude(double? value);
  @override
  double? get startLongitude;
  set startLongitude(double? value);
  @override
  double? get endLatitude;
  set endLatitude(double? value);
  @override
  double? get endLongitude;
  set endLongitude(double? value);
  @override
  String get method;
  set method(String value); // 이동수단
  @override
  String get source; // 이동수단
  set source(String value);

  /// Create a copy of MovementData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MovementDataImplCopyWith<_$MovementDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
