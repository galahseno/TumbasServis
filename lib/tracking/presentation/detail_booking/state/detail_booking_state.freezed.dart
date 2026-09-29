// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'detail_booking_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DetailBookingState {

 bool get isLoading; bool get hasError; Booking? get booking; String get workshopName; int get bayCount; Map<String, String> get unitMeta; bool get invoicePaid; bool get hasReview; bool get isMutating;
/// Create a copy of DetailBookingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DetailBookingStateCopyWith<DetailBookingState> get copyWith => _$DetailBookingStateCopyWithImpl<DetailBookingState>(this as DetailBookingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DetailBookingState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.booking, booking) || other.booking == booking)&&(identical(other.workshopName, workshopName) || other.workshopName == workshopName)&&(identical(other.bayCount, bayCount) || other.bayCount == bayCount)&&const DeepCollectionEquality().equals(other.unitMeta, unitMeta)&&(identical(other.invoicePaid, invoicePaid) || other.invoicePaid == invoicePaid)&&(identical(other.hasReview, hasReview) || other.hasReview == hasReview)&&(identical(other.isMutating, isMutating) || other.isMutating == isMutating));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,booking,workshopName,bayCount,const DeepCollectionEquality().hash(unitMeta),invoicePaid,hasReview,isMutating);

@override
String toString() {
  return 'DetailBookingState(isLoading: $isLoading, hasError: $hasError, booking: $booking, workshopName: $workshopName, bayCount: $bayCount, unitMeta: $unitMeta, invoicePaid: $invoicePaid, hasReview: $hasReview, isMutating: $isMutating)';
}


}

/// @nodoc
abstract mixin class $DetailBookingStateCopyWith<$Res>  {
  factory $DetailBookingStateCopyWith(DetailBookingState value, $Res Function(DetailBookingState) _then) = _$DetailBookingStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool hasError, Booking? booking, String workshopName, int bayCount, Map<String, String> unitMeta, bool invoicePaid, bool hasReview, bool isMutating
});


$BookingCopyWith<$Res>? get booking;

}
/// @nodoc
class _$DetailBookingStateCopyWithImpl<$Res>
    implements $DetailBookingStateCopyWith<$Res> {
  _$DetailBookingStateCopyWithImpl(this._self, this._then);

  final DetailBookingState _self;
  final $Res Function(DetailBookingState) _then;

/// Create a copy of DetailBookingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? hasError = null,Object? booking = freezed,Object? workshopName = null,Object? bayCount = null,Object? unitMeta = null,Object? invoicePaid = null,Object? hasReview = null,Object? isMutating = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,booking: freezed == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as Booking?,workshopName: null == workshopName ? _self.workshopName : workshopName // ignore: cast_nullable_to_non_nullable
as String,bayCount: null == bayCount ? _self.bayCount : bayCount // ignore: cast_nullable_to_non_nullable
as int,unitMeta: null == unitMeta ? _self.unitMeta : unitMeta // ignore: cast_nullable_to_non_nullable
as Map<String, String>,invoicePaid: null == invoicePaid ? _self.invoicePaid : invoicePaid // ignore: cast_nullable_to_non_nullable
as bool,hasReview: null == hasReview ? _self.hasReview : hasReview // ignore: cast_nullable_to_non_nullable
as bool,isMutating: null == isMutating ? _self.isMutating : isMutating // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of DetailBookingState
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
}
}


/// Adds pattern-matching-related methods to [DetailBookingState].
extension DetailBookingStatePatterns on DetailBookingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DetailBookingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DetailBookingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DetailBookingState value)  $default,){
final _that = this;
switch (_that) {
case _DetailBookingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DetailBookingState value)?  $default,){
final _that = this;
switch (_that) {
case _DetailBookingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  Booking? booking,  String workshopName,  int bayCount,  Map<String, String> unitMeta,  bool invoicePaid,  bool hasReview,  bool isMutating)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DetailBookingState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.booking,_that.workshopName,_that.bayCount,_that.unitMeta,_that.invoicePaid,_that.hasReview,_that.isMutating);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  Booking? booking,  String workshopName,  int bayCount,  Map<String, String> unitMeta,  bool invoicePaid,  bool hasReview,  bool isMutating)  $default,) {final _that = this;
switch (_that) {
case _DetailBookingState():
return $default(_that.isLoading,_that.hasError,_that.booking,_that.workshopName,_that.bayCount,_that.unitMeta,_that.invoicePaid,_that.hasReview,_that.isMutating);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool hasError,  Booking? booking,  String workshopName,  int bayCount,  Map<String, String> unitMeta,  bool invoicePaid,  bool hasReview,  bool isMutating)?  $default,) {final _that = this;
switch (_that) {
case _DetailBookingState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.booking,_that.workshopName,_that.bayCount,_that.unitMeta,_that.invoicePaid,_that.hasReview,_that.isMutating);case _:
  return null;

}
}

}

