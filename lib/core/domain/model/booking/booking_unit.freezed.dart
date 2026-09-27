// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_unit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookingUnit {

 String get unitCode; String get motorId; Motor get motorSnapshot; List<String> get serviceIds; List<String> get partIds; String? get complaintNote; UnitStatus get status; List<StatusEvent> get statusHistory; String? get mechanicId; int get subtotal; int get durationMin;
/// Create a copy of BookingUnit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingUnitCopyWith<BookingUnit> get copyWith => _$BookingUnitCopyWithImpl<BookingUnit>(this as BookingUnit, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingUnit&&(identical(other.unitCode, unitCode) || other.unitCode == unitCode)&&(identical(other.motorId, motorId) || other.motorId == motorId)&&(identical(other.motorSnapshot, motorSnapshot) || other.motorSnapshot == motorSnapshot)&&const DeepCollectionEquality().equals(other.serviceIds, serviceIds)&&const DeepCollectionEquality().equals(other.partIds, partIds)&&(identical(other.complaintNote, complaintNote) || other.complaintNote == complaintNote)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.statusHistory, statusHistory)&&(identical(other.mechanicId, mechanicId) || other.mechanicId == mechanicId)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.durationMin, durationMin) || other.durationMin == durationMin));
}


@override
int get hashCode => Object.hash(runtimeType,unitCode,motorId,motorSnapshot,const DeepCollectionEquality().hash(serviceIds),const DeepCollectionEquality().hash(partIds),complaintNote,status,const DeepCollectionEquality().hash(statusHistory),mechanicId,subtotal,durationMin);

@override
String toString() {
  return 'BookingUnit(unitCode: $unitCode, motorId: $motorId, motorSnapshot: $motorSnapshot, serviceIds: $serviceIds, partIds: $partIds, complaintNote: $complaintNote, status: $status, statusHistory: $statusHistory, mechanicId: $mechanicId, subtotal: $subtotal, durationMin: $durationMin)';
}


}

