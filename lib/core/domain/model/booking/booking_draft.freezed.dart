// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UnitConfig {

 List<String> get serviceIds; List<String> get partIds; String? get complaintNote;
/// Create a copy of UnitConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnitConfigCopyWith<UnitConfig> get copyWith => _$UnitConfigCopyWithImpl<UnitConfig>(this as UnitConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnitConfig&&const DeepCollectionEquality().equals(other.serviceIds, serviceIds)&&const DeepCollectionEquality().equals(other.partIds, partIds)&&(identical(other.complaintNote, complaintNote) || other.complaintNote == complaintNote));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(serviceIds),const DeepCollectionEquality().hash(partIds),complaintNote);

@override
String toString() {
  return 'UnitConfig(serviceIds: $serviceIds, partIds: $partIds, complaintNote: $complaintNote)';
}


}

/// @nodoc
abstract mixin class $UnitConfigCopyWith<$Res>  {
  factory $UnitConfigCopyWith(UnitConfig value, $Res Function(UnitConfig) _then) = _$UnitConfigCopyWithImpl;
@useResult
$Res call({
 List<String> serviceIds, List<String> partIds, String? complaintNote
});




}
/// @nodoc
class _$UnitConfigCopyWithImpl<$Res>
    implements $UnitConfigCopyWith<$Res> {
  _$UnitConfigCopyWithImpl(this._self, this._then);

  final UnitConfig _self;
  final $Res Function(UnitConfig) _then;

/// Create a copy of UnitConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serviceIds = null,Object? partIds = null,Object? complaintNote = freezed,}) {
  return _then(_self.copyWith(
serviceIds: null == serviceIds ? _self.serviceIds : serviceIds // ignore: cast_nullable_to_non_nullable
as List<String>,partIds: null == partIds ? _self.partIds : partIds // ignore: cast_nullable_to_non_nullable
as List<String>,complaintNote: freezed == complaintNote ? _self.complaintNote : complaintNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UnitConfig].
extension UnitConfigPatterns on UnitConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnitConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnitConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnitConfig value)  $default,){
final _that = this;
switch (_that) {
case _UnitConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnitConfig value)?  $default,){
final _that = this;
switch (_that) {
case _UnitConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> serviceIds,  List<String> partIds,  String? complaintNote)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnitConfig() when $default != null:
return $default(_that.serviceIds,_that.partIds,_that.complaintNote);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> serviceIds,  List<String> partIds,  String? complaintNote)  $default,) {final _that = this;
switch (_that) {
case _UnitConfig():
return $default(_that.serviceIds,_that.partIds,_that.complaintNote);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> serviceIds,  List<String> partIds,  String? complaintNote)?  $default,) {final _that = this;
switch (_that) {
case _UnitConfig() when $default != null:
return $default(_that.serviceIds,_that.partIds,_that.complaintNote);case _:
  return null;

}
}

}

/// @nodoc


class _UnitConfig extends UnitConfig {
  const _UnitConfig({required final  List<String> serviceIds, required final  List<String> partIds, this.complaintNote}): _serviceIds = serviceIds,_partIds = partIds,super._();
  

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

/// Create a copy of UnitConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnitConfigCopyWith<_UnitConfig> get copyWith => __$UnitConfigCopyWithImpl<_UnitConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnitConfig&&const DeepCollectionEquality().equals(other._serviceIds, _serviceIds)&&const DeepCollectionEquality().equals(other._partIds, _partIds)&&(identical(other.complaintNote, complaintNote) || other.complaintNote == complaintNote));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_serviceIds),const DeepCollectionEquality().hash(_partIds),complaintNote);

@override
String toString() {
  return 'UnitConfig(serviceIds: $serviceIds, partIds: $partIds, complaintNote: $complaintNote)';
}


}

