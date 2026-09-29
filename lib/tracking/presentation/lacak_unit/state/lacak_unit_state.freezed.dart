// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lacak_unit_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LacakUnitState {

 bool get isLoading; bool get hasError; Booking? get booking; BookingUnit? get unit; Mechanic? get mechanic; String get servicesSummary; bool get isDemoBusy;
/// Create a copy of LacakUnitState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LacakUnitStateCopyWith<LacakUnitState> get copyWith => _$LacakUnitStateCopyWithImpl<LacakUnitState>(this as LacakUnitState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LacakUnitState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.booking, booking) || other.booking == booking)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.mechanic, mechanic) || other.mechanic == mechanic)&&(identical(other.servicesSummary, servicesSummary) || other.servicesSummary == servicesSummary)&&(identical(other.isDemoBusy, isDemoBusy) || other.isDemoBusy == isDemoBusy));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,booking,unit,mechanic,servicesSummary,isDemoBusy);

@override
String toString() {
  return 'LacakUnitState(isLoading: $isLoading, hasError: $hasError, booking: $booking, unit: $unit, mechanic: $mechanic, servicesSummary: $servicesSummary, isDemoBusy: $isDemoBusy)';
}


}

/// @nodoc
abstract mixin class $LacakUnitStateCopyWith<$Res>  {
  factory $LacakUnitStateCopyWith(LacakUnitState value, $Res Function(LacakUnitState) _then) = _$LacakUnitStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool hasError, Booking? booking, BookingUnit? unit, Mechanic? mechanic, String servicesSummary, bool isDemoBusy
});


$BookingCopyWith<$Res>? get booking;$BookingUnitCopyWith<$Res>? get unit;

}
/// @nodoc
class _$LacakUnitStateCopyWithImpl<$Res>
    implements $LacakUnitStateCopyWith<$Res> {
  _$LacakUnitStateCopyWithImpl(this._self, this._then);

  final LacakUnitState _self;
  final $Res Function(LacakUnitState) _then;

/// Create a copy of LacakUnitState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? hasError = null,Object? booking = freezed,Object? unit = freezed,Object? mechanic = freezed,Object? servicesSummary = null,Object? isDemoBusy = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,booking: freezed == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as Booking?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as BookingUnit?,mechanic: freezed == mechanic ? _self.mechanic : mechanic // ignore: cast_nullable_to_non_nullable
as Mechanic?,servicesSummary: null == servicesSummary ? _self.servicesSummary : servicesSummary // ignore: cast_nullable_to_non_nullable
as String,isDemoBusy: null == isDemoBusy ? _self.isDemoBusy : isDemoBusy // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of LacakUnitState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingCopyWith<$Res>? get booking {
    if (_self.booking == null) {
    return null;
  }

  return $BookingCopyWith<$Res>(_self.booking!, (value) {
    return _then(_self.copyWith(booking: value));
  });
}/// Create a copy of LacakUnitState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingUnitCopyWith<$Res>? get unit {
    if (_self.unit == null) {
    return null;
  }

  return $BookingUnitCopyWith<$Res>(_self.unit!, (value) {
    return _then(_self.copyWith(unit: value));
  });
}
}


/// Adds pattern-matching-related methods to [LacakUnitState].
extension LacakUnitStatePatterns on LacakUnitState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LacakUnitState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LacakUnitState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LacakUnitState value)  $default,){
final _that = this;
switch (_that) {
case _LacakUnitState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LacakUnitState value)?  $default,){
final _that = this;
switch (_that) {
case _LacakUnitState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  Booking? booking,  BookingUnit? unit,  Mechanic? mechanic,  String servicesSummary,  bool isDemoBusy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LacakUnitState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.booking,_that.unit,_that.mechanic,_that.servicesSummary,_that.isDemoBusy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  Booking? booking,  BookingUnit? unit,  Mechanic? mechanic,  String servicesSummary,  bool isDemoBusy)  $default,) {final _that = this;
switch (_that) {
case _LacakUnitState():
return $default(_that.isLoading,_that.hasError,_that.booking,_that.unit,_that.mechanic,_that.servicesSummary,_that.isDemoBusy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool hasError,  Booking? booking,  BookingUnit? unit,  Mechanic? mechanic,  String servicesSummary,  bool isDemoBusy)?  $default,) {final _that = this;
switch (_that) {
case _LacakUnitState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.booking,_that.unit,_that.mechanic,_that.servicesSummary,_that.isDemoBusy);case _:
  return null;

}
}

}

