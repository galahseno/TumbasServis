// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ringkasan_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RingkasanState {

 bool get isLoading; bool get hasError; Workshop? get workshop; Map<String, Motor> get motorsById; Map<String, ServiceType> get serviceById; Map<String, Part> get partById; Voucher? get voucher; String? get removedVoucherId; bool get slotInvalid; String? get slotInvalidTitle; String? get slotInvalidBody; Set<String> get expandedMotorIds; bool get confirming; String? get confirmError; String? get confirmedBookingId;
/// Create a copy of RingkasanState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RingkasanStateCopyWith<RingkasanState> get copyWith => _$RingkasanStateCopyWithImpl<RingkasanState>(this as RingkasanState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RingkasanState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.workshop, workshop) || other.workshop == workshop)&&const DeepCollectionEquality().equals(other.motorsById, motorsById)&&const DeepCollectionEquality().equals(other.serviceById, serviceById)&&const DeepCollectionEquality().equals(other.partById, partById)&&(identical(other.voucher, voucher) || other.voucher == voucher)&&(identical(other.removedVoucherId, removedVoucherId) || other.removedVoucherId == removedVoucherId)&&(identical(other.slotInvalid, slotInvalid) || other.slotInvalid == slotInvalid)&&(identical(other.slotInvalidTitle, slotInvalidTitle) || other.slotInvalidTitle == slotInvalidTitle)&&(identical(other.slotInvalidBody, slotInvalidBody) || other.slotInvalidBody == slotInvalidBody)&&const DeepCollectionEquality().equals(other.expandedMotorIds, expandedMotorIds)&&(identical(other.confirming, confirming) || other.confirming == confirming)&&(identical(other.confirmError, confirmError) || other.confirmError == confirmError)&&(identical(other.confirmedBookingId, confirmedBookingId) || other.confirmedBookingId == confirmedBookingId));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,workshop,const DeepCollectionEquality().hash(motorsById),const DeepCollectionEquality().hash(serviceById),const DeepCollectionEquality().hash(partById),voucher,removedVoucherId,slotInvalid,slotInvalidTitle,slotInvalidBody,const DeepCollectionEquality().hash(expandedMotorIds),confirming,confirmError,confirmedBookingId);

@override
String toString() {
  return 'RingkasanState(isLoading: $isLoading, hasError: $hasError, workshop: $workshop, motorsById: $motorsById, serviceById: $serviceById, partById: $partById, voucher: $voucher, removedVoucherId: $removedVoucherId, slotInvalid: $slotInvalid, slotInvalidTitle: $slotInvalidTitle, slotInvalidBody: $slotInvalidBody, expandedMotorIds: $expandedMotorIds, confirming: $confirming, confirmError: $confirmError, confirmedBookingId: $confirmedBookingId)';
}


}

/// @nodoc
abstract mixin class $RingkasanStateCopyWith<$Res>  {
  factory $RingkasanStateCopyWith(RingkasanState value, $Res Function(RingkasanState) _then) = _$RingkasanStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool hasError, Workshop? workshop, Map<String, Motor> motorsById, Map<String, ServiceType> serviceById, Map<String, Part> partById, Voucher? voucher, String? removedVoucherId, bool slotInvalid, String? slotInvalidTitle, String? slotInvalidBody, Set<String> expandedMotorIds, bool confirming, String? confirmError, String? confirmedBookingId
});