/// @nodoc
abstract mixin class _$UnitConfigCopyWith<$Res> implements $UnitConfigCopyWith<$Res> {
  factory _$UnitConfigCopyWith(_UnitConfig value, $Res Function(_UnitConfig) _then) = __$UnitConfigCopyWithImpl;
@override @useResult
$Res call({
 List<String> serviceIds, List<String> partIds, String? complaintNote
});




}
/// @nodoc
class __$UnitConfigCopyWithImpl<$Res>
    implements _$UnitConfigCopyWith<$Res> {
  __$UnitConfigCopyWithImpl(this._self, this._then);

  final _UnitConfig _self;
  final $Res Function(_UnitConfig) _then;

/// Create a copy of UnitConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serviceIds = null,Object? partIds = null,Object? complaintNote = freezed,}) {
  return _then(_UnitConfig(
serviceIds: null == serviceIds ? _self._serviceIds : serviceIds // ignore: cast_nullable_to_non_nullable
as List<String>,partIds: null == partIds ? _self._partIds : partIds // ignore: cast_nullable_to_non_nullable
as List<String>,complaintNote: freezed == complaintNote ? _self.complaintNote : complaintNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$BookingDraft {

 String get id; List<String> get selectedMotorIds; Map<String, UnitConfig> get unitConfigs; String? get workshopId; ScheduleMode get scheduleMode; TimeSlot? get sharedSlot; Map<String, TimeSlot> get unitSlots; String? get voucherId; DateTime get createdAt; DateTime get expiresAt;
/// Create a copy of BookingDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingDraftCopyWith<BookingDraft> get copyWith => _$BookingDraftCopyWithImpl<BookingDraft>(this as BookingDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingDraft&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.selectedMotorIds, selectedMotorIds)&&const DeepCollectionEquality().equals(other.unitConfigs, unitConfigs)&&(identical(other.workshopId, workshopId) || other.workshopId == workshopId)&&(identical(other.scheduleMode, scheduleMode) || other.scheduleMode == scheduleMode)&&(identical(other.sharedSlot, sharedSlot) || other.sharedSlot == sharedSlot)&&const DeepCollectionEquality().equals(other.unitSlots, unitSlots)&&(identical(other.voucherId, voucherId) || other.voucherId == voucherId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(selectedMotorIds),const DeepCollectionEquality().hash(unitConfigs),workshopId,scheduleMode,sharedSlot,const DeepCollectionEquality().hash(unitSlots),voucherId,createdAt,expiresAt);

@override
String toString() {
  return 'BookingDraft(id: $id, selectedMotorIds: $selectedMotorIds, unitConfigs: $unitConfigs, workshopId: $workshopId, scheduleMode: $scheduleMode, sharedSlot: $sharedSlot, unitSlots: $unitSlots, voucherId: $voucherId, createdAt: $createdAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $BookingDraftCopyWith<$Res>  {
  factory $BookingDraftCopyWith(BookingDraft value, $Res Function(BookingDraft) _then) = _$BookingDraftCopyWithImpl;
@useResult
$Res call({
 String id, List<String> selectedMotorIds, Map<String, UnitConfig> unitConfigs, String? workshopId, ScheduleMode scheduleMode, TimeSlot? sharedSlot, Map<String, TimeSlot> unitSlots, String? voucherId, DateTime createdAt, DateTime expiresAt
});


$TimeSlotCopyWith<$Res>? get sharedSlot;

}
/// @nodoc
class _$BookingDraftCopyWithImpl<$Res>
    implements $BookingDraftCopyWith<$Res> {
  _$BookingDraftCopyWithImpl(this._self, this._then);

  final BookingDraft _self;
  final $Res Function(BookingDraft) _then;

/// Create a copy of BookingDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? selectedMotorIds = null,Object? unitConfigs = null,Object? workshopId = freezed,Object? scheduleMode = null,Object? sharedSlot = freezed,Object? unitSlots = null,Object? voucherId = freezed,Object? createdAt = null,Object? expiresAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,selectedMotorIds: null == selectedMotorIds ? _self.selectedMotorIds : selectedMotorIds // ignore: cast_nullable_to_non_nullable
as List<String>,unitConfigs: null == unitConfigs ? _self.unitConfigs : unitConfigs // ignore: cast_nullable_to_non_nullable
as Map<String, UnitConfig>,workshopId: freezed == workshopId ? _self.workshopId : workshopId // ignore: cast_nullable_to_non_nullable
as String?,scheduleMode: null == scheduleMode ? _self.scheduleMode : scheduleMode // ignore: cast_nullable_to_non_nullable
as ScheduleMode,sharedSlot: freezed == sharedSlot ? _self.sharedSlot : sharedSlot // ignore: cast_nullable_to_non_nullable
as TimeSlot?,unitSlots: null == unitSlots ? _self.unitSlots : unitSlots // ignore: cast_nullable_to_non_nullable
as Map<String, TimeSlot>,voucherId: freezed == voucherId ? _self.voucherId : voucherId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of BookingDraft
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


/// Adds pattern-matching-related methods to [BookingDraft].
extension BookingDraftPatterns on BookingDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingDraft value)  $default,){
final _that = this;
switch (_that) {
case _BookingDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingDraft value)?  $default,){
final _that = this;
switch (_that) {
case _BookingDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  List<String> selectedMotorIds,  Map<String, UnitConfig> unitConfigs,  String? workshopId,  ScheduleMode scheduleMode,  TimeSlot? sharedSlot,  Map<String, TimeSlot> unitSlots,  String? voucherId,  DateTime createdAt,  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingDraft() when $default != null:
return $default(_that.id,_that.selectedMotorIds,_that.unitConfigs,_that.workshopId,_that.scheduleMode,_that.sharedSlot,_that.unitSlots,_that.voucherId,_that.createdAt,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  List<String> selectedMotorIds,  Map<String, UnitConfig> unitConfigs,  String? workshopId,  ScheduleMode scheduleMode,  TimeSlot? sharedSlot,  Map<String, TimeSlot> unitSlots,  String? voucherId,  DateTime createdAt,  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _BookingDraft():
return $default(_that.id,_that.selectedMotorIds,_that.unitConfigs,_that.workshopId,_that.scheduleMode,_that.sharedSlot,_that.unitSlots,_that.voucherId,_that.createdAt,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  List<String> selectedMotorIds,  Map<String, UnitConfig> unitConfigs,  String? workshopId,  ScheduleMode scheduleMode,  TimeSlot? sharedSlot,  Map<String, TimeSlot> unitSlots,  String? voucherId,  DateTime createdAt,  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _BookingDraft() when $default != null:
return $default(_that.id,_that.selectedMotorIds,_that.unitConfigs,_that.workshopId,_that.scheduleMode,_that.sharedSlot,_that.unitSlots,_that.voucherId,_that.createdAt,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc


class _BookingDraft implements BookingDraft {
  const _BookingDraft({required this.id, required final  List<String> selectedMotorIds, required final  Map<String, UnitConfig> unitConfigs, this.workshopId, required this.scheduleMode, this.sharedSlot, required final  Map<String, TimeSlot> unitSlots, this.voucherId, required this.createdAt, required this.expiresAt}): _selectedMotorIds = selectedMotorIds,_unitConfigs = unitConfigs,_unitSlots = unitSlots;
  

@override final  String id;
 final  List<String> _selectedMotorIds;
@override List<String> get selectedMotorIds {
  if (_selectedMotorIds is EqualUnmodifiableListView) return _selectedMotorIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedMotorIds);
}

 final  Map<String, UnitConfig> _unitConfigs;
@override Map<String, UnitConfig> get unitConfigs {
  if (_unitConfigs is EqualUnmodifiableMapView) return _unitConfigs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_unitConfigs);
}

@override final  String? workshopId;
@override final  ScheduleMode scheduleMode;
@override final  TimeSlot? sharedSlot;
 final  Map<String, TimeSlot> _unitSlots;
@override Map<String, TimeSlot> get unitSlots {
  if (_unitSlots is EqualUnmodifiableMapView) return _unitSlots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_unitSlots);
}

@override final  String? voucherId;
@override final  DateTime createdAt;
@override final  DateTime expiresAt;

/// Create a copy of BookingDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingDraftCopyWith<_BookingDraft> get copyWith => __$BookingDraftCopyWithImpl<_BookingDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingDraft&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._selectedMotorIds, _selectedMotorIds)&&const DeepCollectionEquality().equals(other._unitConfigs, _unitConfigs)&&(identical(other.workshopId, workshopId) || other.workshopId == workshopId)&&(identical(other.scheduleMode, scheduleMode) || other.scheduleMode == scheduleMode)&&(identical(other.sharedSlot, sharedSlot) || other.sharedSlot == sharedSlot)&&const DeepCollectionEquality().equals(other._unitSlots, _unitSlots)&&(identical(other.voucherId, voucherId) || other.voucherId == voucherId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_selectedMotorIds),const DeepCollectionEquality().hash(_unitConfigs),workshopId,scheduleMode,sharedSlot,const DeepCollectionEquality().hash(_unitSlots),voucherId,createdAt,expiresAt);

@override
String toString() {
  return 'BookingDraft(id: $id, selectedMotorIds: $selectedMotorIds, unitConfigs: $unitConfigs, workshopId: $workshopId, scheduleMode: $scheduleMode, sharedSlot: $sharedSlot, unitSlots: $unitSlots, voucherId: $voucherId, createdAt: $createdAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$BookingDraftCopyWith<$Res> implements $BookingDraftCopyWith<$Res> {
  factory _$BookingDraftCopyWith(_BookingDraft value, $Res Function(_BookingDraft) _then) = __$BookingDraftCopyWithImpl;
@override @useResult
$Res call({
 String id, List<String> selectedMotorIds, Map<String, UnitConfig> unitConfigs, String? workshopId, ScheduleMode scheduleMode, TimeSlot? sharedSlot, Map<String, TimeSlot> unitSlots, String? voucherId, DateTime createdAt, DateTime expiresAt
});


@override $TimeSlotCopyWith<$Res>? get sharedSlot;

}
/// @nodoc
class __$BookingDraftCopyWithImpl<$Res>
    implements _$BookingDraftCopyWith<$Res> {
  __$BookingDraftCopyWithImpl(this._self, this._then);

  final _BookingDraft _self;
  final $Res Function(_BookingDraft) _then;

/// Create a copy of BookingDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? selectedMotorIds = null,Object? unitConfigs = null,Object? workshopId = freezed,Object? scheduleMode = null,Object? sharedSlot = freezed,Object? unitSlots = null,Object? voucherId = freezed,Object? createdAt = null,Object? expiresAt = null,}) {
  return _then(_BookingDraft(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,selectedMotorIds: null == selectedMotorIds ? _self._selectedMotorIds : selectedMotorIds // ignore: cast_nullable_to_non_nullable
as List<String>,unitConfigs: null == unitConfigs ? _self._unitConfigs : unitConfigs // ignore: cast_nullable_to_non_nullable
as Map<String, UnitConfig>,workshopId: freezed == workshopId ? _self.workshopId : workshopId // ignore: cast_nullable_to_non_nullable
as String?,scheduleMode: null == scheduleMode ? _self.scheduleMode : scheduleMode // ignore: cast_nullable_to_non_nullable
as ScheduleMode,sharedSlot: freezed == sharedSlot ? _self.sharedSlot : sharedSlot // ignore: cast_nullable_to_non_nullable
as TimeSlot?,unitSlots: null == unitSlots ? _self._unitSlots : unitSlots // ignore: cast_nullable_to_non_nullable
as Map<String, TimeSlot>,voucherId: freezed == voucherId ? _self.voucherId : voucherId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of BookingDraft
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
