// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ubah_jadwal_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UbahJadwalState {

 DateTime get selectedDate; bool get isLoadingSlots; bool get slotsError; List<TimeSlot> get slots; TimeSlot? get selectedSlot; bool get isSaving; bool get saveFailed;
/// Create a copy of UbahJadwalState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UbahJadwalStateCopyWith<UbahJadwalState> get copyWith => _$UbahJadwalStateCopyWithImpl<UbahJadwalState>(this as UbahJadwalState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UbahJadwalState&&(identical(other.selectedDate, selectedDate) || other.selectedDate == selectedDate)&&(identical(other.isLoadingSlots, isLoadingSlots) || other.isLoadingSlots == isLoadingSlots)&&(identical(other.slotsError, slotsError) || other.slotsError == slotsError)&&const DeepCollectionEquality().equals(other.slots, slots)&&(identical(other.selectedSlot, selectedSlot) || other.selectedSlot == selectedSlot)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.saveFailed, saveFailed) || other.saveFailed == saveFailed));
}


@override
int get hashCode => Object.hash(runtimeType,selectedDate,isLoadingSlots,slotsError,const DeepCollectionEquality().hash(slots),selectedSlot,isSaving,saveFailed);

@override
String toString() {
  return 'UbahJadwalState(selectedDate: $selectedDate, isLoadingSlots: $isLoadingSlots, slotsError: $slotsError, slots: $slots, selectedSlot: $selectedSlot, isSaving: $isSaving, saveFailed: $saveFailed)';
}


}

/// @nodoc
abstract mixin class $UbahJadwalStateCopyWith<$Res>  {
  factory $UbahJadwalStateCopyWith(UbahJadwalState value, $Res Function(UbahJadwalState) _then) = _$UbahJadwalStateCopyWithImpl;
@useResult
$Res call({
 DateTime selectedDate, bool isLoadingSlots, bool slotsError, List<TimeSlot> slots, TimeSlot? selectedSlot, bool isSaving, bool saveFailed
});


$TimeSlotCopyWith<$Res>? get selectedSlot;

}
/// @nodoc
class _$UbahJadwalStateCopyWithImpl<$Res>
    implements $UbahJadwalStateCopyWith<$Res> {
  _$UbahJadwalStateCopyWithImpl(this._self, this._then);

  final UbahJadwalState _self;
  final $Res Function(UbahJadwalState) _then;

/// Create a copy of UbahJadwalState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedDate = null,Object? isLoadingSlots = null,Object? slotsError = null,Object? slots = null,Object? selectedSlot = freezed,Object? isSaving = null,Object? saveFailed = null,}) {
  return _then(_self.copyWith(
selectedDate: null == selectedDate ? _self.selectedDate : selectedDate // ignore: cast_nullable_to_non_nullable
as DateTime,isLoadingSlots: null == isLoadingSlots ? _self.isLoadingSlots : isLoadingSlots // ignore: cast_nullable_to_non_nullable
as bool,slotsError: null == slotsError ? _self.slotsError : slotsError // ignore: cast_nullable_to_non_nullable
as bool,slots: null == slots ? _self.slots : slots // ignore: cast_nullable_to_non_nullable
as List<TimeSlot>,selectedSlot: freezed == selectedSlot ? _self.selectedSlot : selectedSlot // ignore: cast_nullable_to_non_nullable
as TimeSlot?,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,saveFailed: null == saveFailed ? _self.saveFailed : saveFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of UbahJadwalState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeSlotCopyWith<$Res>? get selectedSlot {
    if (_self.selectedSlot == null) {
    return null;
  }

  return $TimeSlotCopyWith<$Res>(_self.selectedSlot!, (value) {
    return _then(_self.copyWith(selectedSlot: value));
  });
}
}


/// Adds pattern-matching-related methods to [UbahJadwalState].
extension UbahJadwalStatePatterns on UbahJadwalState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UbahJadwalState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UbahJadwalState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UbahJadwalState value)  $default,){
final _that = this;
switch (_that) {
case _UbahJadwalState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UbahJadwalState value)?  $default,){
final _that = this;
switch (_that) {
case _UbahJadwalState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime selectedDate,  bool isLoadingSlots,  bool slotsError,  List<TimeSlot> slots,  TimeSlot? selectedSlot,  bool isSaving,  bool saveFailed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UbahJadwalState() when $default != null:
return $default(_that.selectedDate,_that.isLoadingSlots,_that.slotsError,_that.slots,_that.selectedSlot,_that.isSaving,_that.saveFailed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime selectedDate,  bool isLoadingSlots,  bool slotsError,  List<TimeSlot> slots,  TimeSlot? selectedSlot,  bool isSaving,  bool saveFailed)  $default,) {final _that = this;
switch (_that) {
case _UbahJadwalState():
return $default(_that.selectedDate,_that.isLoadingSlots,_that.slotsError,_that.slots,_that.selectedSlot,_that.isSaving,_that.saveFailed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime selectedDate,  bool isLoadingSlots,  bool slotsError,  List<TimeSlot> slots,  TimeSlot? selectedSlot,  bool isSaving,  bool saveFailed)?  $default,) {final _that = this;
switch (_that) {
case _UbahJadwalState() when $default != null:
return $default(_that.selectedDate,_that.isLoadingSlots,_that.slotsError,_that.slots,_that.selectedSlot,_that.isSaving,_that.saveFailed);case _:
  return null;

}
}

}

/// @nodoc


class _UbahJadwalState implements UbahJadwalState {
  const _UbahJadwalState({required this.selectedDate, this.isLoadingSlots = true, this.slotsError = false, final  List<TimeSlot> slots = const <TimeSlot>[], this.selectedSlot, this.isSaving = false, this.saveFailed = false}): _slots = slots;
  

@override final  DateTime selectedDate;
@override@JsonKey() final  bool isLoadingSlots;
@override@JsonKey() final  bool slotsError;
 final  List<TimeSlot> _slots;
@override@JsonKey() List<TimeSlot> get slots {
  if (_slots is EqualUnmodifiableListView) return _slots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_slots);
}

@override final  TimeSlot? selectedSlot;
@override@JsonKey() final  bool isSaving;
@override@JsonKey() final  bool saveFailed;

/// Create a copy of UbahJadwalState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UbahJadwalStateCopyWith<_UbahJadwalState> get copyWith => __$UbahJadwalStateCopyWithImpl<_UbahJadwalState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UbahJadwalState&&(identical(other.selectedDate, selectedDate) || other.selectedDate == selectedDate)&&(identical(other.isLoadingSlots, isLoadingSlots) || other.isLoadingSlots == isLoadingSlots)&&(identical(other.slotsError, slotsError) || other.slotsError == slotsError)&&const DeepCollectionEquality().equals(other._slots, _slots)&&(identical(other.selectedSlot, selectedSlot) || other.selectedSlot == selectedSlot)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.saveFailed, saveFailed) || other.saveFailed == saveFailed));
}


