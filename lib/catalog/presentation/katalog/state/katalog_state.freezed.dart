// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'katalog_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KatalogState {

 bool get initialized; KatalogMode get mode; bool get isLoading; bool get hasError; List<Part> get parts; Map<String, MotorModel> get motorModelsById; List<Motor> get garageMotors; String? get unitModelId; String? get unitNickname; String? get unitPlateNumber; String get selectedCategory; String get searchQuery; bool get compatOnlyEnabled; Set<String> get stagedPartIds; Set<String> get initialPartIds;
/// Create a copy of KatalogState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KatalogStateCopyWith<KatalogState> get copyWith => _$KatalogStateCopyWithImpl<KatalogState>(this as KatalogState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KatalogState&&(identical(other.initialized, initialized) || other.initialized == initialized)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&const DeepCollectionEquality().equals(other.parts, parts)&&const DeepCollectionEquality().equals(other.motorModelsById, motorModelsById)&&const DeepCollectionEquality().equals(other.garageMotors, garageMotors)&&(identical(other.unitModelId, unitModelId) || other.unitModelId == unitModelId)&&(identical(other.unitNickname, unitNickname) || other.unitNickname == unitNickname)&&(identical(other.unitPlateNumber, unitPlateNumber) || other.unitPlateNumber == unitPlateNumber)&&(identical(other.selectedCategory, selectedCategory) || other.selectedCategory == selectedCategory)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.compatOnlyEnabled, compatOnlyEnabled) || other.compatOnlyEnabled == compatOnlyEnabled)&&const DeepCollectionEquality().equals(other.stagedPartIds, stagedPartIds)&&const DeepCollectionEquality().equals(other.initialPartIds, initialPartIds));
}


@override
int get hashCode => Object.hash(runtimeType,initialized,mode,isLoading,hasError,const DeepCollectionEquality().hash(parts),const DeepCollectionEquality().hash(motorModelsById),const DeepCollectionEquality().hash(garageMotors),unitModelId,unitNickname,unitPlateNumber,selectedCategory,searchQuery,compatOnlyEnabled,const DeepCollectionEquality().hash(stagedPartIds),const DeepCollectionEquality().hash(initialPartIds));

@override
String toString() {
  return 'KatalogState(initialized: $initialized, mode: $mode, isLoading: $isLoading, hasError: $hasError, parts: $parts, motorModelsById: $motorModelsById, garageMotors: $garageMotors, unitModelId: $unitModelId, unitNickname: $unitNickname, unitPlateNumber: $unitPlateNumber, selectedCategory: $selectedCategory, searchQuery: $searchQuery, compatOnlyEnabled: $compatOnlyEnabled, stagedPartIds: $stagedPartIds, initialPartIds: $initialPartIds)';
}


}

