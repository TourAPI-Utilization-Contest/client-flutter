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
  DateTime get endTime => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
  Duration get duration => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
  Duration? get minDuration => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
  Duration? get maxDuration => throw _privateConstructorUsedError;
  double get distance => throw _privateConstructorUsedError;
  double? get startLatitude => throw _privateConstructorUsedError;
  double? get startLongitude => throw _privateConstructorUsedError;
  double? get endLatitude => throw _privateConstructorUsedError;
  double? get endLongitude => throw _privateConstructorUsedError;
  String get method => throw _privateConstructorUsedError; // 이동수단
  String get source =>
      throw _privateConstructorUsedError; // 경로 출처(Google, Kakao)
  List<MovementDetailData> get details => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get processing => throw _privateConstructorUsedError;

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
      String source,
      List<MovementDetailData> details,
      @JsonKey(includeFromJson: false, includeToJson: false) bool processing});
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
    Object? details = null,
    Object? processing = null,
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
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as List<MovementDetailData>,
      processing: null == processing
          ? _value.processing
          : processing // ignore: cast_nullable_to_non_nullable
              as bool,
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
      String source,
      List<MovementDetailData> details,
      @JsonKey(includeFromJson: false, includeToJson: false) bool processing});
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
    Object? details = null,
    Object? processing = null,
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
      details: null == details
          ? _value._details
          : details // ignore: cast_nullable_to_non_nullable
              as List<MovementDetailData>,
      processing: null == processing
          ? _value.processing
          : processing // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
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
      required this.source,
      final List<MovementDetailData> details = const [],
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.processing = false})
      : _details = details;

  factory _$MovementDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$MovementDataImplFromJson(json);

  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime startTime;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime endTime;
  @override
  @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
  final Duration duration;
  @override
  @JsonKey(fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
  final Duration? minDuration;
  @override
  @JsonKey(fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
  final Duration? maxDuration;
  @override
  final double distance;
  @override
  final double? startLatitude;
  @override
  final double? startLongitude;
  @override
  final double? endLatitude;
  @override
  final double? endLongitude;
  @override
  final String method;
// 이동수단
  @override
  final String source;
// 경로 출처(Google, Kakao)
  final List<MovementDetailData> _details;
// 경로 출처(Google, Kakao)
  @override
  @JsonKey()
  List<MovementDetailData> get details {
    if (_details is EqualUnmodifiableListView) return _details;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_details);
  }

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool processing;

  @override
  String toString() {
    return 'MovementData(startTime: $startTime, endTime: $endTime, duration: $duration, minDuration: $minDuration, maxDuration: $maxDuration, distance: $distance, startLatitude: $startLatitude, startLongitude: $startLongitude, endLatitude: $endLatitude, endLongitude: $endLongitude, method: $method, source: $source, details: $details, processing: $processing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MovementDataImpl &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.minDuration, minDuration) ||
                other.minDuration == minDuration) &&
            (identical(other.maxDuration, maxDuration) ||
                other.maxDuration == maxDuration) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.startLatitude, startLatitude) ||
                other.startLatitude == startLatitude) &&
            (identical(other.startLongitude, startLongitude) ||
                other.startLongitude == startLongitude) &&
            (identical(other.endLatitude, endLatitude) ||
                other.endLatitude == endLatitude) &&
            (identical(other.endLongitude, endLongitude) ||
                other.endLongitude == endLongitude) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.source, source) || other.source == source) &&
            const DeepCollectionEquality().equals(other._details, _details) &&
            (identical(other.processing, processing) ||
                other.processing == processing));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      startTime,
      endTime,
      duration,
      minDuration,
      maxDuration,
      distance,
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
      method,
      source,
      const DeepCollectionEquality().hash(_details),
      processing);

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
      required final DateTime startTime,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      required final DateTime endTime,
      @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
      required final Duration duration,
      @JsonKey(
          fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
      final Duration? minDuration,
      @JsonKey(
          fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
      final Duration? maxDuration,
      required final double distance,
      final double? startLatitude,
      final double? startLongitude,
      final double? endLatitude,
      final double? endLongitude,
      required final String method,
      required final String source,
      final List<MovementDetailData> details,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final bool processing}) = _$MovementDataImpl;

  factory _MovementData.fromJson(Map<String, dynamic> json) =
      _$MovementDataImpl.fromJson;

  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime get startTime;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime get endTime;
  @override
  @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
  Duration get duration;
  @override
  @JsonKey(fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
  Duration? get minDuration;
  @override
  @JsonKey(fromJson: _durationWithNullFromJson, toJson: _durationWithNullToJson)
  Duration? get maxDuration;
  @override
  double get distance;
  @override
  double? get startLatitude;
  @override
  double? get startLongitude;
  @override
  double? get endLatitude;
  @override
  double? get endLongitude;
  @override
  String get method; // 이동수단
  @override
  String get source; // 경로 출처(Google, Kakao)
  @override
  List<MovementDetailData> get details;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get processing;

  /// Create a copy of MovementData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MovementDataImplCopyWith<_$MovementDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