@override
int get hashCode => Object.hash(runtimeType,selectedDate,isLoadingSlots,slotsError,const DeepCollectionEquality().hash(_slots),selectedSlot,isSaving,saveFailed);

@override
String toString() {
  return 'UbahJadwalState(selectedDate: $selectedDate, isLoadingSlots: $isLoadingSlots, slotsError: $slotsError, slots: $slots, selectedSlot: $selectedSlot, isSaving: $isSaving, saveFailed: $saveFailed)';
}


}

/// @nodoc
abstract mixin class _$UbahJadwalStateCopyWith<$Res> implements $UbahJadwalStateCopyWith<$Res> {
  factory _$UbahJadwalStateCopyWith(_UbahJadwalState value, $Res Function(_UbahJadwalState) _then) = __$UbahJadwalStateCopyWithImpl;
@override @useResult
$Res call({
 DateTime selectedDate, bool isLoadingSlots, bool slotsError, List<TimeSlot> slots, TimeSlot? selectedSlot, bool isSaving, bool saveFailed
});


@override $TimeSlotCopyWith<$Res>? get selectedSlot;

}
/// @nodoc
class __$UbahJadwalStateCopyWithImpl<$Res>
    implements _$UbahJadwalStateCopyWith<$Res> {
  __$UbahJadwalStateCopyWithImpl(this._self, this._then);

  final _UbahJadwalState _self;
  final $Res Function(_UbahJadwalState) _then;

/// Create a copy of UbahJadwalState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedDate = null,Object? isLoadingSlots = null,Object? slotsError = null,Object? slots = null,Object? selectedSlot = freezed,Object? isSaving = null,Object? saveFailed = null,}) {
  return _then(_UbahJadwalState(
selectedDate: null == selectedDate ? _self.selectedDate : selectedDate // ignore: cast_nullable_to_non_nullable
as DateTime,isLoadingSlots: null == isLoadingSlots ? _self.isLoadingSlots : isLoadingSlots // ignore: cast_nullable_to_non_nullable
as bool,slotsError: null == slotsError ? _self.slotsError : slotsError // ignore: cast_nullable_to_non_nullable
as bool,slots: null == slots ? _self._slots : slots // ignore: cast_nullable_to_non_nullable
as List<TimeSlot>,selectedSlot: freezed == selectedSlot ? _self.selectedSlot : selectedSlot // ignore: cast_nullable_to_non_nullable
as TimeSlot?,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,saveFailed: null == saveFailed ? _self.saveFailed : saveFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of UbahJadwalState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimeSlotCopyWith<$Res>? get selectedSlot {
    if (_self.selectedSlot == null) {
    return null;
  }

  return $TimeSlotCopyWith<$Res>(_self.selectedSlot!, (value) {
    return _then(_self.copyWith(selectedSlot: value));
  });
}
}

// dart format on
