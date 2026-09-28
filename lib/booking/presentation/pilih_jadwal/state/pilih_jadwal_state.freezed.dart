// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pilih_jadwal_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PilihJadwalState {

 bool get isLoading; bool get hasError; Workshop? get workshop; Map<String, Motor> get motorsById; DateTime? get sharedDate; List<TimeSlot> get sharedSlots; bool get sharedSlotsLoading; Map<String, DateTime> get unitDates; Map<String, List<TimeSlot>> get unitSlotsByMotor; Set<String> get unitSlotsLoading; String? get expandedMotorId; bool get allFullSearching; DateTime? get allFullNextDate;
/// Create a copy of PilihJadwalState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PilihJadwalStateCopyWith<PilihJadwalState> get copyWith => _$PilihJadwalStateCopyWithImpl<PilihJadwalState>(this as PilihJadwalState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PilihJadwalState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.workshop, workshop) || other.workshop == workshop)&&const DeepCollectionEquality().equals(other.motorsById, motorsById)&&(identical(other.sharedDate, sharedDate) || other.sharedDate == sharedDate)&&const DeepCollectionEquality().equals(other.sharedSlots, sharedSlots)&&(identical(other.sharedSlotsLoading, sharedSlotsLoading) || other.sharedSlotsLoading == sharedSlotsLoading)&&const DeepCollectionEquality().equals(other.unitDates, unitDates)&&const DeepCollectionEquality().equals(other.unitSlotsByMotor, unitSlotsByMotor)&&const DeepCollectionEquality().equals(other.unitSlotsLoading, unitSlotsLoading)&&(identical(other.expandedMotorId, expandedMotorId) || other.expandedMotorId == expandedMotorId)&&(identical(other.allFullSearching, allFullSearching) || other.allFullSearching == allFullSearching)&&(identical(other.allFullNextDate, allFullNextDate) || other.allFullNextDate == allFullNextDate));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,workshop,const DeepCollectionEquality().hash(motorsById),sharedDate,const DeepCollectionEquality().hash(sharedSlots),sharedSlotsLoading,const DeepCollectionEquality().hash(unitDates),const DeepCollectionEquality().hash(unitSlotsByMotor),const DeepCollectionEquality().hash(unitSlotsLoading),expandedMotorId,allFullSearching,allFullNextDate);

@override
String toString() {
  return 'PilihJadwalState(isLoading: $isLoading, hasError: $hasError, workshop: $workshop, motorsById: $motorsById, sharedDate: $sharedDate, sharedSlots: $sharedSlots, sharedSlotsLoading: $sharedSlotsLoading, unitDates: $unitDates, unitSlotsByMotor: $unitSlotsByMotor, unitSlotsLoading: $unitSlotsLoading, expandedMotorId: $expandedMotorId, allFullSearching: $allFullSearching, allFullNextDate: $allFullNextDate)';
}


}

/// @nodoc
abstract mixin class $PilihJadwalStateCopyWith<$Res>  {
  factory $PilihJadwalStateCopyWith(PilihJadwalState value, $Res Function(PilihJadwalState) _then) = _$PilihJadwalStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool hasError, Workshop? workshop, Map<String, Motor> motorsById, DateTime? sharedDate, List<TimeSlot> sharedSlots, bool sharedSlotsLoading, Map<String, DateTime> unitDates, Map<String, List<TimeSlot>> unitSlotsByMotor, Set<String> unitSlotsLoading, String? expandedMotorId, bool allFullSearching, DateTime? allFullNextDate
});