/// @nodoc
abstract mixin class $KatalogStateCopyWith<$Res>  {
  factory $KatalogStateCopyWith(KatalogState value, $Res Function(KatalogState) _then) = _$KatalogStateCopyWithImpl;
@useResult
$Res call({
 bool initialized, KatalogMode mode, bool isLoading, bool hasError, List<Part> parts, Map<String, MotorModel> motorModelsById, List<Motor> garageMotors, String? unitModelId, String? unitNickname, String? unitPlateNumber, String selectedCategory, String searchQuery, bool compatOnlyEnabled, Set<String> stagedPartIds, Set<String> initialPartIds
});




}
/// @nodoc
class _$KatalogStateCopyWithImpl<$Res>
    implements $KatalogStateCopyWith<$Res> {
  _$KatalogStateCopyWithImpl(this._self, this._then);

  final KatalogState _self;
  final $Res Function(KatalogState) _then;

/// Create a copy of KatalogState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? initialized = null,Object? mode = null,Object? isLoading = null,Object? hasError = null,Object? parts = null,Object? motorModelsById = null,Object? garageMotors = null,Object? unitModelId = freezed,Object? unitNickname = freezed,Object? unitPlateNumber = freezed,Object? selectedCategory = null,Object? searchQuery = null,Object? compatOnlyEnabled = null,Object? stagedPartIds = null,Object? initialPartIds = null,}) {
  return _then(_self.copyWith(
initialized: null == initialized ? _self.initialized : initialized // ignore: cast_nullable_to_non_nullable
as bool,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as KatalogMode,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,parts: null == parts ? _self.parts : parts // ignore: cast_nullable_to_non_nullable
as List<Part>,motorModelsById: null == motorModelsById ? _self.motorModelsById : motorModelsById // ignore: cast_nullable_to_non_nullable
as Map<String, MotorModel>,garageMotors: null == garageMotors ? _self.garageMotors : garageMotors // ignore: cast_nullable_to_non_nullable
as List<Motor>,unitModelId: freezed == unitModelId ? _self.unitModelId : unitModelId // ignore: cast_nullable_to_non_nullable
as String?,unitNickname: freezed == unitNickname ? _self.unitNickname : unitNickname // ignore: cast_nullable_to_non_nullable
as String?,unitPlateNumber: freezed == unitPlateNumber ? _self.unitPlateNumber : unitPlateNumber // ignore: cast_nullable_to_non_nullable
as String?,selectedCategory: null == selectedCategory ? _self.selectedCategory : selectedCategory // ignore: cast_nullable_to_non_nullable
as String,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,compatOnlyEnabled: null == compatOnlyEnabled ? _self.compatOnlyEnabled : compatOnlyEnabled // ignore: cast_nullable_to_non_nullable
as bool,stagedPartIds: null == stagedPartIds ? _self.stagedPartIds : stagedPartIds // ignore: cast_nullable_to_non_nullable
as Set<String>,initialPartIds: null == initialPartIds ? _self.initialPartIds : initialPartIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [KatalogState].
extension KatalogStatePatterns on KatalogState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KatalogState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KatalogState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KatalogState value)  $default,){
final _that = this;
switch (_that) {
case _KatalogState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KatalogState value)?  $default,){
final _that = this;
switch (_that) {
case _KatalogState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool initialized,  KatalogMode mode,  bool isLoading,  bool hasError,  List<Part> parts,  Map<String, MotorModel> motorModelsById,  List<Motor> garageMotors,  String? unitModelId,  String? unitNickname,  String? unitPlateNumber,  String selectedCategory,  String searchQuery,  bool compatOnlyEnabled,  Set<String> stagedPartIds,  Set<String> initialPartIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KatalogState() when $default != null:
return $default(_that.initialized,_that.mode,_that.isLoading,_that.hasError,_that.parts,_that.motorModelsById,_that.garageMotors,_that.unitModelId,_that.unitNickname,_that.unitPlateNumber,_that.selectedCategory,_that.searchQuery,_that.compatOnlyEnabled,_that.stagedPartIds,_that.initialPartIds);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool initialized,  KatalogMode mode,  bool isLoading,  bool hasError,  List<Part> parts,  Map<String, MotorModel> motorModelsById,  List<Motor> garageMotors,  String? unitModelId,  String? unitNickname,  String? unitPlateNumber,  String selectedCategory,  String searchQuery,  bool compatOnlyEnabled,  Set<String> stagedPartIds,  Set<String> initialPartIds)  $default,) {final _that = this;
switch (_that) {
case _KatalogState():
return $default(_that.initialized,_that.mode,_that.isLoading,_that.hasError,_that.parts,_that.motorModelsById,_that.garageMotors,_that.unitModelId,_that.unitNickname,_that.unitPlateNumber,_that.selectedCategory,_that.searchQuery,_that.compatOnlyEnabled,_that.stagedPartIds,_that.initialPartIds);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool initialized,  KatalogMode mode,  bool isLoading,  bool hasError,  List<Part> parts,  Map<String, MotorModel> motorModelsById,  List<Motor> garageMotors,  String? unitModelId,  String? unitNickname,  String? unitPlateNumber,  String selectedCategory,  String searchQuery,  bool compatOnlyEnabled,  Set<String> stagedPartIds,  Set<String> initialPartIds)?  $default,) {final _that = this;
switch (_that) {
case _KatalogState() when $default != null:
return $default(_that.initialized,_that.mode,_that.isLoading,_that.hasError,_that.parts,_that.motorModelsById,_that.garageMotors,_that.unitModelId,_that.unitNickname,_that.unitPlateNumber,_that.selectedCategory,_that.searchQuery,_that.compatOnlyEnabled,_that.stagedPartIds,_that.initialPartIds);case _:
  return null;

}
}

}

