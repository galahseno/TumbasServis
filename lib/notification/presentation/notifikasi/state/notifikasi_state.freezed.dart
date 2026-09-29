// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notifikasi_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotifikasiState {

 bool get isLoading; bool get hasError; List<AppNotification> get notifications; bool get isMarkingAll; DateTime? get now;
/// Create a copy of NotifikasiState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotifikasiStateCopyWith<NotifikasiState> get copyWith => _$NotifikasiStateCopyWithImpl<NotifikasiState>(this as NotifikasiState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotifikasiState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&const DeepCollectionEquality().equals(other.notifications, notifications)&&(identical(other.isMarkingAll, isMarkingAll) || other.isMarkingAll == isMarkingAll)&&(identical(other.now, now) || other.now == now));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,const DeepCollectionEquality().hash(notifications),isMarkingAll,now);

@override
String toString() {
  return 'NotifikasiState(isLoading: $isLoading, hasError: $hasError, notifications: $notifications, isMarkingAll: $isMarkingAll, now: $now)';
}


}

/// @nodoc
abstract mixin class $NotifikasiStateCopyWith<$Res>  {
  factory $NotifikasiStateCopyWith(NotifikasiState value, $Res Function(NotifikasiState) _then) = _$NotifikasiStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool hasError, List<AppNotification> notifications, bool isMarkingAll, DateTime? now
});




}
/// @nodoc
class _$NotifikasiStateCopyWithImpl<$Res>
    implements $NotifikasiStateCopyWith<$Res> {
  _$NotifikasiStateCopyWithImpl(this._self, this._then);

  final NotifikasiState _self;
  final $Res Function(NotifikasiState) _then;

/// Create a copy of NotifikasiState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? hasError = null,Object? notifications = null,Object? isMarkingAll = null,Object? now = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,notifications: null == notifications ? _self.notifications : notifications // ignore: cast_nullable_to_non_nullable
as List<AppNotification>,isMarkingAll: null == isMarkingAll ? _self.isMarkingAll : isMarkingAll // ignore: cast_nullable_to_non_nullable
as bool,now: freezed == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotifikasiState].
extension NotifikasiStatePatterns on NotifikasiState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotifikasiState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotifikasiState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotifikasiState value)  $default,){
final _that = this;
switch (_that) {
case _NotifikasiState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotifikasiState value)?  $default,){
final _that = this;
switch (_that) {
case _NotifikasiState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  List<AppNotification> notifications,  bool isMarkingAll,  DateTime? now)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotifikasiState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.notifications,_that.isMarkingAll,_that.now);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  List<AppNotification> notifications,  bool isMarkingAll,  DateTime? now)  $default,) {final _that = this;
switch (_that) {
case _NotifikasiState():
return $default(_that.isLoading,_that.hasError,_that.notifications,_that.isMarkingAll,_that.now);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool hasError,  List<AppNotification> notifications,  bool isMarkingAll,  DateTime? now)?  $default,) {final _that = this;
switch (_that) {
case _NotifikasiState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.notifications,_that.isMarkingAll,_that.now);case _:
  return null;

}
}

}

/// @nodoc


class _NotifikasiState extends NotifikasiState {
  const _NotifikasiState({this.isLoading = true, this.hasError = false, final  List<AppNotification> notifications = const [], this.isMarkingAll = false, this.now}): _notifications = notifications,super._();
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool hasError;
 final  List<AppNotification> _notifications;
@override@JsonKey() List<AppNotification> get notifications {
  if (_notifications is EqualUnmodifiableListView) return _notifications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notifications);
}

@override@JsonKey() final  bool isMarkingAll;
@override final  DateTime? now;

/// Create a copy of NotifikasiState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotifikasiStateCopyWith<_NotifikasiState> get copyWith => __$NotifikasiStateCopyWithImpl<_NotifikasiState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotifikasiState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&const DeepCollectionEquality().equals(other._notifications, _notifications)&&(identical(other.isMarkingAll, isMarkingAll) || other.isMarkingAll == isMarkingAll)&&(identical(other.now, now) || other.now == now));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,const DeepCollectionEquality().hash(_notifications),isMarkingAll,now);

@override
String toString() {
  return 'NotifikasiState(isLoading: $isLoading, hasError: $hasError, notifications: $notifications, isMarkingAll: $isMarkingAll, now: $now)';
}


}

/// @nodoc
abstract mixin class _$NotifikasiStateCopyWith<$Res> implements $NotifikasiStateCopyWith<$Res> {
  factory _$NotifikasiStateCopyWith(_NotifikasiState value, $Res Function(_NotifikasiState) _then) = __$NotifikasiStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool hasError, List<AppNotification> notifications, bool isMarkingAll, DateTime? now
});




}
/// @nodoc
class __$NotifikasiStateCopyWithImpl<$Res>
    implements _$NotifikasiStateCopyWith<$Res> {
  __$NotifikasiStateCopyWithImpl(this._self, this._then);

  final _NotifikasiState _self;
  final $Res Function(_NotifikasiState) _then;

/// Create a copy of NotifikasiState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? hasError = null,Object? notifications = null,Object? isMarkingAll = null,Object? now = freezed,}) {
  return _then(_NotifikasiState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,notifications: null == notifications ? _self._notifications : notifications // ignore: cast_nullable_to_non_nullable
as List<AppNotification>,isMarkingAll: null == isMarkingAll ? _self.isMarkingAll : isMarkingAll // ignore: cast_nullable_to_non_nullable
as bool,now: freezed == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
