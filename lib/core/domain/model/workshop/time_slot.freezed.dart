// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_slot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TimeSlot {

 DateTime get date; int get hour; int get capacity; int get booked;
/// Create a copy of TimeSlot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeSlotCopyWith<TimeSlot> get copyWith => _$TimeSlotCopyWithImpl<TimeSlot>(this as TimeSlot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeSlot&&(identical(other.date, date) || other.date == date)&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.booked, booked) || other.booked == booked));
}


@override
int get hashCode => Object.hash(runtimeType,date,hour,capacity,booked);

@override
String toString() {
  return 'TimeSlot(date: $date, hour: $hour, capacity: $capacity, booked: $booked)';
}


}

/// @nodoc
abstract mixin class $TimeSlotCopyWith<$Res>  {
  factory $TimeSlotCopyWith(TimeSlot value, $Res Function(TimeSlot) _then) = _$TimeSlotCopyWithImpl;
@useResult
$Res call({
 DateTime date, int hour, int capacity, int booked
});




}
/// @nodoc
class _$TimeSlotCopyWithImpl<$Res>
    implements $TimeSlotCopyWith<$Res> {
  _$TimeSlotCopyWithImpl(this._self, this._then);

  final TimeSlot _self;
  final $Res Function(TimeSlot) _then;

/// Create a copy of TimeSlot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? hour = null,Object? capacity = null,Object? booked = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,booked: null == booked ? _self.booked : booked // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TimeSlot].
extension TimeSlotPatterns on TimeSlot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimeSlot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimeSlot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimeSlot value)  $default,){
final _that = this;
switch (_that) {
case _TimeSlot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimeSlot value)?  $default,){
final _that = this;
switch (_that) {
case _TimeSlot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  int hour,  int capacity,  int booked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimeSlot() when $default != null:
return $default(_that.date,_that.hour,_that.capacity,_that.booked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  int hour,  int capacity,  int booked)  $default,) {final _that = this;
switch (_that) {
case _TimeSlot():
return $default(_that.date,_that.hour,_that.capacity,_that.booked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  int hour,  int capacity,  int booked)?  $default,) {final _that = this;
switch (_that) {
case _TimeSlot() when $default != null:
return $default(_that.date,_that.hour,_that.capacity,_that.booked);case _:
  return null;

}
}

}

/// @nodoc


class _TimeSlot extends TimeSlot {
  const _TimeSlot({required this.date, required this.hour, required this.capacity, required this.booked}): super._();
  

@override final  DateTime date;
@override final  int hour;
@override final  int capacity;
@override final  int booked;

/// Create a copy of TimeSlot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeSlotCopyWith<_TimeSlot> get copyWith => __$TimeSlotCopyWithImpl<_TimeSlot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeSlot&&(identical(other.date, date) || other.date == date)&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.booked, booked) || other.booked == booked));
}


@override
int get hashCode => Object.hash(runtimeType,date,hour,capacity,booked);

@override
String toString() {
  return 'TimeSlot(date: $date, hour: $hour, capacity: $capacity, booked: $booked)';
}


}

/// @nodoc
abstract mixin class _$TimeSlotCopyWith<$Res> implements $TimeSlotCopyWith<$Res> {
  factory _$TimeSlotCopyWith(_TimeSlot value, $Res Function(_TimeSlot) _then) = __$TimeSlotCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, int hour, int capacity, int booked
});




}
/// @nodoc
class __$TimeSlotCopyWithImpl<$Res>
    implements _$TimeSlotCopyWith<$Res> {
  __$TimeSlotCopyWithImpl(this._self, this._then);

  final _TimeSlot _self;
  final $Res Function(_TimeSlot) _then;

/// Create a copy of TimeSlot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? hour = null,Object? capacity = null,Object? booked = null,}) {
  return _then(_TimeSlot(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,booked: null == booked ? _self.booked : booked // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