/// @nodoc


class _KatalogState implements KatalogState {
  const _KatalogState({this.initialized = false, this.mode = KatalogMode.browse, this.isLoading = true, this.hasError = false, final  List<Part> parts = const <Part>[], final  Map<String, MotorModel> motorModelsById = const <String, MotorModel>{}, final  List<Motor> garageMotors = const <Motor>[], this.unitModelId, this.unitNickname, this.unitPlateNumber, this.selectedCategory = 'Semua', this.searchQuery = '', this.compatOnlyEnabled = true, final  Set<String> stagedPartIds = const <String>{}, final  Set<String> initialPartIds = const <String>{}}): _parts = parts,_motorModelsById = motorModelsById,_garageMotors = garageMotors,_stagedPartIds = stagedPartIds,_initialPartIds = initialPartIds;
  

@override@JsonKey() final  bool initialized;
@override@JsonKey() final  KatalogMode mode;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool hasError;
 final  List<Part> _parts;
@override@JsonKey() List<Part> get parts {
  if (_parts is EqualUnmodifiableListView) return _parts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parts);
}

 final  Map<String, MotorModel> _motorModelsById;
@override@JsonKey() Map<String, MotorModel> get motorModelsById {
  if (_motorModelsById is EqualUnmodifiableMapView) return _motorModelsById;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_motorModelsById);
}

 final  List<Motor> _garageMotors;
@override@JsonKey() List<Motor> get garageMotors {
  if (_garageMotors is EqualUnmodifiableListView) return _garageMotors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_garageMotors);
}

@override final  String? unitModelId;
@override final  String? unitNickname;
@override final  String? unitPlateNumber;
@override@JsonKey() final  String selectedCategory;
@override@JsonKey() final  String searchQuery;
@override@JsonKey() final  bool compatOnlyEnabled;
 final  Set<String> _stagedPartIds;
@override@JsonKey() Set<String> get stagedPartIds {
  if (_stagedPartIds is EqualUnmodifiableSetView) return _stagedPartIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_stagedPartIds);
}

 final  Set<String> _initialPartIds;
@override@JsonKey() Set<String> get initialPartIds {
  if (_initialPartIds is EqualUnmodifiableSetView) return _initialPartIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_initialPartIds);
}


/// Create a copy of KatalogState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KatalogStateCopyWith<_KatalogState> get copyWith => __$KatalogStateCopyWithImpl<_KatalogState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KatalogState&&(identical(other.initialized, initialized) || other.initialized == initialized)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&const DeepCollectionEquality().equals(other._parts, _parts)&&const DeepCollectionEquality().equals(other._motorModelsById, _motorModelsById)&&const DeepCollectionEquality().equals(other._garageMotors, _garageMotors)&&(identical(other.unitModelId, unitModelId) || other.unitModelId == unitModelId)&&(identical(other.unitNickname, unitNickname) || other.unitNickname == unitNickname)&&(identical(other.unitPlateNumber, unitPlateNumber) || other.unitPlateNumber == unitPlateNumber)&&(identical(other.selectedCategory, selectedCategory) || other.selectedCategory == selectedCategory)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.compatOnlyEnabled, compatOnlyEnabled) || other.compatOnlyEnabled == compatOnlyEnabled)&&const DeepCollectionEquality().equals(other._stagedPartIds, _stagedPartIds)&&const DeepCollectionEquality().equals(other._initialPartIds, _initialPartIds));
}


