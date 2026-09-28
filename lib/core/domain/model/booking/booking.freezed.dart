// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Booking {

 String get id; String get code; String get userId; String get workshopId; List<BookingUnit> get units; ScheduleMode get scheduleMode; TimeSlot? get sharedSlot; Map<String, TimeSlot>? get unitSlots; BookingStatus get status; String? get voucherId; int get subtotal; int get discount; int get total; DateTime get createdAt; DateTime? get completedAt;
/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingCopyWith<Booking> get copyWith => _$BookingCopyWithImpl<Booking>(this as Booking, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Booking&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.workshopId, workshopId) || other.workshopId == workshopId)&&const DeepCollectionEquality().equals(other.units, units)&&(identical(other.scheduleMode, scheduleMode) || other.scheduleMode == scheduleMode)&&(identical(other.sharedSlot, sharedSlot) || other.sharedSlot == sharedSlot)&&const DeepCollectionEquality().equals(other.unitSlots, unitSlots)&&(identical(other.status, status) || other.status == status)&&(identical(other.voucherId, voucherId) || other.voucherId == voucherId)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.total, total) || other.total == total)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,code,userId,workshopId,const DeepCollectionEquality().hash(units),scheduleMode,sharedSlot,const DeepCollectionEquality().hash(unitSlots),status,voucherId,subtotal,discount,total,createdAt,completedAt);

@override
String toString() {
  return 'Booking(id: $id, code: $code, userId: $userId, workshopId: $workshopId, units: $units, scheduleMode: $scheduleMode, sharedSlot: $sharedSlot, unitSlots: $unitSlots, status: $status, voucherId: $voucherId, subtotal: $subtotal, discount: $discount, total: $total, createdAt: $createdAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $BookingCopyWith<$Res>  {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) _then) = _$BookingCopyWithImpl;
@useResult
$Res call({
 String id, String code, String userId, String workshopId, List<BookingUnit> units, ScheduleMode scheduleMode, TimeSlot? sharedSlot, Map<String, TimeSlot>? unitSlots, BookingStatus status, String? voucherId, int subtotal, int discount, int total, DateTime createdAt, DateTime? completedAt
});


$TimeSlotCopyWith<$Res>? get sharedSlot;

}
/// @nodoc
class _$BookingCopyWithImpl<$Res>
    implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._self, this._then);

  final Booking _self;
  final $Res Function(Booking) _then;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? userId = null,Object? workshopId = null,Object? units = null,Object? scheduleMode = null,Object? sharedSlot = freezed,Object? unitSlots = freezed,Object? status = null,Object? voucherId = freezed,Object? subtotal = null,Object? discount = null,Object? total = null,Object? createdAt = null,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,workshopId: null == workshopId ? _self.workshopId : workshopId // ignore: cast_nullable_to_non_nullable
as String,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as List<BookingUnit>,scheduleMode: null == scheduleMode ? _self.scheduleMode : scheduleMode // ignore: cast_nullable_to_non_nullable
as ScheduleMode,sharedSlot: freezed == sharedSlot ? _self.sharedSlot : sharedSlot // ignore: cast_nullable_to_non_nullable
as TimeSlot?,unitSlots: freezed == unitSlots ? _self.unitSlots : unitSlots // ignore: cast_nullable_to_non_nullable
as Map<String, TimeSlot>?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,voucherId: freezed == voucherId ? _self.voucherId : voucherId // ignore: cast_nullable_to_non_nullable
as String?,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as int,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeSlotCopyWith<$Res>? get sharedSlot {
    if (_self.sharedSlot == null) {
    return null;
  }

  return $TimeSlotCopyWith<$Res>(_self.sharedSlot!, (value) {
    return _then(_self.copyWith(sharedSlot: value));
  });
}
}


