// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InvoiceState {

 bool get isLoading; bool get hasError; Invoice? get invoice; Booking? get booking; String get workshopName; String get workshopAddress; String? get voucherCode; bool get hasReview; bool get isMarking; bool get markFailed;
/// Create a copy of InvoiceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoiceStateCopyWith<InvoiceState> get copyWith => _$InvoiceStateCopyWithImpl<InvoiceState>(this as InvoiceState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoiceState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.invoice, invoice) || other.invoice == invoice)&&(identical(other.booking, booking) || other.booking == booking)&&(identical(other.workshopName, workshopName) || other.workshopName == workshopName)&&(identical(other.workshopAddress, workshopAddress) || other.workshopAddress == workshopAddress)&&(identical(other.voucherCode, voucherCode) || other.voucherCode == voucherCode)&&(identical(other.hasReview, hasReview) || other.hasReview == hasReview)&&(identical(other.isMarking, isMarking) || other.isMarking == isMarking)&&(identical(other.markFailed, markFailed) || other.markFailed == markFailed));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,invoice,booking,workshopName,workshopAddress,voucherCode,hasReview,isMarking,markFailed);

@override
String toString() {
  return 'InvoiceState(isLoading: $isLoading, hasError: $hasError, invoice: $invoice, booking: $booking, workshopName: $workshopName, workshopAddress: $workshopAddress, voucherCode: $voucherCode, hasReview: $hasReview, isMarking: $isMarking, markFailed: $markFailed)';
}


}

/// @nodoc
abstract mixin class $InvoiceStateCopyWith<$Res>  {
  factory $InvoiceStateCopyWith(InvoiceState value, $Res Function(InvoiceState) _then) = _$InvoiceStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool hasError, Invoice? invoice, Booking? booking, String workshopName, String workshopAddress, String? voucherCode, bool hasReview, bool isMarking, bool markFailed
});


$InvoiceCopyWith<$Res>? get invoice;$BookingCopyWith<$Res>? get booking;

}
/// @nodoc
class _$InvoiceStateCopyWithImpl<$Res>
    implements $InvoiceStateCopyWith<$Res> {
  _$InvoiceStateCopyWithImpl(this._self, this._then);

  final InvoiceState _self;
  final $Res Function(InvoiceState) _then;

/// Create a copy of InvoiceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? hasError = null,Object? invoice = freezed,Object? booking = freezed,Object? workshopName = null,Object? workshopAddress = null,Object? voucherCode = freezed,Object? hasReview = null,Object? isMarking = null,Object? markFailed = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,invoice: freezed == invoice ? _self.invoice : invoice // ignore: cast_nullable_to_non_nullable
as Invoice?,booking: freezed == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as Booking?,workshopName: null == workshopName ? _self.workshopName : workshopName // ignore: cast_nullable_to_non_nullable
as String,workshopAddress: null == workshopAddress ? _self.workshopAddress : workshopAddress // ignore: cast_nullable_to_non_nullable
as String,voucherCode: freezed == voucherCode ? _self.voucherCode : voucherCode // ignore: cast_nullable_to_non_nullable
as String?,hasReview: null == hasReview ? _self.hasReview : hasReview // ignore: cast_nullable_to_non_nullable
as bool,isMarking: null == isMarking ? _self.isMarking : isMarking // ignore: cast_nullable_to_non_nullable
as bool,markFailed: null == markFailed ? _self.markFailed : markFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of InvoiceState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InvoiceCopyWith<$Res>? get invoice {
    if (_self.invoice == null) {
    return null;
  }

  return $InvoiceCopyWith<$Res>(_self.invoice!, (value) {
    return _then(_self.copyWith(invoice: value));
  });
}/// Create a copy of InvoiceState
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


/// Adds pattern-matching-related methods to [InvoiceState].
extension InvoiceStatePatterns on InvoiceState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvoiceState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvoiceState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvoiceState value)  $default,){
final _that = this;
switch (_that) {
case _InvoiceState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvoiceState value)?  $default,){
final _that = this;
switch (_that) {
case _InvoiceState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  Invoice? invoice,  Booking? booking,  String workshopName,  String workshopAddress,  String? voucherCode,  bool hasReview,  bool isMarking,  bool markFailed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvoiceState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.invoice,_that.booking,_that.workshopName,_that.workshopAddress,_that.voucherCode,_that.hasReview,_that.isMarking,_that.markFailed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  Invoice? invoice,  Booking? booking,  String workshopName,  String workshopAddress,  String? voucherCode,  bool hasReview,  bool isMarking,  bool markFailed)  $default,) {final _that = this;
switch (_that) {
case _InvoiceState():
return $default(_that.isLoading,_that.hasError,_that.invoice,_that.booking,_that.workshopName,_that.workshopAddress,_that.voucherCode,_that.hasReview,_that.isMarking,_that.markFailed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool hasError,  Invoice? invoice,  Booking? booking,  String workshopName,  String workshopAddress,  String? voucherCode,  bool hasReview,  bool isMarking,  bool markFailed)?  $default,) {final _that = this;
switch (_that) {
case _InvoiceState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.invoice,_that.booking,_that.workshopName,_that.workshopAddress,_that.voucherCode,_that.hasReview,_that.isMarking,_that.markFailed);case _:
  return null;

}
}

}

