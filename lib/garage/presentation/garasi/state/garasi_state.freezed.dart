// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'garasi_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GarasiState {

 bool get isLoading; bool get hasError; List<Motor> get motors; Map<String, UnitStatus> get motorInServiceStatus; Map<String, MotorModel> get modelsById;
/// Create a copy of GarasiState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GarasiStateCopyWith<GarasiState> get copyWith => _$GarasiStateCopyWithImpl<GarasiState>(this as GarasiState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GarasiState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&const DeepCollectionEquality().equals(other.motors, motors)&&const DeepCollectionEquality().equals(other.motorInServiceStatus, motorInServiceStatus)&&const DeepCollectionEquality().equals(other.modelsById, modelsById));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,const DeepCollectionEquality().hash(motors),const DeepCollectionEquality().hash(motorInServiceStatus),const DeepCollectionEquality().hash(modelsById));

@override
String toString() {
  return 'GarasiState(isLoading: $isLoading, hasError: $hasError, motors: $motors, motorInServiceStatus: $motorInServiceStatus, modelsById: $modelsById)';
}


}

/// @nodoc
abstract mixin class $GarasiStateCopyWith<$Res>  {
  factory $GarasiStateCopyWith(GarasiState value, $Res Function(GarasiState) _then) = _$GarasiStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool hasError, List<Motor> motors, Map<String, UnitStatus> motorInServiceStatus, Map<String, MotorModel> modelsById
});




}
/// @nodoc
class _$GarasiStateCopyWithImpl<$Res>
    implements $GarasiStateCopyWith<$Res> {
  _$GarasiStateCopyWithImpl(this._self, this._then);

  final GarasiState _self;
  final $Res Function(GarasiState) _then;

/// Create a copy of GarasiState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? hasError = null,Object? motors = null,Object? motorInServiceStatus = null,Object? modelsById = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,motors: null == motors ? _self.motors : motors // ignore: cast_nullable_to_non_nullable
as List<Motor>,motorInServiceStatus: null == motorInServiceStatus ? _self.motorInServiceStatus : motorInServiceStatus // ignore: cast_nullable_to_non_nullable
as Map<String, UnitStatus>,modelsById: null == modelsById ? _self.modelsById : modelsById // ignore: cast_nullable_to_non_nullable
as Map<String, MotorModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [GarasiState].
extension GarasiStatePatterns on GarasiState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GarasiState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GarasiState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GarasiState value)  $default,){
final _that = this;
switch (_that) {
case _GarasiState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GarasiState value)?  $default,){
final _that = this;
switch (_that) {
case _GarasiState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  List<Motor> motors,  Map<String, UnitStatus> motorInServiceStatus,  Map<String, MotorModel> modelsById)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GarasiState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.motors,_that.motorInServiceStatus,_that.modelsById);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  List<Motor> motors,  Map<String, UnitStatus> motorInServiceStatus,  Map<String, MotorModel> modelsById)  $default,) {final _that = this;
switch (_that) {
case _GarasiState():
return $default(_that.isLoading,_that.hasError,_that.motors,_that.motorInServiceStatus,_that.modelsById);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool hasError,  List<Motor> motors,  Map<String, UnitStatus> motorInServiceStatus,  Map<String, MotorModel> modelsById)?  $default,) {final _that = this;
switch (_that) {
case _GarasiState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.motors,_that.motorInServiceStatus,_that.modelsById);case _:
  return null;

}
}

}

/// @nodoc


class _GarasiState extends GarasiState {
  const _GarasiState({this.isLoading = true, this.hasError = false, final  List<Motor> motors = const <Motor>[], final  Map<String, UnitStatus> motorInServiceStatus = const <String, UnitStatus>{}, final  Map<String, MotorModel> modelsById = const <String, MotorModel>{}}): _motors = motors,_motorInServiceStatus = motorInServiceStatus,_modelsById = modelsById,super._();
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool hasError;
 final  List<Motor> _motors;
@override@JsonKey() List<Motor> get motors {
  if (_motors is EqualUnmodifiableListView) return _motors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_motors);
}

 final  Map<String, UnitStatus> _motorInServiceStatus;
@override@JsonKey() Map<String, UnitStatus> get motorInServiceStatus {
  if (_motorInServiceStatus is EqualUnmodifiableMapView) return _motorInServiceStatus;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_motorInServiceStatus);
}

 final  Map<String, MotorModel> _modelsById;
@override@JsonKey() Map<String, MotorModel> get modelsById {
  if (_modelsById is EqualUnmodifiableMapView) return _modelsById;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_modelsById);
}


/// Create a copy of GarasiState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GarasiStateCopyWith<_GarasiState> get copyWith => __$GarasiStateCopyWithImpl<_GarasiState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GarasiState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&const DeepCollectionEquality().equals(other._motors, _motors)&&const DeepCollectionEquality().equals(other._motorInServiceStatus, _motorInServiceStatus)&&const DeepCollectionEquality().equals(other._modelsById, _modelsById));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,const DeepCollectionEquality().hash(_motors),const DeepCollectionEquality().hash(_motorInServiceStatus),const DeepCollectionEquality().hash(_modelsById));

@override
String toString() {
  return 'GarasiState(isLoading: $isLoading, hasError: $hasError, motors: $motors, motorInServiceStatus: $motorInServiceStatus, modelsById: $modelsById)';
}


}

/// @nodoc
abstract mixin class _$GarasiStateCopyWith<$Res> implements $GarasiStateCopyWith<$Res> {
  factory _$GarasiStateCopyWith(_GarasiState value, $Res Function(_GarasiState) _then) = __$GarasiStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool hasError, List<Motor> motors, Map<String, UnitStatus> motorInServiceStatus, Map<String, MotorModel> modelsById
});




}
/// @nodoc
class __$GarasiStateCopyWithImpl<$Res>
    implements _$GarasiStateCopyWith<$Res> {
  __$GarasiStateCopyWithImpl(this._self, this._then);

  final _GarasiState _self;
  final $Res Function(_GarasiState) _then;

/// Create a copy of GarasiState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? hasError = null,Object? motors = null,Object? motorInServiceStatus = null,Object? modelsById = null,}) {
  return _then(_GarasiState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,motors: null == motors ? _self._motors : motors // ignore: cast_nullable_to_non_nullable
as List<Motor>,motorInServiceStatus: null == motorInServiceStatus ? _self._motorInServiceStatus : motorInServiceStatus // ignore: cast_nullable_to_non_nullable
as Map<String, UnitStatus>,modelsById: null == modelsById ? _self._modelsById : modelsById // ignore: cast_nullable_to_non_nullable
as Map<String, MotorModel>,
  ));
}


}

// dart format on