@override
int get hashCode => Object.hash(runtimeType,initialized,mode,isLoading,hasError,const DeepCollectionEquality().hash(_parts),const DeepCollectionEquality().hash(_motorModelsById),const DeepCollectionEquality().hash(_garageMotors),unitModelId,unitNickname,unitPlateNumber,selectedCategory,searchQuery,compatOnlyEnabled,const DeepCollectionEquality().hash(_stagedPartIds),const DeepCollectionEquality().hash(_initialPartIds));

@override
String toString() {
  return 'KatalogState(initialized: $initialized, mode: $mode, isLoading: $isLoading, hasError: $hasError, parts: $parts, motorModelsById: $motorModelsById, garageMotors: $garageMotors, unitModelId: $unitModelId, unitNickname: $unitNickname, unitPlateNumber: $unitPlateNumber, selectedCategory: $selectedCategory, searchQuery: $searchQuery, compatOnlyEnabled: $compatOnlyEnabled, stagedPartIds: $stagedPartIds, initialPartIds: $initialPartIds)';
}


}

/// @nodoc
abstract mixin class _$KatalogStateCopyWith<$Res> implements $KatalogStateCopyWith<$Res> {
  factory _$KatalogStateCopyWith(_KatalogState value, $Res Function(_KatalogState) _then) = __$KatalogStateCopyWithImpl;
@override @useResult
$Res call({
 bool initialized, KatalogMode mode, bool isLoading, bool hasError, List<Part> parts, Map<String, MotorModel> motorModelsById, List<Motor> garageMotors, String? unitModelId, String? unitNickname, String? unitPlateNumber, String selectedCategory, String searchQuery, bool compatOnlyEnabled, Set<String> stagedPartIds, Set<String> initialPartIds
});




}
/// @nodoc
class __$KatalogStateCopyWithImpl<$Res>
    implements _$KatalogStateCopyWith<$Res> {
  __$KatalogStateCopyWithImpl(this._self, this._then);

  final _KatalogState _self;
  final $Res Function(_KatalogState) _then;

/// Create a copy of KatalogState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? initialized = null,Object? mode = null,Object? isLoading = null,Object? hasError = null,Object? parts = null,Object? motorModelsById = null,Object? garageMotors = null,Object? unitModelId = freezed,Object? unitNickname = freezed,Object? unitPlateNumber = freezed,Object? selectedCategory = null,Object? searchQuery = null,Object? compatOnlyEnabled = null,Object? stagedPartIds = null,Object? initialPartIds = null,}) {
  return _then(_KatalogState(
initialized: null == initialized ? _self.initialized : initialized // ignore: cast_nullable_to_non_nullable
as bool,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as KatalogMode,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,parts: null == parts ? _self._parts : parts // ignore: cast_nullable_to_non_nullable
as List<Part>,motorModelsById: null == motorModelsById ? _self._motorModelsById : motorModelsById // ignore: cast_nullable_to_non_nullable
as Map<String, MotorModel>,garageMotors: null == garageMotors ? _self._garageMotors : garageMotors // ignore: cast_nullable_to_non_nullable
as List<Motor>,unitModelId: freezed == unitModelId ? _self.unitModelId : unitModelId // ignore: cast_nullable_to_non_nullable
as String?,unitNickname: freezed == unitNickname ? _self.unitNickname : unitNickname // ignore: cast_nullable_to_non_nullable
as String?,unitPlateNumber: freezed == unitPlateNumber ? _self.unitPlateNumber : unitPlateNumber // ignore: cast_nullable_to_non_nullable
as String?,selectedCategory: null == selectedCategory ? _self.selectedCategory : selectedCategory // ignore: cast_nullable_to_non_nullable
as String,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,compatOnlyEnabled: null == compatOnlyEnabled ? _self.compatOnlyEnabled : compatOnlyEnabled // ignore: cast_nullable_to_non_nullable
as bool,stagedPartIds: null == stagedPartIds ? _self._stagedPartIds : stagedPartIds // ignore: cast_nullable_to_non_nullable
as Set<String>,initialPartIds: null == initialPartIds ? _self._initialPartIds : initialPartIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}


}

// dart format on