/// @nodoc


class _LacakUnitState extends LacakUnitState {
  const _LacakUnitState({this.isLoading = true, this.hasError = false, this.booking, this.unit, this.mechanic, this.servicesSummary = '', this.isDemoBusy = false}): super._();
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool hasError;
@override final  Booking? booking;
@override final  BookingUnit? unit;
@override final  Mechanic? mechanic;
@override@JsonKey() final  String servicesSummary;
@override@JsonKey() final  bool isDemoBusy;

/// Create a copy of LacakUnitState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LacakUnitStateCopyWith<_LacakUnitState> get copyWith => __$LacakUnitStateCopyWithImpl<_LacakUnitState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LacakUnitState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.booking, booking) || other.booking == booking)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.mechanic, mechanic) || other.mechanic == mechanic)&&(identical(other.servicesSummary, servicesSummary) || other.servicesSummary == servicesSummary)&&(identical(other.isDemoBusy, isDemoBusy) || other.isDemoBusy == isDemoBusy));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,booking,unit,mechanic,servicesSummary,isDemoBusy);

@override
String toString() {
  return 'LacakUnitState(isLoading: $isLoading, hasError: $hasError, booking: $booking, unit: $unit, mechanic: $mechanic, servicesSummary: $servicesSummary, isDemoBusy: $isDemoBusy)';
}


}

/// @nodoc
abstract mixin class _$LacakUnitStateCopyWith<$Res> implements $LacakUnitStateCopyWith<$Res> {
  factory _$LacakUnitStateCopyWith(_LacakUnitState value, $Res Function(_LacakUnitState) _then) = __$LacakUnitStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool hasError, Booking? booking, BookingUnit? unit, Mechanic? mechanic, String servicesSummary, bool isDemoBusy
});


@override $BookingCopyWith<$Res>? get booking;@override $BookingUnitCopyWith<$Res>? get unit;

}
/// @nodoc
class __$LacakUnitStateCopyWithImpl<$Res>
    implements _$LacakUnitStateCopyWith<$Res> {
  __$LacakUnitStateCopyWithImpl(this._self, this._then);

  final _LacakUnitState _self;
  final $Res Function(_LacakUnitState) _then;

/// Create a copy of LacakUnitState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? hasError = null,Object? booking = freezed,Object? unit = freezed,Object? mechanic = freezed,Object? servicesSummary = null,Object? isDemoBusy = null,}) {
  return _then(_LacakUnitState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,booking: freezed == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as Booking?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as BookingUnit?,mechanic: freezed == mechanic ? _self.mechanic : mechanic // ignore: cast_nullable_to_non_nullable
as Mechanic?,servicesSummary: null == servicesSummary ? _self.servicesSummary : servicesSummary // ignore: cast_nullable_to_non_nullable
as String,isDemoBusy: null == isDemoBusy ? _self.isDemoBusy : isDemoBusy // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of LacakUnitState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingCopyWith<$Res>? get booking {
    if (_self.booking == null) {
    return null;
  }

  return $BookingCopyWith<$Res>(_self.booking!, (value) {
    return _then(_self.copyWith(booking: value));
  });
}/// Create a copy of LacakUnitState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingUnitCopyWith<$Res>? get unit {
    if (_self.unit == null) {
    return null;
  }

  return $BookingUnitCopyWith<$Res>(_self.unit!, (value) {
    return _then(_self.copyWith(unit: value));
  });
}
}

// dart format on
