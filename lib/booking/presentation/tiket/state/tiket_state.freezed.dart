// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tiket_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TiketState {

 bool get isLoading; bool get hasError; Booking? get booking; Workshop? get workshop; Map<String, ServiceType> get serviceById;/// Bumped on every successful copy so the page can show one snackbar per tap.
 int get copyCount;
/// Create a copy of TiketState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TiketStateCopyWith<TiketState> get copyWith => _$TiketStateCopyWithImpl<TiketState>(this as TiketState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TiketState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.booking, booking) || other.booking == booking)&&(identical(other.workshop, workshop) || other.workshop == workshop)&&const DeepCollectionEquality().equals(other.serviceById, serviceById)&&(identical(other.copyCount, copyCount) || other.copyCount == copyCount));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,booking,workshop,const DeepCollectionEquality().hash(serviceById),copyCount);

@override
String toString() {
  return 'TiketState(isLoading: $isLoading, hasError: $hasError, booking: $booking, workshop: $workshop, serviceById: $serviceById, copyCount: $copyCount)';
}


}

/// @nodoc
abstract mixin class $TiketStateCopyWith<$Res>  {
  factory $TiketStateCopyWith(TiketState value, $Res Function(TiketState) _then) = _$TiketStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool hasError, Booking? booking, Workshop? workshop, Map<String, ServiceType> serviceById, int copyCount
});


$BookingCopyWith<$Res>? get booking;$WorkshopCopyWith<$Res>? get workshop;

}
/// @nodoc
class _$TiketStateCopyWithImpl<$Res>
    implements $TiketStateCopyWith<$Res> {
  _$TiketStateCopyWithImpl(this._self, this._then);

  final TiketState _self;
  final $Res Function(TiketState) _then;

/// Create a copy of TiketState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? hasError = null,Object? booking = freezed,Object? workshop = freezed,Object? serviceById = null,Object? copyCount = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,booking: freezed == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as Booking?,workshop: freezed == workshop ? _self.workshop : workshop // ignore: cast_nullable_to_non_nullable
as Workshop?,serviceById: null == serviceById ? _self.serviceById : serviceById // ignore: cast_nullable_to_non_nullable
as Map<String, ServiceType>,copyCount: null == copyCount ? _self.copyCount : copyCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of TiketState
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
}/// Create a copy of TiketState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkshopCopyWith<$Res>? get workshop {
    if (_self.workshop == null) {
    return null;
  }

  return $WorkshopCopyWith<$Res>(_self.workshop!, (value) {
    return _then(_self.copyWith(workshop: value));
  });
}
}


/// Adds pattern-matching-related methods to [TiketState].
extension TiketStatePatterns on TiketState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TiketState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TiketState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TiketState value)  $default,){
final _that = this;
switch (_that) {
case _TiketState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TiketState value)?  $default,){
final _that = this;
switch (_that) {
case _TiketState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  Booking? booking,  Workshop? workshop,  Map<String, ServiceType> serviceById,  int copyCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TiketState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.booking,_that.workshop,_that.serviceById,_that.copyCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  Booking? booking,  Workshop? workshop,  Map<String, ServiceType> serviceById,  int copyCount)  $default,) {final _that = this;
switch (_that) {
case _TiketState():
return $default(_that.isLoading,_that.hasError,_that.booking,_that.workshop,_that.serviceById,_that.copyCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool hasError,  Booking? booking,  Workshop? workshop,  Map<String, ServiceType> serviceById,  int copyCount)?  $default,) {final _that = this;
switch (_that) {
case _TiketState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.booking,_that.workshop,_that.serviceById,_that.copyCount);case _:
  return null;

}
}

}

/// @nodoc


class _TiketState implements TiketState {
  const _TiketState({this.isLoading = true, this.hasError = false, this.booking, this.workshop, final  Map<String, ServiceType> serviceById = const <String, ServiceType>{}, this.copyCount = 0}): _serviceById = serviceById;
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool hasError;
@override final  Booking? booking;
@override final  Workshop? workshop;
 final  Map<String, ServiceType> _serviceById;
@override@JsonKey() Map<String, ServiceType> get serviceById {
  if (_serviceById is EqualUnmodifiableMapView) return _serviceById;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_serviceById);
}

/// Bumped on every successful copy so the page can show one snackbar per tap.
@override@JsonKey() final  int copyCount;

/// Create a copy of TiketState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TiketStateCopyWith<_TiketState> get copyWith => __$TiketStateCopyWithImpl<_TiketState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TiketState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.booking, booking) || other.booking == booking)&&(identical(other.workshop, workshop) || other.workshop == workshop)&&const DeepCollectionEquality().equals(other._serviceById, _serviceById)&&(identical(other.copyCount, copyCount) || other.copyCount == copyCount));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,booking,workshop,const DeepCollectionEquality().hash(_serviceById),copyCount);

@override
String toString() {
  return 'TiketState(isLoading: $isLoading, hasError: $hasError, booking: $booking, workshop: $workshop, serviceById: $serviceById, copyCount: $copyCount)';
}


}

/// @nodoc
abstract mixin class _$TiketStateCopyWith<$Res> implements $TiketStateCopyWith<$Res> {
  factory _$TiketStateCopyWith(_TiketState value, $Res Function(_TiketState) _then) = __$TiketStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool hasError, Booking? booking, Workshop? workshop, Map<String, ServiceType> serviceById, int copyCount
});


@override $BookingCopyWith<$Res>? get booking;@override $WorkshopCopyWith<$Res>? get workshop;

}
/// @nodoc
class __$TiketStateCopyWithImpl<$Res>
    implements _$TiketStateCopyWith<$Res> {
  __$TiketStateCopyWithImpl(this._self, this._then);

  final _TiketState _self;
  final $Res Function(_TiketState) _then;

/// Create a copy of TiketState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? hasError = null,Object? booking = freezed,Object? workshop = freezed,Object? serviceById = null,Object? copyCount = null,}) {
  return _then(_TiketState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,booking: freezed == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as Booking?,workshop: freezed == workshop ? _self.workshop : workshop // ignore: cast_nullable_to_non_nullable
as Workshop?,serviceById: null == serviceById ? _self._serviceById : serviceById // ignore: cast_nullable_to_non_nullable
as Map<String, ServiceType>,copyCount: null == copyCount ? _self.copyCount : copyCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of TiketState
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
}/// Create a copy of TiketState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkshopCopyWith<$Res>? get workshop {
    if (_self.workshop == null) {
    return null;
  }

  return $WorkshopCopyWith<$Res>(_self.workshop!, (value) {
    return _then(_self.copyWith(workshop: value));
  });
}
}

// dart format on
