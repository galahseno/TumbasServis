// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profil_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfilState {

 bool get isLoading; String get userName; String get maskedPhone; bool get notificationsEnabled; bool get isLoggingOut;
/// Create a copy of ProfilState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfilStateCopyWith<ProfilState> get copyWith => _$ProfilStateCopyWithImpl<ProfilState>(this as ProfilState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfilState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.maskedPhone, maskedPhone) || other.maskedPhone == maskedPhone)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.isLoggingOut, isLoggingOut) || other.isLoggingOut == isLoggingOut));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,userName,maskedPhone,notificationsEnabled,isLoggingOut);

@override
String toString() {
  return 'ProfilState(isLoading: $isLoading, userName: $userName, maskedPhone: $maskedPhone, notificationsEnabled: $notificationsEnabled, isLoggingOut: $isLoggingOut)';
}


}

/// @nodoc
abstract mixin class $ProfilStateCopyWith<$Res>  {
  factory $ProfilStateCopyWith(ProfilState value, $Res Function(ProfilState) _then) = _$ProfilStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, String userName, String maskedPhone, bool notificationsEnabled, bool isLoggingOut
});




}
/// @nodoc
class _$ProfilStateCopyWithImpl<$Res>
    implements $ProfilStateCopyWith<$Res> {
  _$ProfilStateCopyWithImpl(this._self, this._then);

  final ProfilState _self;
  final $Res Function(ProfilState) _then;

/// Create a copy of ProfilState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? userName = null,Object? maskedPhone = null,Object? notificationsEnabled = null,Object? isLoggingOut = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,maskedPhone: null == maskedPhone ? _self.maskedPhone : maskedPhone // ignore: cast_nullable_to_non_nullable
as String,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,isLoggingOut: null == isLoggingOut ? _self.isLoggingOut : isLoggingOut // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfilState].
extension ProfilStatePatterns on ProfilState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfilState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfilState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfilState value)  $default,){
final _that = this;
switch (_that) {
case _ProfilState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfilState value)?  $default,){
final _that = this;
switch (_that) {
case _ProfilState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  String userName,  String maskedPhone,  bool notificationsEnabled,  bool isLoggingOut)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfilState() when $default != null:
return $default(_that.isLoading,_that.userName,_that.maskedPhone,_that.notificationsEnabled,_that.isLoggingOut);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  String userName,  String maskedPhone,  bool notificationsEnabled,  bool isLoggingOut)  $default,) {final _that = this;
switch (_that) {
case _ProfilState():
return $default(_that.isLoading,_that.userName,_that.maskedPhone,_that.notificationsEnabled,_that.isLoggingOut);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  String userName,  String maskedPhone,  bool notificationsEnabled,  bool isLoggingOut)?  $default,) {final _that = this;
switch (_that) {
case _ProfilState() when $default != null:
return $default(_that.isLoading,_that.userName,_that.maskedPhone,_that.notificationsEnabled,_that.isLoggingOut);case _:
  return null;

}
}

}

/// @nodoc


class _ProfilState extends ProfilState {
  const _ProfilState({this.isLoading = true, this.userName = '', this.maskedPhone = '', this.notificationsEnabled = true, this.isLoggingOut = false}): super._();
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  String userName;
@override@JsonKey() final  String maskedPhone;
@override@JsonKey() final  bool notificationsEnabled;
@override@JsonKey() final  bool isLoggingOut;

/// Create a copy of ProfilState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfilStateCopyWith<_ProfilState> get copyWith => __$ProfilStateCopyWithImpl<_ProfilState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfilState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.maskedPhone, maskedPhone) || other.maskedPhone == maskedPhone)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.isLoggingOut, isLoggingOut) || other.isLoggingOut == isLoggingOut));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,userName,maskedPhone,notificationsEnabled,isLoggingOut);

@override
String toString() {
  return 'ProfilState(isLoading: $isLoading, userName: $userName, maskedPhone: $maskedPhone, notificationsEnabled: $notificationsEnabled, isLoggingOut: $isLoggingOut)';
}


}

/// @nodoc
abstract mixin class _$ProfilStateCopyWith<$Res> implements $ProfilStateCopyWith<$Res> {
  factory _$ProfilStateCopyWith(_ProfilState value, $Res Function(_ProfilState) _then) = __$ProfilStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String userName, String maskedPhone, bool notificationsEnabled, bool isLoggingOut
});




}
/// @nodoc
class __$ProfilStateCopyWithImpl<$Res>
    implements _$ProfilStateCopyWith<$Res> {
  __$ProfilStateCopyWithImpl(this._self, this._then);

  final _ProfilState _self;
  final $Res Function(_ProfilState) _then;

/// Create a copy of ProfilState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? userName = null,Object? maskedPhone = null,Object? notificationsEnabled = null,Object? isLoggingOut = null,}) {
  return _then(_ProfilState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,maskedPhone: null == maskedPhone ? _self.maskedPhone : maskedPhone // ignore: cast_nullable_to_non_nullable
as String,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,isLoggingOut: null == isLoggingOut ? _self.isLoggingOut : isLoggingOut // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