/// @nodoc
abstract mixin class $BookingUnitCopyWith<$Res>  {
  factory $BookingUnitCopyWith(BookingUnit value, $Res Function(BookingUnit) _then) = _$BookingUnitCopyWithImpl;
@useResult
$Res call({
 String unitCode, String motorId, Motor motorSnapshot, List<String> serviceIds, List<String> partIds, String? complaintNote, UnitStatus status, List<StatusEvent> statusHistory, String? mechanicId, int subtotal, int durationMin
});


$MotorCopyWith<$Res> get motorSnapshot;

}
/// @nodoc
class _$BookingUnitCopyWithImpl<$Res>
    implements $BookingUnitCopyWith<$Res> {
  _$BookingUnitCopyWithImpl(this._self, this._then);

  final BookingUnit _self;
  final $Res Function(BookingUnit) _then;

/// Create a copy of BookingUnit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? unitCode = null,Object? motorId = null,Object? motorSnapshot = null,Object? serviceIds = null,Object? partIds = null,Object? complaintNote = freezed,Object? status = null,Object? statusHistory = null,Object? mechanicId = freezed,Object? subtotal = null,Object? durationMin = null,}) {
  return _then(_self.copyWith(
unitCode: null == unitCode ? _self.unitCode : unitCode // ignore: cast_nullable_to_non_nullable
as String,motorId: null == motorId ? _self.motorId : motorId // ignore: cast_nullable_to_non_nullable
as String,motorSnapshot: null == motorSnapshot ? _self.motorSnapshot : motorSnapshot // ignore: cast_nullable_to_non_nullable
as Motor,serviceIds: null == serviceIds ? _self.serviceIds : serviceIds // ignore: cast_nullable_to_non_nullable
as List<String>,partIds: null == partIds ? _self.partIds : partIds // ignore: cast_nullable_to_non_nullable
as List<String>,complaintNote: freezed == complaintNote ? _self.complaintNote : complaintNote // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UnitStatus,statusHistory: null == statusHistory ? _self.statusHistory : statusHistory // ignore: cast_nullable_to_non_nullable
as List<StatusEvent>,mechanicId: freezed == mechanicId ? _self.mechanicId : mechanicId // ignore: cast_nullable_to_non_nullable
as String?,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as int,durationMin: null == durationMin ? _self.durationMin : durationMin // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of BookingUnit
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MotorCopyWith<$Res> get motorSnapshot {
  
  return $MotorCopyWith<$Res>(_self.motorSnapshot, (value) {
    return _then(_self.copyWith(motorSnapshot: value));
  });
}
}


/// Adds pattern-matching-related methods to [BookingUnit].
extension BookingUnitPatterns on BookingUnit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingUnit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingUnit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingUnit value)  $default,){
final _that = this;
switch (_that) {
case _BookingUnit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingUnit value)?  $default,){
final _that = this;
switch (_that) {
case _BookingUnit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String unitCode,  String motorId,  Motor motorSnapshot,  List<String> serviceIds,  List<String> partIds,  String? complaintNote,  UnitStatus status,  List<StatusEvent> statusHistory,  String? mechanicId,  int subtotal,  int durationMin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingUnit() when $default != null:
return $default(_that.unitCode,_that.motorId,_that.motorSnapshot,_that.serviceIds,_that.partIds,_that.complaintNote,_that.status,_that.statusHistory,_that.mechanicId,_that.subtotal,_that.durationMin);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String unitCode,  String motorId,  Motor motorSnapshot,  List<String> serviceIds,  List<String> partIds,  String? complaintNote,  UnitStatus status,  List<StatusEvent> statusHistory,  String? mechanicId,  int subtotal,  int durationMin)  $default,) {final _that = this;
switch (_that) {
case _BookingUnit():
return $default(_that.unitCode,_that.motorId,_that.motorSnapshot,_that.serviceIds,_that.partIds,_that.complaintNote,_that.status,_that.statusHistory,_that.mechanicId,_that.subtotal,_that.durationMin);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String unitCode,  String motorId,  Motor motorSnapshot,  List<String> serviceIds,  List<String> partIds,  String? complaintNote,  UnitStatus status,  List<StatusEvent> statusHistory,  String? mechanicId,  int subtotal,  int durationMin)?  $default,) {final _that = this;
switch (_that) {
case _BookingUnit() when $default != null:
return $default(_that.unitCode,_that.motorId,_that.motorSnapshot,_that.serviceIds,_that.partIds,_that.complaintNote,_that.status,_that.statusHistory,_that.mechanicId,_that.subtotal,_that.durationMin);case _:
  return null;

}
}

}

/// @nodoc


class _BookingUnit implements BookingUnit {
  const _BookingUnit({required this.unitCode, required this.motorId, required this.motorSnapshot, required final  List<String> serviceIds, required final  List<String> partIds, this.complaintNote, required this.status, required final  List<StatusEvent> statusHistory, this.mechanicId, required this.subtotal, required this.durationMin}): _serviceIds = serviceIds,_partIds = partIds,_statusHistory = statusHistory;
  

@override final  String unitCode;
@override final  String motorId;
@override final  Motor motorSnapshot;
 final  List<String> _serviceIds;
@override List<String> get serviceIds {
  if (_serviceIds is EqualUnmodifiableListView) return _serviceIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_serviceIds);
}

 final  List<String> _partIds;
@override List<String> get partIds {
  if (_partIds is EqualUnmodifiableListView) return _partIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_partIds);
}

@override final  String? complaintNote;
@override final  UnitStatus status;
 final  List<StatusEvent> _statusHistory;
@override List<StatusEvent> get statusHistory {
  if (_statusHistory is EqualUnmodifiableListView) return _statusHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_statusHistory);
}

@override final  String? mechanicId;
@override final  int subtotal;
@override final  int durationMin;

