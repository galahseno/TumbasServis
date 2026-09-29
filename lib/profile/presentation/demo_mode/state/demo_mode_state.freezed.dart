// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'demo_mode_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DemoModeState {

 bool get isLoading; bool get hasError; String? get bookingId; String get bookingCode; List<BookingUnit> get units; TrackingSpeed get speed; bool get errorArmed;/// A tracking or reset action is in flight; all controls wait for it.
 bool get isBusy; bool get isResetting;
/// Create a copy of DemoModeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DemoModeStateCopyWith<DemoModeState> get copyWith => _$DemoModeStateCopyWithImpl<DemoModeState>(this as DemoModeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DemoModeState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.bookingCode, bookingCode) || other.bookingCode == bookingCode)&&const DeepCollectionEquality().equals(other.units, units)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.errorArmed, errorArmed) || other.errorArmed == errorArmed)&&(identical(other.isBusy, isBusy) || other.isBusy == isBusy)&&(identical(other.isResetting, isResetting) || other.isResetting == isResetting));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,bookingId,bookingCode,const DeepCollectionEquality().hash(units),speed,errorArmed,isBusy,isResetting);

@override
String toString() {
  return 'DemoModeState(isLoading: $isLoading, hasError: $hasError, bookingId: $bookingId, bookingCode: $bookingCode, units: $units, speed: $speed, errorArmed: $errorArmed, isBusy: $isBusy, isResetting: $isResetting)';
}


}

/// @nodoc
abstract mixin class $DemoModeStateCopyWith<$Res>  {
  factory $DemoModeStateCopyWith(DemoModeState value, $Res Function(DemoModeState) _then) = _$DemoModeStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool hasError, String? bookingId, String bookingCode, List<BookingUnit> units, TrackingSpeed speed, bool errorArmed, bool isBusy, bool isResetting
});




}
/// @nodoc
class _$DemoModeStateCopyWithImpl<$Res>
    implements $DemoModeStateCopyWith<$Res> {
  _$DemoModeStateCopyWithImpl(this._self, this._then);

  final DemoModeState _self;
  final $Res Function(DemoModeState) _then;

/// Create a copy of DemoModeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? hasError = null,Object? bookingId = freezed,Object? bookingCode = null,Object? units = null,Object? speed = null,Object? errorArmed = null,Object? isBusy = null,Object? isResetting = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,bookingId: freezed == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String?,bookingCode: null == bookingCode ? _self.bookingCode : bookingCode // ignore: cast_nullable_to_non_nullable
as String,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as List<BookingUnit>,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as TrackingSpeed,errorArmed: null == errorArmed ? _self.errorArmed : errorArmed // ignore: cast_nullable_to_non_nullable
as bool,isBusy: null == isBusy ? _self.isBusy : isBusy // ignore: cast_nullable_to_non_nullable
as bool,isResetting: null == isResetting ? _self.isResetting : isResetting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DemoModeState].
extension DemoModeStatePatterns on DemoModeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DemoModeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DemoModeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DemoModeState value)  $default,){
final _that = this;
switch (_that) {
case _DemoModeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DemoModeState value)?  $default,){
final _that = this;
switch (_that) {
case _DemoModeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  String? bookingId,  String bookingCode,  List<BookingUnit> units,  TrackingSpeed speed,  bool errorArmed,  bool isBusy,  bool isResetting)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DemoModeState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.bookingId,_that.bookingCode,_that.units,_that.speed,_that.errorArmed,_that.isBusy,_that.isResetting);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  String? bookingId,  String bookingCode,  List<BookingUnit> units,  TrackingSpeed speed,  bool errorArmed,  bool isBusy,  bool isResetting)  $default,) {final _that = this;
switch (_that) {
case _DemoModeState():
return $default(_that.isLoading,_that.hasError,_that.bookingId,_that.bookingCode,_that.units,_that.speed,_that.errorArmed,_that.isBusy,_that.isResetting);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool hasError,  String? bookingId,  String bookingCode,  List<BookingUnit> units,  TrackingSpeed speed,  bool errorArmed,  bool isBusy,  bool isResetting)?  $default,) {final _that = this;
switch (_that) {
case _DemoModeState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.bookingId,_that.bookingCode,_that.units,_that.speed,_that.errorArmed,_that.isBusy,_that.isResetting);case _:
  return null;

}
}

}