$WorkshopCopyWith<$Res>? get workshop;

}
/// @nodoc
class _$PilihJadwalStateCopyWithImpl<$Res>
    implements $PilihJadwalStateCopyWith<$Res> {
  _$PilihJadwalStateCopyWithImpl(this._self, this._then);

  final PilihJadwalState _self;
  final $Res Function(PilihJadwalState) _then;

/// Create a copy of PilihJadwalState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? hasError = null,Object? workshop = freezed,Object? motorsById = null,Object? sharedDate = freezed,Object? sharedSlots = null,Object? sharedSlotsLoading = null,Object? unitDates = null,Object? unitSlotsByMotor = null,Object? unitSlotsLoading = null,Object? expandedMotorId = freezed,Object? allFullSearching = null,Object? allFullNextDate = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,workshop: freezed == workshop ? _self.workshop : workshop // ignore: cast_nullable_to_non_nullable
as Workshop?,motorsById: null == motorsById ? _self.motorsById : motorsById // ignore: cast_nullable_to_non_nullable
as Map<String, Motor>,sharedDate: freezed == sharedDate ? _self.sharedDate : sharedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,sharedSlots: null == sharedSlots ? _self.sharedSlots : sharedSlots // ignore: cast_nullable_to_non_nullable
as List<TimeSlot>,sharedSlotsLoading: null == sharedSlotsLoading ? _self.sharedSlotsLoading : sharedSlotsLoading // ignore: cast_nullable_to_non_nullable
as bool,unitDates: null == unitDates ? _self.unitDates : unitDates // ignore: cast_nullable_to_non_nullable
as Map<String, DateTime>,unitSlotsByMotor: null == unitSlotsByMotor ? _self.unitSlotsByMotor : unitSlotsByMotor // ignore: cast_nullable_to_non_nullable
as Map<String, List<TimeSlot>>,unitSlotsLoading: null == unitSlotsLoading ? _self.unitSlotsLoading : unitSlotsLoading // ignore: cast_nullable_to_non_nullable
as Set<String>,expandedMotorId: freezed == expandedMotorId ? _self.expandedMotorId : expandedMotorId // ignore: cast_nullable_to_non_nullable
as String?,allFullSearching: null == allFullSearching ? _self.allFullSearching : allFullSearching // ignore: cast_nullable_to_non_nullable
as bool,allFullNextDate: freezed == allFullNextDate ? _self.allFullNextDate : allFullNextDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of PilihJadwalState
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


/// Adds pattern-matching-related methods to [PilihJadwalState].
extension PilihJadwalStatePatterns on PilihJadwalState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PilihJadwalState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PilihJadwalState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PilihJadwalState value)  $default,){
final _that = this;
switch (_that) {
case _PilihJadwalState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PilihJadwalState value)?  $default,){
final _that = this;
switch (_that) {
case _PilihJadwalState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  Workshop? workshop,  Map<String, Motor> motorsById,  DateTime? sharedDate,  List<TimeSlot> sharedSlots,  bool sharedSlotsLoading,  Map<String, DateTime> unitDates,  Map<String, List<TimeSlot>> unitSlotsByMotor,  Set<String> unitSlotsLoading,  String? expandedMotorId,  bool allFullSearching,  DateTime? allFullNextDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PilihJadwalState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.workshop,_that.motorsById,_that.sharedDate,_that.sharedSlots,_that.sharedSlotsLoading,_that.unitDates,_that.unitSlotsByMotor,_that.unitSlotsLoading,_that.expandedMotorId,_that.allFullSearching,_that.allFullNextDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  Workshop? workshop,  Map<String, Motor> motorsById,  DateTime? sharedDate,  List<TimeSlot> sharedSlots,  bool sharedSlotsLoading,  Map<String, DateTime> unitDates,  Map<String, List<TimeSlot>> unitSlotsByMotor,  Set<String> unitSlotsLoading,  String? expandedMotorId,  bool allFullSearching,  DateTime? allFullNextDate)  $default,) {final _that = this;
switch (_that) {
case _PilihJadwalState():
return $default(_that.isLoading,_that.hasError,_that.workshop,_that.motorsById,_that.sharedDate,_that.sharedSlots,_that.sharedSlotsLoading,_that.unitDates,_that.unitSlotsByMotor,_that.unitSlotsLoading,_that.expandedMotorId,_that.allFullSearching,_that.allFullNextDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool hasError,  Workshop? workshop,  Map<String, Motor> motorsById,  DateTime? sharedDate,  List<TimeSlot> sharedSlots,  bool sharedSlotsLoading,  Map<String, DateTime> unitDates,  Map<String, List<TimeSlot>> unitSlotsByMotor,  Set<String> unitSlotsLoading,  String? expandedMotorId,  bool allFullSearching,  DateTime? allFullNextDate)?  $default,) {final _that = this;
switch (_that) {
case _PilihJadwalState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.workshop,_that.motorsById,_that.sharedDate,_that.sharedSlots,_that.sharedSlotsLoading,_that.unitDates,_that.unitSlotsByMotor,_that.unitSlotsLoading,_that.expandedMotorId,_that.allFullSearching,_that.allFullNextDate);case _:
  return null;

}
}

}

