// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'place_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlaceData _$PlaceDataFromJson(Map<String, dynamic> json) {
  return _PlaceData.fromJson(json);
}

/// @nodoc
mixin _$PlaceData {
  int get id => throw _privateConstructorUsedError; // contentid
  String get title => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
  Duration? get stayTime => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? get visitTime => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? get createdTime => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  String? get homepage => throw _privateConstructorUsedError; // String? tag,
  List<String> get tags => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  bool get isProvided => throw _privateConstructorUsedError;
  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  Color? get iconColor => throw _privateConstructorUsedError;

  /// Serializes this PlaceData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlaceData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlaceDataCopyWith<PlaceData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaceDataCopyWith<$Res> {
  factory $PlaceDataCopyWith(PlaceData value, $Res Function(PlaceData) then) =
      _$PlaceDataCopyWithImpl<$Res, PlaceData>;
  @useResult
  $Res call(
      {int id,
      String title,
      String address,
      double latitude,
      double longitude,
      @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
      Duration? stayTime,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime? visitTime,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime? createdTime,
      String? description,
      String? phoneNumber,
      String? homepage,
      List<String> tags,
      String? imageUrl,
      String? thumbnailUrl,
      bool isProvided,
      @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
      Color? iconColor});
}

/// @nodoc
class _$PlaceDataCopyWithImpl<$Res, $Val extends PlaceData>
    implements $PlaceDataCopyWith<$Res> {
  _$PlaceDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlaceData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? address = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? stayTime = freezed,
    Object? visitTime = freezed,
    Object? createdTime = freezed,
    Object? description = freezed,
    Object? phoneNumber = freezed,
    Object? homepage = freezed,
    Object? tags = null,
    Object? imageUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? isProvided = null,
    Object? iconColor = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      stayTime: freezed == stayTime
          ? _value.stayTime
          : stayTime // ignore: cast_nullable_to_non_nullable
              as Duration?,
      visitTime: freezed == visitTime
          ? _value.visitTime
          : visitTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdTime: freezed == createdTime
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      homepage: freezed == homepage
          ? _value.homepage
          : homepage // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isProvided: null == isProvided
          ? _value.isProvided
          : isProvided // ignore: cast_nullable_to_non_nullable
              as bool,
      iconColor: freezed == iconColor
          ? _value.iconColor
          : iconColor // ignore: cast_nullable_to_non_nullable
              as Color?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlaceDataImplCopyWith<$Res>
    implements $PlaceDataCopyWith<$Res> {
  factory _$$PlaceDataImplCopyWith(
          _$PlaceDataImpl value, $Res Function(_$PlaceDataImpl) then) =
      __$$PlaceDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String address,
      double latitude,
      double longitude,
      @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
      Duration? stayTime,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime? visitTime,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime? createdTime,
      String? description,
      String? phoneNumber,
      String? homepage,
      List<String> tags,
      String? imageUrl,
      String? thumbnailUrl,
      bool isProvided,
      @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
      Color? iconColor});
}

