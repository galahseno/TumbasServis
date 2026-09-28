// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pilih_motor_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PilihMotorState {

 bool get isLoading; bool get hasError; List<Motor> get motors;
/// Create a copy of PilihMotorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PilihMotorStateCopyWith<PilihMotorState> get copyWith => _$PilihMotorStateCopyWithImpl<PilihMotorState>(this as PilihMotorState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PilihMotorState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&const DeepCollectionEquality().equals(other.motors, motors));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,const DeepCollectionEquality().hash(motors));

@override
String toString() {
  return 'PilihMotorState(isLoading: $isLoading, hasError: $hasError, motors: $motors)';
}


}

/// @nodoc
abstract mixin class $PilihMotorStateCopyWith<$Res>  {
  factory $PilihMotorStateCopyWith(PilihMotorState value, $Res Function(PilihMotorState) _then) = _$PilihMotorStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool hasError, List<Motor> motors
});




}
/// @nodoc
class _$PilihMotorStateCopyWithImpl<$Res>
    implements $PilihMotorStateCopyWith<$Res> {
  _$PilihMotorStateCopyWithImpl(this._self, this._then);

  final PilihMotorState _self;
  final $Res Function(PilihMotorState) _then;

/// Create a copy of PilihMotorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? hasError = null,Object? motors = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,motors: null == motors ? _self.motors : motors // ignore: cast_nullable_to_non_nullable
as List<Motor>,
  ));
}

}


/// Adds pattern-matching-related methods to [PilihMotorState].
extension PilihMotorStatePatterns on PilihMotorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PilihMotorState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PilihMotorState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PilihMotorState value)  $default,){
final _that = this;
switch (_that) {
case _PilihMotorState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PilihMotorState value)?  $default,){
final _that = this;
switch (_that) {
case _PilihMotorState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  List<Motor> motors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PilihMotorState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.motors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  List<Motor> motors)  $default,) {final _that = this;
switch (_that) {
case _PilihMotorState():
return $default(_that.isLoading,_that.hasError,_that.motors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool hasError,  List<Motor> motors)?  $default,) {final _that = this;
switch (_that) {
case _PilihMotorState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.motors);case _:
  return null;

}
}

}

/// @nodoc


class _PilihMotorState extends PilihMotorState {
  const _PilihMotorState({this.isLoading = true, this.hasError = false, final  List<Motor> motors = const <Motor>[]}): _motors = motors,super._();
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool hasError;
 final  List<Motor> _motors;
@override@JsonKey() List<Motor> get motors {
  if (_motors is EqualUnmodifiableListView) return _motors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_motors);
}


/// Create a copy of PilihMotorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PilihMotorStateCopyWith<_PilihMotorState> get copyWith => __$PilihMotorStateCopyWithImpl<_PilihMotorState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PilihMotorState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&const DeepCollectionEquality().equals(other._motors, _motors));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,const DeepCollectionEquality().hash(_motors));

@override
String toString() {
  return 'PilihMotorState(isLoading: $isLoading, hasError: $hasError, motors: $motors)';
}


}

/// @nodoc
abstract mixin class _$PilihMotorStateCopyWith<$Res> implements $PilihMotorStateCopyWith<$Res> {
  factory _$PilihMotorStateCopyWith(_PilihMotorState value, $Res Function(_PilihMotorState) _then) = __$PilihMotorStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool hasError, List<Motor> motors
});




}
/// @nodoc
class __$PilihMotorStateCopyWithImpl<$Res>
    implements _$PilihMotorStateCopyWith<$Res> {
  __$PilihMotorStateCopyWithImpl(this._self, this._then);

  final _PilihMotorState _self;
  final $Res Function(_PilihMotorState) _then;

/// Create a copy of PilihMotorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? hasError = null,Object? motors = null,}) {
  return _then(_PilihMotorState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,motors: null == motors ? _self._motors : motors // ignore: cast_nullable_to_non_nullable
as List<Motor>,
  ));
}


}

// dart format on