/// @nodoc


class _InvoiceState extends InvoiceState {
  const _InvoiceState({this.isLoading = true, this.hasError = false, this.invoice, this.booking, this.workshopName = '', this.workshopAddress = '', this.voucherCode, this.hasReview = false, this.isMarking = false, this.markFailed = false}): super._();
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool hasError;
@override final  Invoice? invoice;
@override final  Booking? booking;
@override@JsonKey() final  String workshopName;
@override@JsonKey() final  String workshopAddress;
@override final  String? voucherCode;
@override@JsonKey() final  bool hasReview;
@override@JsonKey() final  bool isMarking;
@override@JsonKey() final  bool markFailed;

/// Create a copy of InvoiceState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoiceStateCopyWith<_InvoiceState> get copyWith => __$InvoiceStateCopyWithImpl<_InvoiceState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvoiceState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.invoice, invoice) || other.invoice == invoice)&&(identical(other.booking, booking) || other.booking == booking)&&(identical(other.workshopName, workshopName) || other.workshopName == workshopName)&&(identical(other.workshopAddress, workshopAddress) || other.workshopAddress == workshopAddress)&&(identical(other.voucherCode, voucherCode) || other.voucherCode == voucherCode)&&(identical(other.hasReview, hasReview) || other.hasReview == hasReview)&&(identical(other.isMarking, isMarking) || other.isMarking == isMarking)&&(identical(other.markFailed, markFailed) || other.markFailed == markFailed));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,invoice,booking,workshopName,workshopAddress,voucherCode,hasReview,isMarking,markFailed);

@override
String toString() {
  return 'InvoiceState(isLoading: $isLoading, hasError: $hasError, invoice: $invoice, booking: $booking, workshopName: $workshopName, workshopAddress: $workshopAddress, voucherCode: $voucherCode, hasReview: $hasReview, isMarking: $isMarking, markFailed: $markFailed)';
}


}

/// @nodoc
abstract mixin class _$InvoiceStateCopyWith<$Res> implements $InvoiceStateCopyWith<$Res> {
  factory _$InvoiceStateCopyWith(_InvoiceState value, $Res Function(_InvoiceState) _then) = __$InvoiceStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool hasError, Invoice? invoice, Booking? booking, String workshopName, String workshopAddress, String? voucherCode, bool hasReview, bool isMarking, bool markFailed
});


@override $InvoiceCopyWith<$Res>? get invoice;@override $BookingCopyWith<$Res>? get booking;

}
/// @nodoc
class __$InvoiceStateCopyWithImpl<$Res>
    implements _$InvoiceStateCopyWith<$Res> {
  __$InvoiceStateCopyWithImpl(this._self, this._then);

  final _InvoiceState _self;
  final $Res Function(_InvoiceState) _then;

/// Create a copy of InvoiceState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? hasError = null,Object? invoice = freezed,Object? booking = freezed,Object? workshopName = null,Object? workshopAddress = null,Object? voucherCode = freezed,Object? hasReview = null,Object? isMarking = null,Object? markFailed = null,}) {
  return _then(_InvoiceState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,invoice: freezed == invoice ? _self.invoice : invoice // ignore: cast_nullable_to_non_nullable
as Invoice?,booking: freezed == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as Booking?,workshopName: null == workshopName ? _self.workshopName : workshopName // ignore: cast_nullable_to_non_nullable
as String,workshopAddress: null == workshopAddress ? _self.workshopAddress : workshopAddress // ignore: cast_nullable_to_non_nullable
as String,voucherCode: freezed == voucherCode ? _self.voucherCode : voucherCode // ignore: cast_nullable_to_non_nullable
as String?,hasReview: null == hasReview ? _self.hasReview : hasReview // ignore: cast_nullable_to_non_nullable
as bool,isMarking: null == isMarking ? _self.isMarking : isMarking // ignore: cast_nullable_to_non_nullable
as bool,markFailed: null == markFailed ? _self.markFailed : markFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of InvoiceState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InvoiceCopyWith<$Res>? get invoice {
    if (_self.invoice == null) {
    return null;
  }

  return $InvoiceCopyWith<$Res>(_self.invoice!, (value) {
    return _then(_self.copyWith(invoice: value));
  });
}/// Create a copy of InvoiceState
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
