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
  int get id => throw _privateConstructorUsedError;
  set id(int value) => throw _privateConstructorUsedError;
  List<int> get users => throw _privateConstructorUsedError;
  set users(List<int> value) => throw _privateConstructorUsedError;
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
  set iconColor(Color value) =>
      throw _privateConstructorUsedError; // @Default([]) List<DailyItineraryData> dailyItinerariesData,
// @Default([])
// @JsonKey(includeToJson: false, includeFromJson: false)
// List<DailyItineraryCubit> dailyItineraryCubitList,
  @JsonKey(
      fromJson: _dailyItineraryCubitListFromJson,
      toJson: _dailyItineraryCubitListToJson)
  List<DailyItineraryCubit> get dailyItineraryCubitList =>
      throw _privateConstructorUsedError; // @Default([]) List<DailyItineraryData> dailyItinerariesData,
// @Default([])
// @JsonKey(includeToJson: false, includeFromJson: false)
// List<DailyItineraryCubit> dailyItineraryCubitList,
  @JsonKey(
      fromJson: _dailyItineraryCubitListFromJson,
      toJson: _dailyItineraryCubitListToJson)
  set dailyItineraryCubitList(List<DailyItineraryCubit> value) =>
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
      {int id,
      List<int> users,
      String title,
      String? description,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime startDate,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime endDate,
      String? iconPath,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) Color iconColor,
      @JsonKey(
          fromJson: _dailyItineraryCubitListFromJson,
          toJson: _dailyItineraryCubitListToJson)
      List<DailyItineraryCubit> dailyItineraryCubitList});
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
    Object? iconColor = freezed,
    Object? dailyItineraryCubitList = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      users: null == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as List<int>,
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
      iconColor: freezed == iconColor
          ? _value.iconColor
          : iconColor // ignore: cast_nullable_to_non_nullable
              as Color,
      dailyItineraryCubitList: null == dailyItineraryCubitList
          ? _value.dailyItineraryCubitList
          : dailyItineraryCubitList // ignore: cast_nullable_to_non_nullable
              as List<DailyItineraryCubit>,
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
      {int id,
      List<int> users,
      String title,
      String? description,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime startDate,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime endDate,
      String? iconPath,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) Color iconColor,
      @JsonKey(
          fromJson: _dailyItineraryCubitListFromJson,
          toJson: _dailyItineraryCubitListToJson)
      List<DailyItineraryCubit> dailyItineraryCubitList});
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
    Object? iconColor = freezed,
    Object? dailyItineraryCubitList = null,
  }) {
    return _then(_$ItineraryDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      users: null == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as List<int>,
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
      iconColor: freezed == iconColor
          ? _value.iconColor
          : iconColor // ignore: cast_nullable_to_non_nullable
              as Color,
      dailyItineraryCubitList: null == dailyItineraryCubitList
          ? _value.dailyItineraryCubitList
          : dailyItineraryCubitList // ignore: cast_nullable_to_non_nullable
              as List<DailyItineraryCubit>,
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
      @JsonKey(
          fromJson: _dailyItineraryCubitListFromJson,
          toJson: _dailyItineraryCubitListToJson)
      this.dailyItineraryCubitList = const []})
      : super._();

  factory _$ItineraryDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItineraryDataImplFromJson(json);

  @override
  int id;
  @override
  List<int> users;
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
// @Default([]) List<DailyItineraryData> dailyItinerariesData,
// @Default([])
// @JsonKey(includeToJson: false, includeFromJson: false)
// List<DailyItineraryCubit> dailyItineraryCubitList,
  @override
  @JsonKey(
      fromJson: _dailyItineraryCubitListFromJson,
      toJson: _dailyItineraryCubitListToJson)
  List<DailyItineraryCubit> dailyItineraryCubitList;

  @override
  String toString() {
    return 'ItineraryData(id: $id, users: $users, title: $title, description: $description, startDate: $startDate, endDate: $endDate, iconPath: $iconPath, iconColor: $iconColor, dailyItineraryCubitList: $dailyItineraryCubitList)';
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
      {required int id,
      required List<int> users,
      required String title,
      String? description,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      required DateTime startDate,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      required DateTime endDate,
      String? iconPath,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
      required Color iconColor,
      @JsonKey(
          fromJson: _dailyItineraryCubitListFromJson,
          toJson: _dailyItineraryCubitListToJson)
      List<DailyItineraryCubit> dailyItineraryCubitList}) = _$ItineraryDataImpl;
  _ItineraryData._() : super._();

  factory _ItineraryData.fromJson(Map<String, dynamic> json) =
      _$ItineraryDataImpl.fromJson;

  @override
  int get id;
  set id(int value);
  @override
  List<int> get users;
  set users(List<int> value);
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
  set iconColor(
      Color
          value); // @Default([]) List<DailyItineraryData> dailyItinerariesData,
// @Default([])
// @JsonKey(includeToJson: false, includeFromJson: false)
// List<DailyItineraryCubit> dailyItineraryCubitList,
  @override
  @JsonKey(
      fromJson: _dailyItineraryCubitListFromJson,
      toJson: _dailyItineraryCubitListToJson)
  List<DailyItineraryCubit>
      get dailyItineraryCubitList; // @Default([]) List<DailyItineraryData> dailyItinerariesData,
// @Default([])
// @JsonKey(includeToJson: false, includeFromJson: false)
// List<DailyItineraryCubit> dailyItineraryCubitList,
  @JsonKey(
      fromJson: _dailyItineraryCubitListFromJson,
      toJson: _dailyItineraryCubitListToJson)
  set dailyItineraryCubitList(List<DailyItineraryCubit> value);

  /// Create a copy of ItineraryData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItineraryDataImplCopyWith<_$ItineraryDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
