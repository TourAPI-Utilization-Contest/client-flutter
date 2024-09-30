// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'itinerary_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ItineraryData _$ItineraryDataFromJson(Map<String, dynamic> json) {
  return _ItineraryData.fromJson(json);
}

/// @nodoc
mixin _$ItineraryData {
  String get id => throw _privateConstructorUsedError;
  set id(String value) => throw _privateConstructorUsedError;
  List<String> get users => throw _privateConstructorUsedError;
  set users(List<String> value) => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  set title(String value) => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  set description(String? value) => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime get startDate => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  set startDate(DateTime value) => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime get endDate => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  set endDate(DateTime value) => throw _privateConstructorUsedError;
  String? get iconPath => throw _privateConstructorUsedError;
  set iconPath(String? value) => throw _privateConstructorUsedError; // svg icon
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color get iconColor => throw _privateConstructorUsedError; // svg icon
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  set iconColor(Color value) => throw _privateConstructorUsedError;
  List<DailyItinerary> get dailyItineraries =>
      throw _privateConstructorUsedError;
  set dailyItineraries(List<DailyItinerary> value) =>
      throw _privateConstructorUsedError;

  /// Serializes this ItineraryData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ItineraryData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItineraryDataCopyWith<ItineraryData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItineraryDataCopyWith<$Res> {
  factory $ItineraryDataCopyWith(
          ItineraryData value, $Res Function(ItineraryData) then) =
      _$ItineraryDataCopyWithImpl<$Res, ItineraryData>;
  @useResult
  $Res call(
      {String id,
      List<String> users,
      String title,
      String? description,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime startDate,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime endDate,
      String? iconPath,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) Color iconColor,
      List<DailyItinerary> dailyItineraries});
}

/// @nodoc
class _$ItineraryDataCopyWithImpl<$Res, $Val extends ItineraryData>
    implements $ItineraryDataCopyWith<$Res> {
  _$ItineraryDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ItineraryData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? users = null,
    Object? title = null,
    Object? description = freezed,
    Object? startDate = null,
    Object? endDate = null,
    Object? iconPath = freezed,
    Object? iconColor = null,
    Object? dailyItineraries = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      users: null == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as List<String>,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      iconPath: freezed == iconPath
          ? _value.iconPath
          : iconPath // ignore: cast_nullable_to_non_nullable
              as String?,
      iconColor: null == iconColor
          ? _value.iconColor
          : iconColor // ignore: cast_nullable_to_non_nullable
              as Color,
      dailyItineraries: null == dailyItineraries
          ? _value.dailyItineraries
          : dailyItineraries // ignore: cast_nullable_to_non_nullable
              as List<DailyItinerary>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ItineraryDataImplCopyWith<$Res>
    implements $ItineraryDataCopyWith<$Res> {
  factory _$$ItineraryDataImplCopyWith(
          _$ItineraryDataImpl value, $Res Function(_$ItineraryDataImpl) then) =
      __$$ItineraryDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      List<String> users,
      String title,
      String? description,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime startDate,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime endDate,
      String? iconPath,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) Color iconColor,
      List<DailyItinerary> dailyItineraries});
}

/// @nodoc
class __$$ItineraryDataImplCopyWithImpl<$Res>
    extends _$ItineraryDataCopyWithImpl<$Res, _$ItineraryDataImpl>
    implements _$$ItineraryDataImplCopyWith<$Res> {
  __$$ItineraryDataImplCopyWithImpl(
      _$ItineraryDataImpl _value, $Res Function(_$ItineraryDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ItineraryData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? users = null,
    Object? title = null,
    Object? description = freezed,
    Object? startDate = null,
    Object? endDate = null,
    Object? iconPath = freezed,
    Object? iconColor = null,
    Object? dailyItineraries = null,
  }) {
    return _then(_$ItineraryDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      users: null == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as List<String>,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      iconPath: freezed == iconPath
          ? _value.iconPath
          : iconPath // ignore: cast_nullable_to_non_nullable
              as String?,
      iconColor: null == iconColor
          ? _value.iconColor
          : iconColor // ignore: cast_nullable_to_non_nullable
              as Color,
      dailyItineraries: null == dailyItineraries
          ? _value.dailyItineraries
          : dailyItineraries // ignore: cast_nullable_to_non_nullable
              as List<DailyItinerary>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ItineraryDataImpl extends _ItineraryData {
  _$ItineraryDataImpl(
      {required this.id,
      required this.users,
      required this.title,
      this.description,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      required this.startDate,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      required this.endDate,
      this.iconPath,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
      required this.iconColor,
      this.dailyItineraries = const []})
      : super._();

  factory _$ItineraryDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItineraryDataImplFromJson(json);

  @override
  String id;
  @override
  List<String> users;
  @override
  String title;
  @override
  String? description;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime startDate;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime endDate;
  @override
  String? iconPath;
// svg icon
  @override
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color iconColor;
  @override
  @JsonKey()
  List<DailyItinerary> dailyItineraries;

  @override
  String toString() {
    return 'ItineraryData(id: $id, users: $users, title: $title, description: $description, startDate: $startDate, endDate: $endDate, iconPath: $iconPath, iconColor: $iconColor, dailyItineraries: $dailyItineraries)';
  }

  /// Create a copy of ItineraryData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItineraryDataImplCopyWith<_$ItineraryDataImpl> get copyWith =>
      __$$ItineraryDataImplCopyWithImpl<_$ItineraryDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ItineraryDataImplToJson(
      this,
    );
  }
}

abstract class _ItineraryData extends ItineraryData {
  factory _ItineraryData(
      {required String id,
      required List<String> users,
      required String title,
      String? description,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      required DateTime startDate,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      required DateTime endDate,
      String? iconPath,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
      required Color iconColor,
      List<DailyItinerary> dailyItineraries}) = _$ItineraryDataImpl;
  _ItineraryData._() : super._();

  factory _ItineraryData.fromJson(Map<String, dynamic> json) =
      _$ItineraryDataImpl.fromJson;

  @override
  String get id;
  set id(String value);
  @override
  List<String> get users;
  set users(List<String> value);
  @override
  String get title;
  set title(String value);
  @override
  String? get description;
  set description(String? value);
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime get startDate;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  set startDate(DateTime value);
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime get endDate;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  set endDate(DateTime value);
  @override
  String? get iconPath;
  set iconPath(String? value); // svg icon
  @override
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color get iconColor; // svg icon
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  set iconColor(Color value);
  @override
  List<DailyItinerary> get dailyItineraries;
  set dailyItineraries(List<DailyItinerary> value);

  /// Create a copy of ItineraryData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItineraryDataImplCopyWith<_$ItineraryDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
