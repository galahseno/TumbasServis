// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'otp_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OtpState {

 String get phoneDigits; String get code; bool get isError; bool get isLoading; int get secondsRemaining;
/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtpStateCopyWith<OtpState> get copyWith => _$OtpStateCopyWithImpl<OtpState>(this as OtpState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpState&&(identical(other.phoneDigits, phoneDigits) || other.phoneDigits == phoneDigits)&&(identical(other.code, code) || other.code == code)&&(identical(other.isError, isError) || other.isError == isError)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.secondsRemaining, secondsRemaining) || other.secondsRemaining == secondsRemaining));
}


@override
int get hashCode => Object.hash(runtimeType,phoneDigits,code,isError,isLoading,secondsRemaining);

@override
String toString() {
  return 'OtpState(phoneDigits: $phoneDigits, code: $code, isError: $isError, isLoading: $isLoading, secondsRemaining: $secondsRemaining)';
}


}

/// @nodoc
abstract mixin class $OtpStateCopyWith<$Res>  {
  factory $OtpStateCopyWith(OtpState value, $Res Function(OtpState) _then) = _$OtpStateCopyWithImpl;
@useResult
$Res call({
 String phoneDigits, String code, bool isError, bool isLoading, int secondsRemaining
});




}
/// @nodoc
class _$OtpStateCopyWithImpl<$Res>
    implements $OtpStateCopyWith<$Res> {
  _$OtpStateCopyWithImpl(this._self, this._then);

  final OtpState _self;
  final $Res Function(OtpState) _then;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phoneDigits = null,Object? code = null,Object? isError = null,Object? isLoading = null,Object? secondsRemaining = null,}) {
  return _then(_self.copyWith(
phoneDigits: null == phoneDigits ? _self.phoneDigits : phoneDigits // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,secondsRemaining: null == secondsRemaining ? _self.secondsRemaining : secondsRemaining // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OtpState].
extension OtpStatePatterns on OtpState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OtpState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OtpState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OtpState value)  $default,){
final _that = this;
switch (_that) {
case _OtpState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OtpState value)?  $default,){
final _that = this;
switch (_that) {
case _OtpState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String phoneDigits,  String code,  bool isError,  bool isLoading,  int secondsRemaining)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OtpState() when $default != null:
return $default(_that.phoneDigits,_that.code,_that.isError,_that.isLoading,_that.secondsRemaining);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String phoneDigits,  String code,  bool isError,  bool isLoading,  int secondsRemaining)  $default,) {final _that = this;
switch (_that) {
case _OtpState():
return $default(_that.phoneDigits,_that.code,_that.isError,_that.isLoading,_that.secondsRemaining);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String phoneDigits,  String code,  bool isError,  bool isLoading,  int secondsRemaining)?  $default,) {final _that = this;
switch (_that) {
case _OtpState() when $default != null:
return $default(_that.phoneDigits,_that.code,_that.isError,_that.isLoading,_that.secondsRemaining);case _:
  return null;

}
}

}

/// @nodoc


class _OtpState implements OtpState {
  const _OtpState({this.phoneDigits = '', this.code = '', this.isError = false, this.isLoading = false, this.secondsRemaining = 30});
  

@override@JsonKey() final  String phoneDigits;
@override@JsonKey() final  String code;
@override@JsonKey() final  bool isError;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  int secondsRemaining;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OtpStateCopyWith<_OtpState> get copyWith => __$OtpStateCopyWithImpl<_OtpState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OtpState&&(identical(other.phoneDigits, phoneDigits) || other.phoneDigits == phoneDigits)&&(identical(other.code, code) || other.code == code)&&(identical(other.isError, isError) || other.isError == isError)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.secondsRemaining, secondsRemaining) || other.secondsRemaining == secondsRemaining));
}


@override
int get hashCode => Object.hash(runtimeType,phoneDigits,code,isError,isLoading,secondsRemaining);

@override
String toString() {
  return 'OtpState(phoneDigits: $phoneDigits, code: $code, isError: $isError, isLoading: $isLoading, secondsRemaining: $secondsRemaining)';
}


}

/// @nodoc
abstract mixin class _$OtpStateCopyWith<$Res> implements $OtpStateCopyWith<$Res> {
  factory _$OtpStateCopyWith(_OtpState value, $Res Function(_OtpState) _then) = __$OtpStateCopyWithImpl;
@override @useResult
$Res call({
 String phoneDigits, String code, bool isError, bool isLoading, int secondsRemaining
});




}
/// @nodoc
class __$OtpStateCopyWithImpl<$Res>
    implements _$OtpStateCopyWith<$Res> {
  __$OtpStateCopyWithImpl(this._self, this._then);

  final _OtpState _self;
  final $Res Function(_OtpState) _then;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phoneDigits = null,Object? code = null,Object? isError = null,Object? isLoading = null,Object? secondsRemaining = null,}) {
  return _then(_OtpState(
phoneDigits: null == phoneDigits ? _self.phoneDigits : phoneDigits // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,secondsRemaining: null == secondsRemaining ? _self.secondsRemaining : secondsRemaining // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