/// Create a copy of BookingUnit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingUnitCopyWith<_BookingUnit> get copyWith => __$BookingUnitCopyWithImpl<_BookingUnit>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingUnit&&(identical(other.unitCode, unitCode) || other.unitCode == unitCode)&&(identical(other.motorId, motorId) || other.motorId == motorId)&&(identical(other.motorSnapshot, motorSnapshot) || other.motorSnapshot == motorSnapshot)&&const DeepCollectionEquality().equals(other._serviceIds, _serviceIds)&&const DeepCollectionEquality().equals(other._partIds, _partIds)&&(identical(other.complaintNote, complaintNote) || other.complaintNote == complaintNote)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._statusHistory, _statusHistory)&&(identical(other.mechanicId, mechanicId) || other.mechanicId == mechanicId)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.durationMin, durationMin) || other.durationMin == durationMin));
}


@override
int get hashCode => Object.hash(runtimeType,unitCode,motorId,motorSnapshot,const DeepCollectionEquality().hash(_serviceIds),const DeepCollectionEquality().hash(_partIds),complaintNote,status,const DeepCollectionEquality().hash(_statusHistory),mechanicId,subtotal,durationMin);

@override
String toString() {
  return 'BookingUnit(unitCode: $unitCode, motorId: $motorId, motorSnapshot: $motorSnapshot, serviceIds: $serviceIds, partIds: $partIds, complaintNote: $complaintNote, status: $status, statusHistory: $statusHistory, mechanicId: $mechanicId, subtotal: $subtotal, durationMin: $durationMin)';
}


}

/// @nodoc
abstract mixin class _$BookingUnitCopyWith<$Res> implements $BookingUnitCopyWith<$Res> {
  factory _$BookingUnitCopyWith(_BookingUnit value, $Res Function(_BookingUnit) _then) = __$BookingUnitCopyWithImpl;
@override @useResult
$Res call({
 String unitCode, String motorId, Motor motorSnapshot, List<String> serviceIds, List<String> partIds, String? complaintNote, UnitStatus status, List<StatusEvent> statusHistory, String? mechanicId, int subtotal, int durationMin
});


@override $MotorCopyWith<$Res> get motorSnapshot;

}
/// @nodoc
class __$BookingUnitCopyWithImpl<$Res>
    implements _$BookingUnitCopyWith<$Res> {
  __$BookingUnitCopyWithImpl(this._self, this._then);

  final _BookingUnit _self;
  final $Res Function(_BookingUnit) _then;

/// Create a copy of BookingUnit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? unitCode = null,Object? motorId = null,Object? motorSnapshot = null,Object? serviceIds = null,Object? partIds = null,Object? complaintNote = freezed,Object? status = null,Object? statusHistory = null,Object? mechanicId = freezed,Object? subtotal = null,Object? durationMin = null,}) {
  return _then(_BookingUnit(
unitCode: null == unitCode ? _self.unitCode : unitCode // ignore: cast_nullable_to_non_nullable
as String,motorId: null == motorId ? _self.motorId : motorId // ignore: cast_nullable_to_non_nullable
as String,motorSnapshot: null == motorSnapshot ? _self.motorSnapshot : motorSnapshot // ignore: cast_nullable_to_non_nullable
as Motor,serviceIds: null == serviceIds ? _self._serviceIds : serviceIds // ignore: cast_nullable_to_non_nullable
as List<String>,partIds: null == partIds ? _self._partIds : partIds // ignore: cast_nullable_to_non_nullable
as List<String>,complaintNote: freezed == complaintNote ? _self.complaintNote : complaintNote // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UnitStatus,statusHistory: null == statusHistory ? _self._statusHistory : statusHistory // ignore: cast_nullable_to_non_nullable
as List<StatusEvent>,mechanicId: freezed == mechanicId ? _self.mechanicId : mechanicId // ignore: cast_nullable_to_non_nullable
as String?,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as int,durationMin: null == durationMin ? _self.durationMin : durationMin // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of BookingUnit
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MotorCopyWith<$Res> get motorSnapshot {
  
  return $MotorCopyWith<$Res>(_self.motorSnapshot, (value) {
    return _then(_self.copyWith(motorSnapshot: value));
  });
}
}

// dart format on