/// @nodoc


class _PilihJadwalState implements PilihJadwalState {
  const _PilihJadwalState({this.isLoading = true, this.hasError = false, this.workshop, final  Map<String, Motor> motorsById = const <String, Motor>{}, this.sharedDate, final  List<TimeSlot> sharedSlots = const <TimeSlot>[], this.sharedSlotsLoading = false, final  Map<String, DateTime> unitDates = const <String, DateTime>{}, final  Map<String, List<TimeSlot>> unitSlotsByMotor = const <String, List<TimeSlot>>{}, final  Set<String> unitSlotsLoading = const <String>{}, this.expandedMotorId, this.allFullSearching = false, this.allFullNextDate}): _motorsById = motorsById,_sharedSlots = sharedSlots,_unitDates = unitDates,_unitSlotsByMotor = unitSlotsByMotor,_unitSlotsLoading = unitSlotsLoading;
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool hasError;
@override final  Workshop? workshop;
 final  Map<String, Motor> _motorsById;
@override@JsonKey() Map<String, Motor> get motorsById {
  if (_motorsById is EqualUnmodifiableMapView) return _motorsById;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_motorsById);
}

@override final  DateTime? sharedDate;
 final  List<TimeSlot> _sharedSlots;
@override@JsonKey() List<TimeSlot> get sharedSlots {
  if (_sharedSlots is EqualUnmodifiableListView) return _sharedSlots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sharedSlots);
}

@override@JsonKey() final  bool sharedSlotsLoading;
 final  Map<String, DateTime> _unitDates;
@override@JsonKey() Map<String, DateTime> get unitDates {
  if (_unitDates is EqualUnmodifiableMapView) return _unitDates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_unitDates);
}

 final  Map<String, List<TimeSlot>> _unitSlotsByMotor;
@override@JsonKey() Map<String, List<TimeSlot>> get unitSlotsByMotor {
  if (_unitSlotsByMotor is EqualUnmodifiableMapView) return _unitSlotsByMotor;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_unitSlotsByMotor);
}

 final  Set<String> _unitSlotsLoading;
@override@JsonKey() Set<String> get unitSlotsLoading {
  if (_unitSlotsLoading is EqualUnmodifiableSetView) return _unitSlotsLoading;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_unitSlotsLoading);
}

@override final  String? expandedMotorId;
@override@JsonKey() final  bool allFullSearching;
@override final  DateTime? allFullNextDate;

/// Create a copy of PilihJadwalState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PilihJadwalStateCopyWith<_PilihJadwalState> get copyWith => __$PilihJadwalStateCopyWithImpl<_PilihJadwalState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PilihJadwalState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.workshop, workshop) || other.workshop == workshop)&&const DeepCollectionEquality().equals(other._motorsById, _motorsById)&&(identical(other.sharedDate, sharedDate) || other.sharedDate == sharedDate)&&const DeepCollectionEquality().equals(other._sharedSlots, _sharedSlots)&&(identical(other.sharedSlotsLoading, sharedSlotsLoading) || other.sharedSlotsLoading == sharedSlotsLoading)&&const DeepCollectionEquality().equals(other._unitDates, _unitDates)&&const DeepCollectionEquality().equals(other._unitSlotsByMotor, _unitSlotsByMotor)&&const DeepCollectionEquality().equals(other._unitSlotsLoading, _unitSlotsLoading)&&(identical(other.expandedMotorId, expandedMotorId) || other.expandedMotorId == expandedMotorId)&&(identical(other.allFullSearching, allFullSearching) || other.allFullSearching == allFullSearching)&&(identical(other.allFullNextDate, allFullNextDate) || other.allFullNextDate == allFullNextDate));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,workshop,const DeepCollectionEquality().hash(_motorsById),sharedDate,const DeepCollectionEquality().hash(_sharedSlots),sharedSlotsLoading,const DeepCollectionEquality().hash(_unitDates),const DeepCollectionEquality().hash(_unitSlotsByMotor),const DeepCollectionEquality().hash(_unitSlotsLoading),expandedMotorId,allFullSearching,allFullNextDate);