/// @nodoc


class _DetailBookingState extends DetailBookingState {
  const _DetailBookingState({this.isLoading = true, this.hasError = false, this.booking, this.workshopName = '', this.bayCount = 0, final  Map<String, String> unitMeta = const <String, String>{}, this.invoicePaid = false, this.hasReview = false, this.isMutating = false}): _unitMeta = unitMeta,super._();
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool hasError;
@override final  Booking? booking;
@override@JsonKey() final  String workshopName;
@override@JsonKey() final  int bayCount;
 final  Map<String, String> _unitMeta;
@override@JsonKey() Map<String, String> get unitMeta {
  if (_unitMeta is EqualUnmodifiableMapView) return _unitMeta;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_unitMeta);
}

@override@JsonKey() final  bool invoicePaid;
@override@JsonKey() final  bool hasReview;
@override@JsonKey() final  bool isMutating;

/// Create a copy of DetailBookingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DetailBookingStateCopyWith<_DetailBookingState> get copyWith => __$DetailBookingStateCopyWithImpl<_DetailBookingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DetailBookingState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.booking, booking) || other.booking == booking)&&(identical(other.workshopName, workshopName) || other.workshopName == workshopName)&&(identical(other.bayCount, bayCount) || other.bayCount == bayCount)&&const DeepCollectionEquality().equals(other._unitMeta, _unitMeta)&&(identical(other.invoicePaid, invoicePaid) || other.invoicePaid == invoicePaid)&&(identical(other.hasReview, hasReview) || other.hasReview == hasReview)&&(identical(other.isMutating, isMutating) || other.isMutating == isMutating));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,booking,workshopName,bayCount,const DeepCollectionEquality().hash(_unitMeta),invoicePaid,hasReview,isMutating);

@override
String toString() {
  return 'DetailBookingState(isLoading: $isLoading, hasError: $hasError, booking: $booking, workshopName: $workshopName, bayCount: $bayCount, unitMeta: $unitMeta, invoicePaid: $invoicePaid, hasReview: $hasReview, isMutating: $isMutating)';
}


}

/// @nodoc
abstract mixin class _$DetailBookingStateCopyWith<$Res> implements $DetailBookingStateCopyWith<$Res> {
  factory _$DetailBookingStateCopyWith(_DetailBookingState value, $Res Function(_DetailBookingState) _then) = __$DetailBookingStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool hasError, Booking? booking, String workshopName, int bayCount, Map<String, String> unitMeta, bool invoicePaid, bool hasReview, bool isMutating
});


@override $BookingCopyWith<$Res>? get booking;

}
/// @nodoc
class __$DetailBookingStateCopyWithImpl<$Res>
    implements _$DetailBookingStateCopyWith<$Res> {
  __$DetailBookingStateCopyWithImpl(this._self, this._then);

  final _DetailBookingState _self;
  final $Res Function(_DetailBookingState) _then;

/// Create a copy of DetailBookingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? hasError = null,Object? booking = freezed,Object? workshopName = null,Object? bayCount = null,Object? unitMeta = null,Object? invoicePaid = null,Object? hasReview = null,Object? isMutating = null,}) {
  return _then(_DetailBookingState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,booking: freezed == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as Booking?,workshopName: null == workshopName ? _self.workshopName : workshopName // ignore: cast_nullable_to_non_nullable
as String,bayCount: null == bayCount ? _self.bayCount : bayCount // ignore: cast_nullable_to_non_nullable
as int,unitMeta: null == unitMeta ? _self._unitMeta : unitMeta // ignore: cast_nullable_to_non_nullable
as Map<String, String>,invoicePaid: null == invoicePaid ? _self.invoicePaid : invoicePaid // ignore: cast_nullable_to_non_nullable
as bool,hasReview: null == hasReview ? _self.hasReview : hasReview // ignore: cast_nullable_to_non_nullable
as bool,isMutating: null == isMutating ? _self.isMutating : isMutating // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of DetailBookingState
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
}
}

// dart format on
