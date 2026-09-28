// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'detail_servis_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DetailServisState {

 bool get isLoading; bool get hasError; List<ServiceType> get serviceTypes; List<Part> get parts; Map<String, Motor> get motorsById; String? get activeMotorId; Set<String> get manuallyExpandedComplaintMotorIds; Map<String, int> get droppedPartsCountByMotor;
/// Create a copy of DetailServisState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DetailServisStateCopyWith<DetailServisState> get copyWith => _$DetailServisStateCopyWithImpl<DetailServisState>(this as DetailServisState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DetailServisState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&const DeepCollectionEquality().equals(other.serviceTypes, serviceTypes)&&const DeepCollectionEquality().equals(other.parts, parts)&&const DeepCollectionEquality().equals(other.motorsById, motorsById)&&(identical(other.activeMotorId, activeMotorId) || other.activeMotorId == activeMotorId)&&const DeepCollectionEquality().equals(other.manuallyExpandedComplaintMotorIds, manuallyExpandedComplaintMotorIds)&&const DeepCollectionEquality().equals(other.droppedPartsCountByMotor, droppedPartsCountByMotor));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,const DeepCollectionEquality().hash(serviceTypes),const DeepCollectionEquality().hash(parts),const DeepCollectionEquality().hash(motorsById),activeMotorId,const DeepCollectionEquality().hash(manuallyExpandedComplaintMotorIds),const DeepCollectionEquality().hash(droppedPartsCountByMotor));

@override
String toString() {
  return 'DetailServisState(isLoading: $isLoading, hasError: $hasError, serviceTypes: $serviceTypes, parts: $parts, motorsById: $motorsById, activeMotorId: $activeMotorId, manuallyExpandedComplaintMotorIds: $manuallyExpandedComplaintMotorIds, droppedPartsCountByMotor: $droppedPartsCountByMotor)';
}


}

/// @nodoc
abstract mixin class $DetailServisStateCopyWith<$Res>  {
  factory $DetailServisStateCopyWith(DetailServisState value, $Res Function(DetailServisState) _then) = _$DetailServisStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool hasError, List<ServiceType> serviceTypes, List<Part> parts, Map<String, Motor> motorsById, String? activeMotorId, Set<String> manuallyExpandedComplaintMotorIds, Map<String, int> droppedPartsCountByMotor
});




}
/// @nodoc
class _$DetailServisStateCopyWithImpl<$Res>
    implements $DetailServisStateCopyWith<$Res> {
  _$DetailServisStateCopyWithImpl(this._self, this._then);

  final DetailServisState _self;
  final $Res Function(DetailServisState) _then;

/// Create a copy of DetailServisState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? hasError = null,Object? serviceTypes = null,Object? parts = null,Object? motorsById = null,Object? activeMotorId = freezed,Object? manuallyExpandedComplaintMotorIds = null,Object? droppedPartsCountByMotor = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,serviceTypes: null == serviceTypes ? _self.serviceTypes : serviceTypes // ignore: cast_nullable_to_non_nullable
as List<ServiceType>,parts: null == parts ? _self.parts : parts // ignore: cast_nullable_to_non_nullable
as List<Part>,motorsById: null == motorsById ? _self.motorsById : motorsById // ignore: cast_nullable_to_non_nullable
as Map<String, Motor>,activeMotorId: freezed == activeMotorId ? _self.activeMotorId : activeMotorId // ignore: cast_nullable_to_non_nullable
as String?,manuallyExpandedComplaintMotorIds: null == manuallyExpandedComplaintMotorIds ? _self.manuallyExpandedComplaintMotorIds : manuallyExpandedComplaintMotorIds // ignore: cast_nullable_to_non_nullable
as Set<String>,droppedPartsCountByMotor: null == droppedPartsCountByMotor ? _self.droppedPartsCountByMotor : droppedPartsCountByMotor // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}

}


/// Adds pattern-matching-related methods to [DetailServisState].
extension DetailServisStatePatterns on DetailServisState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DetailServisState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DetailServisState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DetailServisState value)  $default,){
final _that = this;
switch (_that) {
case _DetailServisState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DetailServisState value)?  $default,){
final _that = this;
switch (_that) {
case _DetailServisState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  List<ServiceType> serviceTypes,  List<Part> parts,  Map<String, Motor> motorsById,  String? activeMotorId,  Set<String> manuallyExpandedComplaintMotorIds,  Map<String, int> droppedPartsCountByMotor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DetailServisState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.serviceTypes,_that.parts,_that.motorsById,_that.activeMotorId,_that.manuallyExpandedComplaintMotorIds,_that.droppedPartsCountByMotor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  List<ServiceType> serviceTypes,  List<Part> parts,  Map<String, Motor> motorsById,  String? activeMotorId,  Set<String> manuallyExpandedComplaintMotorIds,  Map<String, int> droppedPartsCountByMotor)  $default,) {final _that = this;
switch (_that) {
case _DetailServisState():
return $default(_that.isLoading,_that.hasError,_that.serviceTypes,_that.parts,_that.motorsById,_that.activeMotorId,_that.manuallyExpandedComplaintMotorIds,_that.droppedPartsCountByMotor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool hasError,  List<ServiceType> serviceTypes,  List<Part> parts,  Map<String, Motor> motorsById,  String? activeMotorId,  Set<String> manuallyExpandedComplaintMotorIds,  Map<String, int> droppedPartsCountByMotor)?  $default,) {final _that = this;
switch (_that) {
case _DetailServisState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.serviceTypes,_that.parts,_that.motorsById,_that.activeMotorId,_that.manuallyExpandedComplaintMotorIds,_that.droppedPartsCountByMotor);case _:
  return null;

}
}

}

