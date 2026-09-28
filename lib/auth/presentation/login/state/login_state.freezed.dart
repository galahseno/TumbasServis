// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginState {

 String get phoneDigits; String? get errorText; bool get isLoading; String? get snackbarMessage;
/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginStateCopyWith<LoginState> get copyWith => _$LoginStateCopyWithImpl<LoginState>(this as LoginState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginState&&(identical(other.phoneDigits, phoneDigits) || other.phoneDigits == phoneDigits)&&(identical(other.errorText, errorText) || other.errorText == errorText)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.snackbarMessage, snackbarMessage) || other.snackbarMessage == snackbarMessage));
}


@override
int get hashCode => Object.hash(runtimeType,phoneDigits,errorText,isLoading,snackbarMessage);

@override
String toString() {
  return 'LoginState(phoneDigits: $phoneDigits, errorText: $errorText, isLoading: $isLoading, snackbarMessage: $snackbarMessage)';
}


}

/// @nodoc
abstract mixin class $LoginStateCopyWith<$Res>  {
  factory $LoginStateCopyWith(LoginState value, $Res Function(LoginState) _then) = _$LoginStateCopyWithImpl;
@useResult
$Res call({
 String phoneDigits, String? errorText, bool isLoading, String? snackbarMessage
});




}
/// @nodoc
class _$LoginStateCopyWithImpl<$Res>
    implements $LoginStateCopyWith<$Res> {
  _$LoginStateCopyWithImpl(this._self, this._then);

  final LoginState _self;
  final $Res Function(LoginState) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phoneDigits = null,Object? errorText = freezed,Object? isLoading = null,Object? snackbarMessage = freezed,}) {
  return _then(_self.copyWith(
phoneDigits: null == phoneDigits ? _self.phoneDigits : phoneDigits // ignore: cast_nullable_to_non_nullable
as String,errorText: freezed == errorText ? _self.errorText : errorText // ignore: cast_nullable_to_non_nullable
as String?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,snackbarMessage: freezed == snackbarMessage ? _self.snackbarMessage : snackbarMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoginState].
extension LoginStatePatterns on LoginState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginState value)  $default,){
final _that = this;
switch (_that) {
case _LoginState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginState value)?  $default,){
final _that = this;
switch (_that) {
case _LoginState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String phoneDigits,  String? errorText,  bool isLoading,  String? snackbarMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that.phoneDigits,_that.errorText,_that.isLoading,_that.snackbarMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String phoneDigits,  String? errorText,  bool isLoading,  String? snackbarMessage)  $default,) {final _that = this;
switch (_that) {
case _LoginState():
return $default(_that.phoneDigits,_that.errorText,_that.isLoading,_that.snackbarMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String phoneDigits,  String? errorText,  bool isLoading,  String? snackbarMessage)?  $default,) {final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that.phoneDigits,_that.errorText,_that.isLoading,_that.snackbarMessage);case _:
  return null;

}
}

}

/// @nodoc


class _LoginState implements LoginState {
  const _LoginState({this.phoneDigits = '', this.errorText, this.isLoading = false, this.snackbarMessage});
  

@override@JsonKey() final  String phoneDigits;
@override final  String? errorText;
@override@JsonKey() final  bool isLoading;
@override final  String? snackbarMessage;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginStateCopyWith<_LoginState> get copyWith => __$LoginStateCopyWithImpl<_LoginState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginState&&(identical(other.phoneDigits, phoneDigits) || other.phoneDigits == phoneDigits)&&(identical(other.errorText, errorText) || other.errorText == errorText)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.snackbarMessage, snackbarMessage) || other.snackbarMessage == snackbarMessage));
}


@override
int get hashCode => Object.hash(runtimeType,phoneDigits,errorText,isLoading,snackbarMessage);

@override
String toString() {
  return 'LoginState(phoneDigits: $phoneDigits, errorText: $errorText, isLoading: $isLoading, snackbarMessage: $snackbarMessage)';
}


}

/// @nodoc
abstract mixin class _$LoginStateCopyWith<$Res> implements $LoginStateCopyWith<$Res> {
  factory _$LoginStateCopyWith(_LoginState value, $Res Function(_LoginState) _then) = __$LoginStateCopyWithImpl;
@override @useResult
$Res call({
 String phoneDigits, String? errorText, bool isLoading, String? snackbarMessage
});




}
/// @nodoc
class __$LoginStateCopyWithImpl<$Res>
    implements _$LoginStateCopyWith<$Res> {
  __$LoginStateCopyWithImpl(this._self, this._then);

  final _LoginState _self;
  final $Res Function(_LoginState) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phoneDigits = null,Object? errorText = freezed,Object? isLoading = null,Object? snackbarMessage = freezed,}) {
  return _then(_LoginState(
phoneDigits: null == phoneDigits ? _self.phoneDigits : phoneDigits // ignore: cast_nullable_to_non_nullable
as String,errorText: freezed == errorText ? _self.errorText : errorText // ignore: cast_nullable_to_non_nullable
as String?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,snackbarMessage: freezed == snackbarMessage ? _self.snackbarMessage : snackbarMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