/// @nodoc


class _DemoModeState extends DemoModeState {
  const _DemoModeState({this.isLoading = true, this.hasError = false, this.bookingId, this.bookingCode = '', final  List<BookingUnit> units = const [], this.speed = TrackingSpeed.detik15, this.errorArmed = false, this.isBusy = false, this.isResetting = false}): _units = units,super._();
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool hasError;
@override final  String? bookingId;
@override@JsonKey() final  String bookingCode;
 final  List<BookingUnit> _units;
@override@JsonKey() List<BookingUnit> get units {
  if (_units is EqualUnmodifiableListView) return _units;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_units);
}

@override@JsonKey() final  TrackingSpeed speed;
@override@JsonKey() final  bool errorArmed;
/// A tracking or reset action is in flight; all controls wait for it.
@override@JsonKey() final  bool isBusy;
@override@JsonKey() final  bool isResetting;

/// Create a copy of DemoModeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DemoModeStateCopyWith<_DemoModeState> get copyWith => __$DemoModeStateCopyWithImpl<_DemoModeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DemoModeState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.bookingCode, bookingCode) || other.bookingCode == bookingCode)&&const DeepCollectionEquality().equals(other._units, _units)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.errorArmed, errorArmed) || other.errorArmed == errorArmed)&&(identical(other.isBusy, isBusy) || other.isBusy == isBusy)&&(identical(other.isResetting, isResetting) || other.isResetting == isResetting));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,bookingId,bookingCode,const DeepCollectionEquality().hash(_units),speed,errorArmed,isBusy,isResetting);

@override
String toString() {
  return 'DemoModeState(isLoading: $isLoading, hasError: $hasError, bookingId: $bookingId, bookingCode: $bookingCode, units: $units, speed: $speed, errorArmed: $errorArmed, isBusy: $isBusy, isResetting: $isResetting)';
}


}

/// @nodoc
abstract mixin class _$DemoModeStateCopyWith<$Res> implements $DemoModeStateCopyWith<$Res> {
  factory _$DemoModeStateCopyWith(_DemoModeState value, $Res Function(_DemoModeState) _then) = __$DemoModeStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool hasError, String? bookingId, String bookingCode, List<BookingUnit> units, TrackingSpeed speed, bool errorArmed, bool isBusy, bool isResetting
});




}
/// @nodoc
class __$DemoModeStateCopyWithImpl<$Res>
    implements _$DemoModeStateCopyWith<$Res> {
  __$DemoModeStateCopyWithImpl(this._self, this._then);

  final _DemoModeState _self;
  final $Res Function(_DemoModeState) _then;

/// Create a copy of DemoModeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? hasError = null,Object? bookingId = freezed,Object? bookingCode = null,Object? units = null,Object? speed = null,Object? errorArmed = null,Object? isBusy = null,Object? isResetting = null,}) {
  return _then(_DemoModeState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,bookingId: freezed == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String?,bookingCode: null == bookingCode ? _self.bookingCode : bookingCode // ignore: cast_nullable_to_non_nullable
as String,units: null == units ? _self._units : units // ignore: cast_nullable_to_non_nullable
as List<BookingUnit>,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as TrackingSpeed,errorArmed: null == errorArmed ? _self.errorArmed : errorArmed // ignore: cast_nullable_to_non_nullable
as bool,isBusy: null == isBusy ? _self.isBusy : isBusy // ignore: cast_nullable_to_non_nullable
as bool,isResetting: null == isResetting ? _self.isResetting : isResetting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