/// Adds pattern-matching-related methods to [Booking].
extension BookingPatterns on Booking {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Booking value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Booking() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Booking value)  $default,){
final _that = this;
switch (_that) {
case _Booking():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Booking value)?  $default,){
final _that = this;
switch (_that) {
case _Booking() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String userId,  String workshopId,  List<BookingUnit> units,  ScheduleMode scheduleMode,  TimeSlot? sharedSlot,  Map<String, TimeSlot>? unitSlots,  BookingStatus status,  String? voucherId,  int subtotal,  int discount,  int total,  DateTime createdAt,  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that.id,_that.code,_that.userId,_that.workshopId,_that.units,_that.scheduleMode,_that.sharedSlot,_that.unitSlots,_that.status,_that.voucherId,_that.subtotal,_that.discount,_that.total,_that.createdAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String userId,  String workshopId,  List<BookingUnit> units,  ScheduleMode scheduleMode,  TimeSlot? sharedSlot,  Map<String, TimeSlot>? unitSlots,  BookingStatus status,  String? voucherId,  int subtotal,  int discount,  int total,  DateTime createdAt,  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _Booking():
return $default(_that.id,_that.code,_that.userId,_that.workshopId,_that.units,_that.scheduleMode,_that.sharedSlot,_that.unitSlots,_that.status,_that.voucherId,_that.subtotal,_that.discount,_that.total,_that.createdAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String userId,  String workshopId,  List<BookingUnit> units,  ScheduleMode scheduleMode,  TimeSlot? sharedSlot,  Map<String, TimeSlot>? unitSlots,  BookingStatus status,  String? voucherId,  int subtotal,  int discount,  int total,  DateTime createdAt,  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that.id,_that.code,_that.userId,_that.workshopId,_that.units,_that.scheduleMode,_that.sharedSlot,_that.unitSlots,_that.status,_that.voucherId,_that.subtotal,_that.discount,_that.total,_that.createdAt,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Booking implements Booking {
  const _Booking({required this.id, required this.code, required this.userId, required this.workshopId, required final  List<BookingUnit> units, required this.scheduleMode, this.sharedSlot, final  Map<String, TimeSlot>? unitSlots, required this.status, this.voucherId, required this.subtotal, required this.discount, required this.total, required this.createdAt, this.completedAt}): _units = units,_unitSlots = unitSlots;
  

@override final  String id;
@override final  String code;
@override final  String userId;
@override final  String workshopId;
 final  List<BookingUnit> _units;
@override List<BookingUnit> get units {
  if (_units is EqualUnmodifiableListView) return _units;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_units);
}

@override final  ScheduleMode scheduleMode;
@override final  TimeSlot? sharedSlot;
 final  Map<String, TimeSlot>? _unitSlots;
@override Map<String, TimeSlot>? get unitSlots {
  final value = _unitSlots;
  if (value == null) return null;
  if (_unitSlots is EqualUnmodifiableMapView) return _unitSlots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  BookingStatus status;
@override final  String? voucherId;
@override final  int subtotal;
@override final  int discount;
@override final  int total;
@override final  DateTime createdAt;
@override final  DateTime? completedAt;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingCopyWith<_Booking> get copyWith => __$BookingCopyWithImpl<_Booking>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Booking&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.workshopId, workshopId) || other.workshopId == workshopId)&&const DeepCollectionEquality().equals(other._units, _units)&&(identical(other.scheduleMode, scheduleMode) || other.scheduleMode == scheduleMode)&&(identical(other.sharedSlot, sharedSlot) || other.sharedSlot == sharedSlot)&&const DeepCollectionEquality().equals(other._unitSlots, _unitSlots)&&(identical(other.status, status) || other.status == status)&&(identical(other.voucherId, voucherId) || other.voucherId == voucherId)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.total, total) || other.total == total)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,code,userId,workshopId,const DeepCollectionEquality().hash(_units),scheduleMode,sharedSlot,const DeepCollectionEquality().hash(_unitSlots),status,voucherId,subtotal,discount,total,createdAt,completedAt);

@override
String toString() {
  return 'Booking(id: $id, code: $code, userId: $userId, workshopId: $workshopId, units: $units, scheduleMode: $scheduleMode, sharedSlot: $sharedSlot, unitSlots: $unitSlots, status: $status, voucherId: $voucherId, subtotal: $subtotal, discount: $discount, total: $total, createdAt: $createdAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$BookingCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$BookingCopyWith(_Booking value, $Res Function(_Booking) _then) = __$BookingCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String userId, String workshopId, List<BookingUnit> units, ScheduleMode scheduleMode, TimeSlot? sharedSlot, Map<String, TimeSlot>? unitSlots, BookingStatus status, String? voucherId, int subtotal, int discount, int total, DateTime createdAt, DateTime? completedAt
});


@override $TimeSlotCopyWith<$Res>? get sharedSlot;

}
/// @nodoc
class __$BookingCopyWithImpl<$Res>
    implements _$BookingCopyWith<$Res> {
  __$BookingCopyWithImpl(this._self, this._then);

  final _Booking _self;
  final $Res Function(_Booking) _then;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? userId = null,Object? workshopId = null,Object? units = null,Object? scheduleMode = null,Object? sharedSlot = freezed,Object? unitSlots = freezed,Object? status = null,Object? voucherId = freezed,Object? subtotal = null,Object? discount = null,Object? total = null,Object? createdAt = null,Object? completedAt = freezed,}) {
  return _then(_Booking(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,workshopId: null == workshopId ? _self.workshopId : workshopId // ignore: cast_nullable_to_non_nullable
as String,units: null == units ? _self._units : units // ignore: cast_nullable_to_non_nullable
as List<BookingUnit>,scheduleMode: null == scheduleMode ? _self.scheduleMode : scheduleMode // ignore: cast_nullable_to_non_nullable
as ScheduleMode,sharedSlot: freezed == sharedSlot ? _self.sharedSlot : sharedSlot // ignore: cast_nullable_to_non_nullable
as TimeSlot?,unitSlots: freezed == unitSlots ? _self._unitSlots : unitSlots // ignore: cast_nullable_to_non_nullable
as Map<String, TimeSlot>?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,voucherId: freezed == voucherId ? _self.voucherId : voucherId // ignore: cast_nullable_to_non_nullable
as String?,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as int,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeSlotCopyWith<$Res>? get sharedSlot {
    if (_self.sharedSlot == null) {
    return null;
  }

  return $TimeSlotCopyWith<$Res>(_self.sharedSlot!, (value) {
    return _then(_self.copyWith(sharedSlot: value));
  });
}
}

// dart format on
