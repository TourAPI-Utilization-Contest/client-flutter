// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movement_detail_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MovementDetailData _$MovementDetailDataFromJson(Map<String, dynamic> json) {
  return _MovementDetailData.fromJson(json);
}

/// @nodoc
mixin _$MovementDetailData {
  @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
  Duration get duration => throw _privateConstructorUsedError;
  double get distance => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError; // 경로
  String get method =>
      throw _privateConstructorUsedError; // 이동수단(WALK, TRANSIT, DRIVE)
  String get source =>
      throw _privateConstructorUsedError; // 경로 출처(Google, Kakao)
  int? get stopCount => throw _privateConstructorUsedError; // 정차 횟수
  String? get name => throw _privateConstructorUsedError;
  String? get nameShort => throw _privateConstructorUsedError;

  /// Serializes this MovementDetailData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MovementDetailData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MovementDetailDataCopyWith<MovementDetailData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MovementDetailDataCopyWith<$Res> {
  factory $MovementDetailDataCopyWith(
          MovementDetailData value, $Res Function(MovementDetailData) then) =
      _$MovementDetailDataCopyWithImpl<$Res, MovementDetailData>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
      Duration duration,
      double distance,
      String path,
      String method,
      String source,
      int? stopCount,
      String? name,
      String? nameShort});
}

/// @nodoc
class _$MovementDetailDataCopyWithImpl<$Res, $Val extends MovementDetailData>
    implements $MovementDetailDataCopyWith<$Res> {
  _$MovementDetailDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MovementDetailData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? distance = null,
    Object? path = null,
    Object? method = null,
    Object? source = null,
    Object? stopCount = freezed,
    Object? name = freezed,
    Object? nameShort = freezed,
  }) {
    return _then(_value.copyWith(
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      stopCount: freezed == stopCount
          ? _value.stopCount
          : stopCount // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      nameShort: freezed == nameShort
          ? _value.nameShort
          : nameShort // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MovementDetailDataImplCopyWith<$Res>
    implements $MovementDetailDataCopyWith<$Res> {
  factory _$$MovementDetailDataImplCopyWith(_$MovementDetailDataImpl value,
          $Res Function(_$MovementDetailDataImpl) then) =
      __$$MovementDetailDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
      Duration duration,
      double distance,
      String path,
      String method,
      String source,
      int? stopCount,
      String? name,
      String? nameShort});
}

/// @nodoc
class __$$MovementDetailDataImplCopyWithImpl<$Res>
    extends _$MovementDetailDataCopyWithImpl<$Res, _$MovementDetailDataImpl>
    implements _$$MovementDetailDataImplCopyWith<$Res> {
  __$$MovementDetailDataImplCopyWithImpl(_$MovementDetailDataImpl _value,
      $Res Function(_$MovementDetailDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of MovementDetailData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? distance = null,
    Object? path = null,
    Object? method = null,
    Object? source = null,
    Object? stopCount = freezed,
    Object? name = freezed,
    Object? nameShort = freezed,
  }) {
    return _then(_$MovementDetailDataImpl(
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      stopCount: freezed == stopCount
          ? _value.stopCount
          : stopCount // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      nameShort: freezed == nameShort
          ? _value.nameShort
          : nameShort // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MovementDetailDataImpl implements _MovementDetailData {
  _$MovementDetailDataImpl(
      {@JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
      required this.duration,
      required this.distance,
      required this.path,
      required this.method,
      required this.source,
      this.stopCount,
      this.name,
      this.nameShort});

  factory _$MovementDetailDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$MovementDetailDataImplFromJson(json);

  @override
  @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
  final Duration duration;
  @override
  final double distance;
  @override
  final String path;
// 경로
  @override
  final String method;
// 이동수단(WALK, TRANSIT, DRIVE)
  @override
  final String source;
// 경로 출처(Google, Kakao)
  @override
  final int? stopCount;
// 정차 횟수
  @override
  final String? name;
  @override
  final String? nameShort;

  @override
  String toString() {
    return 'MovementDetailData(duration: $duration, distance: $distance, path: $path, method: $method, source: $source, stopCount: $stopCount, name: $name, nameShort: $nameShort)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MovementDetailDataImpl &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.stopCount, stopCount) ||
                other.stopCount == stopCount) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nameShort, nameShort) ||
                other.nameShort == nameShort));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, duration, distance, path, method,
      source, stopCount, name, nameShort);

  /// Create a copy of MovementDetailData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MovementDetailDataImplCopyWith<_$MovementDetailDataImpl> get copyWith =>
      __$$MovementDetailDataImplCopyWithImpl<_$MovementDetailDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MovementDetailDataImplToJson(
      this,
    );
  }
}

abstract class _MovementDetailData implements MovementDetailData {
  factory _MovementDetailData(
      {@JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
      required final Duration duration,
      required final double distance,
      required final String path,
      required final String method,
      required final String source,
      final int? stopCount,
      final String? name,
      final String? nameShort}) = _$MovementDetailDataImpl;

  factory _MovementDetailData.fromJson(Map<String, dynamic> json) =
      _$MovementDetailDataImpl.fromJson;

  @override
  @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
  Duration get duration;
  @override
  double get distance;
  @override
  String get path; // 경로
  @override
  String get method; // 이동수단(WALK, TRANSIT, DRIVE)
  @override
  String get source; // 경로 출처(Google, Kakao)
  @override
  int? get stopCount; // 정차 횟수
  @override
  String? get name;
  @override
  String? get nameShort;

  /// Create a copy of MovementDetailData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MovementDetailDataImplCopyWith<_$MovementDetailDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