/// @nodoc


class _DetailServisState implements DetailServisState {
  const _DetailServisState({this.isLoading = true, this.hasError = false, final  List<ServiceType> serviceTypes = const <ServiceType>[], final  List<Part> parts = const <Part>[], final  Map<String, Motor> motorsById = const <String, Motor>{}, this.activeMotorId, final  Set<String> manuallyExpandedComplaintMotorIds = const <String>{}, final  Map<String, int> droppedPartsCountByMotor = const <String, int>{}}): _serviceTypes = serviceTypes,_parts = parts,_motorsById = motorsById,_manuallyExpandedComplaintMotorIds = manuallyExpandedComplaintMotorIds,_droppedPartsCountByMotor = droppedPartsCountByMotor;
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool hasError;
 final  List<ServiceType> _serviceTypes;
@override@JsonKey() List<ServiceType> get serviceTypes {
  if (_serviceTypes is EqualUnmodifiableListView) return _serviceTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_serviceTypes);
}

 final  List<Part> _parts;
@override@JsonKey() List<Part> get parts {
  if (_parts is EqualUnmodifiableListView) return _parts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parts);
}

 final  Map<String, Motor> _motorsById;
@override@JsonKey() Map<String, Motor> get motorsById {
  if (_motorsById is EqualUnmodifiableMapView) return _motorsById;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_motorsById);
}

@override final  String? activeMotorId;
 final  Set<String> _manuallyExpandedComplaintMotorIds;
@override@JsonKey() Set<String> get manuallyExpandedComplaintMotorIds {
  if (_manuallyExpandedComplaintMotorIds is EqualUnmodifiableSetView) return _manuallyExpandedComplaintMotorIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_manuallyExpandedComplaintMotorIds);
}

 final  Map<String, int> _droppedPartsCountByMotor;
@override@JsonKey() Map<String, int> get droppedPartsCountByMotor {
  if (_droppedPartsCountByMotor is EqualUnmodifiableMapView) return _droppedPartsCountByMotor;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_droppedPartsCountByMotor);
}


/// Create a copy of DetailServisState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DetailServisStateCopyWith<_DetailServisState> get copyWith => __$DetailServisStateCopyWithImpl<_DetailServisState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DetailServisState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&const DeepCollectionEquality().equals(other._serviceTypes, _serviceTypes)&&const DeepCollectionEquality().equals(other._parts, _parts)&&const DeepCollectionEquality().equals(other._motorsById, _motorsById)&&(identical(other.activeMotorId, activeMotorId) || other.activeMotorId == activeMotorId)&&const DeepCollectionEquality().equals(other._manuallyExpandedComplaintMotorIds, _manuallyExpandedComplaintMotorIds)&&const DeepCollectionEquality().equals(other._droppedPartsCountByMotor, _droppedPartsCountByMotor));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,const DeepCollectionEquality().hash(_serviceTypes),const DeepCollectionEquality().hash(_parts),const DeepCollectionEquality().hash(_motorsById),activeMotorId,const DeepCollectionEquality().hash(_manuallyExpandedComplaintMotorIds),const DeepCollectionEquality().hash(_droppedPartsCountByMotor));

@override
String toString() {
  return 'DetailServisState(isLoading: $isLoading, hasError: $hasError, serviceTypes: $serviceTypes, parts: $parts, motorsById: $motorsById, activeMotorId: $activeMotorId, manuallyExpandedComplaintMotorIds: $manuallyExpandedComplaintMotorIds, droppedPartsCountByMotor: $droppedPartsCountByMotor)';
}


}

/// @nodoc
abstract mixin class _$DetailServisStateCopyWith<$Res> implements $DetailServisStateCopyWith<$Res> {
  factory _$DetailServisStateCopyWith(_DetailServisState value, $Res Function(_DetailServisState) _then) = __$DetailServisStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool hasError, List<ServiceType> serviceTypes, List<Part> parts, Map<String, Motor> motorsById, String? activeMotorId, Set<String> manuallyExpandedComplaintMotorIds, Map<String, int> droppedPartsCountByMotor
});




}
/// @nodoc
class __$DetailServisStateCopyWithImpl<$Res>
    implements _$DetailServisStateCopyWith<$Res> {
  __$DetailServisStateCopyWithImpl(this._self, this._then);

  final _DetailServisState _self;
  final $Res Function(_DetailServisState) _then;

/// Create a copy of DetailServisState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? hasError = null,Object? serviceTypes = null,Object? parts = null,Object? motorsById = null,Object? activeMotorId = freezed,Object? manuallyExpandedComplaintMotorIds = null,Object? droppedPartsCountByMotor = null,}) {
  return _then(_DetailServisState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,serviceTypes: null == serviceTypes ? _self._serviceTypes : serviceTypes // ignore: cast_nullable_to_non_nullable
as List<ServiceType>,parts: null == parts ? _self._parts : parts // ignore: cast_nullable_to_non_nullable
as List<Part>,motorsById: null == motorsById ? _self._motorsById : motorsById // ignore: cast_nullable_to_non_nullable
as Map<String, Motor>,activeMotorId: freezed == activeMotorId ? _self.activeMotorId : activeMotorId // ignore: cast_nullable_to_non_nullable
as String?,manuallyExpandedComplaintMotorIds: null == manuallyExpandedComplaintMotorIds ? _self._manuallyExpandedComplaintMotorIds : manuallyExpandedComplaintMotorIds // ignore: cast_nullable_to_non_nullable
as Set<String>,droppedPartsCountByMotor: null == droppedPartsCountByMotor ? _self._droppedPartsCountByMotor : droppedPartsCountByMotor // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}


}

// dart format on