$WorkshopCopyWith<$Res>? get workshop;$VoucherCopyWith<$Res>? get voucher;

}
/// @nodoc
class _$RingkasanStateCopyWithImpl<$Res>
    implements $RingkasanStateCopyWith<$Res> {
  _$RingkasanStateCopyWithImpl(this._self, this._then);

  final RingkasanState _self;
  final $Res Function(RingkasanState) _then;

/// Create a copy of RingkasanState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? hasError = null,Object? workshop = freezed,Object? motorsById = null,Object? serviceById = null,Object? partById = null,Object? voucher = freezed,Object? removedVoucherId = freezed,Object? slotInvalid = null,Object? slotInvalidTitle = freezed,Object? slotInvalidBody = freezed,Object? expandedMotorIds = null,Object? confirming = null,Object? confirmError = freezed,Object? confirmedBookingId = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,workshop: freezed == workshop ? _self.workshop : workshop // ignore: cast_nullable_to_non_nullable
as Workshop?,motorsById: null == motorsById ? _self.motorsById : motorsById // ignore: cast_nullable_to_non_nullable
as Map<String, Motor>,serviceById: null == serviceById ? _self.serviceById : serviceById // ignore: cast_nullable_to_non_nullable
as Map<String, ServiceType>,partById: null == partById ? _self.partById : partById // ignore: cast_nullable_to_non_nullable
as Map<String, Part>,voucher: freezed == voucher ? _self.voucher : voucher // ignore: cast_nullable_to_non_nullable
as Voucher?,removedVoucherId: freezed == removedVoucherId ? _self.removedVoucherId : removedVoucherId // ignore: cast_nullable_to_non_nullable
as String?,slotInvalid: null == slotInvalid ? _self.slotInvalid : slotInvalid // ignore: cast_nullable_to_non_nullable
as bool,slotInvalidTitle: freezed == slotInvalidTitle ? _self.slotInvalidTitle : slotInvalidTitle // ignore: cast_nullable_to_non_nullable
as String?,slotInvalidBody: freezed == slotInvalidBody ? _self.slotInvalidBody : slotInvalidBody // ignore: cast_nullable_to_non_nullable
as String?,expandedMotorIds: null == expandedMotorIds ? _self.expandedMotorIds : expandedMotorIds // ignore: cast_nullable_to_non_nullable
as Set<String>,confirming: null == confirming ? _self.confirming : confirming // ignore: cast_nullable_to_non_nullable
as bool,confirmError: freezed == confirmError ? _self.confirmError : confirmError // ignore: cast_nullable_to_non_nullable
as String?,confirmedBookingId: freezed == confirmedBookingId ? _self.confirmedBookingId : confirmedBookingId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of RingkasanState
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
}/// Create a copy of RingkasanState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VoucherCopyWith<$Res>? get voucher {
    if (_self.voucher == null) {
    return null;
  }

  return $VoucherCopyWith<$Res>(_self.voucher!, (value) {
    return _then(_self.copyWith(voucher: value));
  });
}
}


/// Adds pattern-matching-related methods to [RingkasanState].
extension RingkasanStatePatterns on RingkasanState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RingkasanState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RingkasanState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RingkasanState value)  $default,){
final _that = this;
switch (_that) {
case _RingkasanState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RingkasanState value)?  $default,){
final _that = this;
switch (_that) {
case _RingkasanState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  Workshop? workshop,  Map<String, Motor> motorsById,  Map<String, ServiceType> serviceById,  Map<String, Part> partById,  Voucher? voucher,  String? removedVoucherId,  bool slotInvalid,  String? slotInvalidTitle,  String? slotInvalidBody,  Set<String> expandedMotorIds,  bool confirming,  String? confirmError,  String? confirmedBookingId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RingkasanState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.workshop,_that.motorsById,_that.serviceById,_that.partById,_that.voucher,_that.removedVoucherId,_that.slotInvalid,_that.slotInvalidTitle,_that.slotInvalidBody,_that.expandedMotorIds,_that.confirming,_that.confirmError,_that.confirmedBookingId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  Workshop? workshop,  Map<String, Motor> motorsById,  Map<String, ServiceType> serviceById,  Map<String, Part> partById,  Voucher? voucher,  String? removedVoucherId,  bool slotInvalid,  String? slotInvalidTitle,  String? slotInvalidBody,  Set<String> expandedMotorIds,  bool confirming,  String? confirmError,  String? confirmedBookingId)  $default,) {final _that = this;
switch (_that) {
case _RingkasanState():
return $default(_that.isLoading,_that.hasError,_that.workshop,_that.motorsById,_that.serviceById,_that.partById,_that.voucher,_that.removedVoucherId,_that.slotInvalid,_that.slotInvalidTitle,_that.slotInvalidBody,_that.expandedMotorIds,_that.confirming,_that.confirmError,_that.confirmedBookingId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool hasError,  Workshop? workshop,  Map<String, Motor> motorsById,  Map<String, ServiceType> serviceById,  Map<String, Part> partById,  Voucher? voucher,  String? removedVoucherId,  bool slotInvalid,  String? slotInvalidTitle,  String? slotInvalidBody,  Set<String> expandedMotorIds,  bool confirming,  String? confirmError,  String? confirmedBookingId)?  $default,) {final _that = this;
switch (_that) {
case _RingkasanState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.workshop,_that.motorsById,_that.serviceById,_that.partById,_that.voucher,_that.removedVoucherId,_that.slotInvalid,_that.slotInvalidTitle,_that.slotInvalidBody,_that.expandedMotorIds,_that.confirming,_that.confirmError,_that.confirmedBookingId);case _:
  return null;

}
}

}