@override
String toString() {
  return 'PilihJadwalState(isLoading: $isLoading, hasError: $hasError, workshop: $workshop, motorsById: $motorsById, sharedDate: $sharedDate, sharedSlots: $sharedSlots, sharedSlotsLoading: $sharedSlotsLoading, unitDates: $unitDates, unitSlotsByMotor: $unitSlotsByMotor, unitSlotsLoading: $unitSlotsLoading, expandedMotorId: $expandedMotorId, allFullSearching: $allFullSearching, allFullNextDate: $allFullNextDate)';
}


}

/// @nodoc
abstract mixin class _$PilihJadwalStateCopyWith<$Res> implements $PilihJadwalStateCopyWith<$Res> {
  factory _$PilihJadwalStateCopyWith(_PilihJadwalState value, $Res Function(_PilihJadwalState) _then) = __$PilihJadwalStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool hasError, Workshop? workshop, Map<String, Motor> motorsById, DateTime? sharedDate, List<TimeSlot> sharedSlots, bool sharedSlotsLoading, Map<String, DateTime> unitDates, Map<String, List<TimeSlot>> unitSlotsByMotor, Set<String> unitSlotsLoading, String? expandedMotorId, bool allFullSearching, DateTime? allFullNextDate
});


@override $WorkshopCopyWith<$Res>? get workshop;

}
/// @nodoc
class __$PilihJadwalStateCopyWithImpl<$Res>
    implements _$PilihJadwalStateCopyWith<$Res> {
  __$PilihJadwalStateCopyWithImpl(this._self, this._then);

  final _PilihJadwalState _self;
  final $Res Function(_PilihJadwalState) _then;

/// Create a copy of PilihJadwalState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? hasError = null,Object? workshop = freezed,Object? motorsById = null,Object? sharedDate = freezed,Object? sharedSlots = null,Object? sharedSlotsLoading = null,Object? unitDates = null,Object? unitSlotsByMotor = null,Object? unitSlotsLoading = null,Object? expandedMotorId = freezed,Object? allFullSearching = null,Object? allFullNextDate = freezed,}) {
  return _then(_PilihJadwalState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,workshop: freezed == workshop ? _self.workshop : workshop // ignore: cast_nullable_to_non_nullable
as Workshop?,motorsById: null == motorsById ? _self._motorsById : motorsById // ignore: cast_nullable_to_non_nullable
as Map<String, Motor>,sharedDate: freezed == sharedDate ? _self.sharedDate : sharedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,sharedSlots: null == sharedSlots ? _self._sharedSlots : sharedSlots // ignore: cast_nullable_to_non_nullable
as List<TimeSlot>,sharedSlotsLoading: null == sharedSlotsLoading ? _self.sharedSlotsLoading : sharedSlotsLoading // ignore: cast_nullable_to_non_nullable
as bool,unitDates: null == unitDates ? _self._unitDates : unitDates // ignore: cast_nullable_to_non_nullable
as Map<String, DateTime>,unitSlotsByMotor: null == unitSlotsByMotor ? _self._unitSlotsByMotor : unitSlotsByMotor // ignore: cast_nullable_to_non_nullable
as Map<String, List<TimeSlot>>,unitSlotsLoading: null == unitSlotsLoading ? _self._unitSlotsLoading : unitSlotsLoading // ignore: cast_nullable_to_non_nullable
as Set<String>,expandedMotorId: freezed == expandedMotorId ? _self.expandedMotorId : expandedMotorId // ignore: cast_nullable_to_non_nullable
as String?,allFullSearching: null == allFullSearching ? _self.allFullSearching : allFullSearching // ignore: cast_nullable_to_non_nullable
as bool,allFullNextDate: freezed == allFullNextDate ? _self.allFullNextDate : allFullNextDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of PilihJadwalState
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