/// @nodoc
class __$$PlaceDataImplCopyWithImpl<$Res>
    extends _$PlaceDataCopyWithImpl<$Res, _$PlaceDataImpl>
    implements _$$PlaceDataImplCopyWith<$Res> {
  __$$PlaceDataImplCopyWithImpl(
      _$PlaceDataImpl _value, $Res Function(_$PlaceDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlaceData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? address = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? stayTime = freezed,
    Object? visitTime = freezed,
    Object? createdTime = freezed,
    Object? description = freezed,
    Object? phoneNumber = freezed,
    Object? homepage = freezed,
    Object? tags = null,
    Object? imageUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? isProvided = null,
    Object? iconColor = freezed,
  }) {
    return _then(_$PlaceDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      stayTime: freezed == stayTime
          ? _value.stayTime
          : stayTime // ignore: cast_nullable_to_non_nullable
              as Duration?,
      visitTime: freezed == visitTime
          ? _value.visitTime
          : visitTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdTime: freezed == createdTime
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      homepage: freezed == homepage
          ? _value.homepage
          : homepage // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isProvided: null == isProvided
          ? _value.isProvided
          : isProvided // ignore: cast_nullable_to_non_nullable
              as bool,
      iconColor: freezed == iconColor
          ? _value.iconColor
          : iconColor // ignore: cast_nullable_to_non_nullable
              as Color?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaceDataImpl implements _PlaceData {
  const _$PlaceDataImpl(
      {required this.id,
      required this.title,
      required this.address,
      required this.latitude,
      required this.longitude,
      @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
      this.stayTime,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      this.visitTime,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      this.createdTime,
      this.description,
      this.phoneNumber,
      this.homepage,
      final List<String> tags = const [],
      this.imageUrl,
      this.thumbnailUrl,
      this.isProvided = false,
      @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson) this.iconColor})
      : _tags = tags;

  factory _$PlaceDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaceDataImplFromJson(json);

  @override
  final int id;
// contentid
  @override
  final String title;
  @override
  final String address;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
  final Duration? stayTime;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? visitTime;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? createdTime;
  @override
  final String? description;
  @override
  final String? phoneNumber;
  @override
  final String? homepage;
// String? tag,
  final List<String> _tags;
// String? tag,
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final String? imageUrl;
  @override
  final String? thumbnailUrl;
  @override
  @JsonKey()
  final bool isProvided;
  @override
  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final Color? iconColor;

  @override
  String toString() {
    return 'PlaceData(id: $id, title: $title, address: $address, latitude: $latitude, longitude: $longitude, stayTime: $stayTime, visitTime: $visitTime, createdTime: $createdTime, description: $description, phoneNumber: $phoneNumber, homepage: $homepage, tags: $tags, imageUrl: $imageUrl, thumbnailUrl: $thumbnailUrl, isProvided: $isProvided, iconColor: $iconColor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaceDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.stayTime, stayTime) ||
                other.stayTime == stayTime) &&
            (identical(other.visitTime, visitTime) ||
                other.visitTime == visitTime) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.homepage, homepage) ||
                other.homepage == homepage) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.isProvided, isProvided) ||
                other.isProvided == isProvided) &&
            (identical(other.iconColor, iconColor) ||
                other.iconColor == iconColor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      address,
      latitude,
      longitude,
      stayTime,
      visitTime,
      createdTime,
      description,
      phoneNumber,
      homepage,
      const DeepCollectionEquality().hash(_tags),
      imageUrl,
      thumbnailUrl,
      isProvided,
      iconColor);

  /// Create a copy of PlaceData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaceDataImplCopyWith<_$PlaceDataImpl> get copyWith =>
      __$$PlaceDataImplCopyWithImpl<_$PlaceDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaceDataImplToJson(
      this,
    );
  }
}

abstract class _PlaceData implements PlaceData {
  const factory _PlaceData(
      {required final int id,
      required final String title,
      required final String address,
      required final double latitude,
      required final double longitude,
      @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
      final Duration? stayTime,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      final DateTime? visitTime,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      final DateTime? createdTime,
      final String? description,
      final String? phoneNumber,
      final String? homepage,
      final List<String> tags,
      final String? imageUrl,
      final String? thumbnailUrl,
      final bool isProvided,
      @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
      final Color? iconColor}) = _$PlaceDataImpl;

  factory _PlaceData.fromJson(Map<String, dynamic> json) =
      _$PlaceDataImpl.fromJson;

  @override
  int get id; // contentid
  @override
  String get title;
  @override
  String get address;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
  Duration? get stayTime;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? get visitTime;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? get createdTime;
  @override
  String? get description;
  @override
  String? get phoneNumber;
  @override
  String? get homepage; // String? tag,
  @override
  List<String> get tags;
  @override
  String? get imageUrl;
  @override
  String? get thumbnailUrl;
  @override
  bool get isProvided;
  @override
  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  Color? get iconColor;

  /// Create a copy of PlaceData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlaceDataImplCopyWith<_$PlaceDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