/// @nodoc


class _RingkasanState implements RingkasanState {
  const _RingkasanState({this.isLoading = true, this.hasError = false, this.workshop, final  Map<String, Motor> motorsById = const <String, Motor>{}, final  Map<String, ServiceType> serviceById = const <String, ServiceType>{}, final  Map<String, Part> partById = const <String, Part>{}, this.voucher, this.removedVoucherId, this.slotInvalid = false, this.slotInvalidTitle, this.slotInvalidBody, final  Set<String> expandedMotorIds = const <String>{}, this.confirming = false, this.confirmError, this.confirmedBookingId}): _motorsById = motorsById,_serviceById = serviceById,_partById = partById,_expandedMotorIds = expandedMotorIds;
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool hasError;
@override final  Workshop? workshop;
 final  Map<String, Motor> _motorsById;
@override@JsonKey() Map<String, Motor> get motorsById {
  if (_motorsById is EqualUnmodifiableMapView) return _motorsById;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_motorsById);
}

 final  Map<String, ServiceType> _serviceById;
@override@JsonKey() Map<String, ServiceType> get serviceById {
  if (_serviceById is EqualUnmodifiableMapView) return _serviceById;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_serviceById);
}

 final  Map<String, Part> _partById;
@override@JsonKey() Map<String, Part> get partById {
  if (_partById is EqualUnmodifiableMapView) return _partById;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_partById);
}

@override final  Voucher? voucher;
@override final  String? removedVoucherId;
@override@JsonKey() final  bool slotInvalid;
@override final  String? slotInvalidTitle;
@override final  String? slotInvalidBody;
 final  Set<String> _expandedMotorIds;
@override@JsonKey() Set<String> get expandedMotorIds {
  if (_expandedMotorIds is EqualUnmodifiableSetView) return _expandedMotorIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_expandedMotorIds);
}

@override@JsonKey() final  bool confirming;
@override final  String? confirmError;
@override final  String? confirmedBookingId;

/// Create a copy of RingkasanState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RingkasanStateCopyWith<_RingkasanState> get copyWith => __$RingkasanStateCopyWithImpl<_RingkasanState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RingkasanState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.workshop, workshop) || other.workshop == workshop)&&const DeepCollectionEquality().equals(other._motorsById, _motorsById)&&const DeepCollectionEquality().equals(other._serviceById, _serviceById)&&const DeepCollectionEquality().equals(other._partById, _partById)&&(identical(other.voucher, voucher) || other.voucher == voucher)&&(identical(other.removedVoucherId, removedVoucherId) || other.removedVoucherId == removedVoucherId)&&(identical(other.slotInvalid, slotInvalid) || other.slotInvalid == slotInvalid)&&(identical(other.slotInvalidTitle, slotInvalidTitle) || other.slotInvalidTitle == slotInvalidTitle)&&(identical(other.slotInvalidBody, slotInvalidBody) || other.slotInvalidBody == slotInvalidBody)&&const DeepCollectionEquality().equals(other._expandedMotorIds, _expandedMotorIds)&&(identical(other.confirming, confirming) || other.confirming == confirming)&&(identical(other.confirmError, confirmError) || other.confirmError == confirmError)&&(identical(other.confirmedBookingId, confirmedBookingId) || other.confirmedBookingId == confirmedBookingId));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,workshop,const DeepCollectionEquality().hash(_motorsById),const DeepCollectionEquality().hash(_serviceById),const DeepCollectionEquality().hash(_partById),voucher,removedVoucherId,slotInvalid,slotInvalidTitle,slotInvalidBody,const DeepCollectionEquality().hash(_expandedMotorIds),confirming,confirmError,confirmedBookingId);

@override
String toString() {
  return 'RingkasanState(isLoading: $isLoading, hasError: $hasError, workshop: $workshop, motorsById: $motorsById, serviceById: $serviceById, partById: $partById, voucher: $voucher, removedVoucherId: $removedVoucherId, slotInvalid: $slotInvalid, slotInvalidTitle: $slotInvalidTitle, slotInvalidBody: $slotInvalidBody, expandedMotorIds: $expandedMotorIds, confirming: $confirming, confirmError: $confirmError, confirmedBookingId: $confirmedBookingId)';
}


}

/// @nodoc
abstract mixin class _$RingkasanStateCopyWith<$Res> implements $RingkasanStateCopyWith<$Res> {
  factory _$RingkasanStateCopyWith(_RingkasanState value, $Res Function(_RingkasanState) _then) = __$RingkasanStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool hasError, Workshop? workshop, Map<String, Motor> motorsById, Map<String, ServiceType> serviceById, Map<String, Part> partById, Voucher? voucher, String? removedVoucherId, bool slotInvalid, String? slotInvalidTitle, String? slotInvalidBody, Set<String> expandedMotorIds, bool confirming, String? confirmError, String? confirmedBookingId
});


@override $WorkshopCopyWith<$Res>? get workshop;@override $VoucherCopyWith<$Res>? get voucher;

}
/// @nodoc
class __$RingkasanStateCopyWithImpl<$Res>
    implements _$RingkasanStateCopyWith<$Res> {
  __$RingkasanStateCopyWithImpl(this._self, this._then);

  final _RingkasanState _self;
  final $Res Function(_RingkasanState) _then;

/// Create a copy of RingkasanState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? hasError = null,Object? workshop = freezed,Object? motorsById = null,Object? serviceById = null,Object? partById = null,Object? voucher = freezed,Object? removedVoucherId = freezed,Object? slotInvalid = null,Object? slotInvalidTitle = freezed,Object? slotInvalidBody = freezed,Object? expandedMotorIds = null,Object? confirming = null,Object? confirmError = freezed,Object? confirmedBookingId = freezed,}) {
  return _then(_RingkasanState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,workshop: freezed == workshop ? _self.workshop : workshop // ignore: cast_nullable_to_non_nullable
as Workshop?,motorsById: null == motorsById ? _self._motorsById : motorsById // ignore: cast_nullable_to_non_nullable
as Map<String, Motor>,serviceById: null == serviceById ? _self._serviceById : serviceById // ignore: cast_nullable_to_non_nullable
as Map<String, ServiceType>,partById: null == partById ? _self._partById : partById // ignore: cast_nullable_to_non_nullable
as Map<String, Part>,voucher: freezed == voucher ? _self.voucher : voucher // ignore: cast_nullable_to_non_nullable
as Voucher?,removedVoucherId: freezed == removedVoucherId ? _self.removedVoucherId : removedVoucherId // ignore: cast_nullable_to_non_nullable
as String?,slotInvalid: null == slotInvalid ? _self.slotInvalid : slotInvalid // ignore: cast_nullable_to_non_nullable
as bool,slotInvalidTitle: freezed == slotInvalidTitle ? _self.slotInvalidTitle : slotInvalidTitle // ignore: cast_nullable_to_non_nullable
as String?,slotInvalidBody: freezed == slotInvalidBody ? _self.slotInvalidBody : slotInvalidBody // ignore: cast_nullable_to_non_nullable
as String?,expandedMotorIds: null == expandedMotorIds ? _self._expandedMotorIds : expandedMotorIds // ignore: cast_nullable_to_non_nullable
as Set<String>,confirming: null == confirming ? _self.confirming : confirming // ignore: cast_nullable_to_non_nullable
as bool,confirmError: freezed == confirmError ? _self.confirmError : confirmError // ignore: cast_nullable_to_non_nullable
as String?,confirmedBookingId: freezed == confirmedBookingId ? _self.confirmedBookingId : confirmedBookingId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of RingkasanState
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
}/// Create a copy of RingkasanState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VoucherCopyWith<$Res>? get voucher {
    if (_self.voucher == null) {
    return null;
  }

  return $VoucherCopyWith<$Res>(_self.voucher!, (value) {
    return _then(_self.copyWith(voucher: value));
  });
}
}

// dart format on
