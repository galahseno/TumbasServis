// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'voucher_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VoucherState {

 bool get isLoading; bool get hasError; List<VoucherOption> get eligible; List<VoucherOption> get ineligible; int get subtotal; String? get appliedVoucherId; String? get pendingVoucherId; bool get applying; bool get applied;
/// Create a copy of VoucherState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VoucherStateCopyWith<VoucherState> get copyWith => _$VoucherStateCopyWithImpl<VoucherState>(this as VoucherState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VoucherState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&const DeepCollectionEquality().equals(other.eligible, eligible)&&const DeepCollectionEquality().equals(other.ineligible, ineligible)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.appliedVoucherId, appliedVoucherId) || other.appliedVoucherId == appliedVoucherId)&&(identical(other.pendingVoucherId, pendingVoucherId) || other.pendingVoucherId == pendingVoucherId)&&(identical(other.applying, applying) || other.applying == applying)&&(identical(other.applied, applied) || other.applied == applied));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,const DeepCollectionEquality().hash(eligible),const DeepCollectionEquality().hash(ineligible),subtotal,appliedVoucherId,pendingVoucherId,applying,applied);

@override
String toString() {
  return 'VoucherState(isLoading: $isLoading, hasError: $hasError, eligible: $eligible, ineligible: $ineligible, subtotal: $subtotal, appliedVoucherId: $appliedVoucherId, pendingVoucherId: $pendingVoucherId, applying: $applying, applied: $applied)';
}


}

/// @nodoc
abstract mixin class $VoucherStateCopyWith<$Res>  {
  factory $VoucherStateCopyWith(VoucherState value, $Res Function(VoucherState) _then) = _$VoucherStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool hasError, List<VoucherOption> eligible, List<VoucherOption> ineligible, int subtotal, String? appliedVoucherId, String? pendingVoucherId, bool applying, bool applied
});




}
/// @nodoc
class _$VoucherStateCopyWithImpl<$Res>
    implements $VoucherStateCopyWith<$Res> {
  _$VoucherStateCopyWithImpl(this._self, this._then);

  final VoucherState _self;
  final $Res Function(VoucherState) _then;

/// Create a copy of VoucherState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? hasError = null,Object? eligible = null,Object? ineligible = null,Object? subtotal = null,Object? appliedVoucherId = freezed,Object? pendingVoucherId = freezed,Object? applying = null,Object? applied = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,eligible: null == eligible ? _self.eligible : eligible // ignore: cast_nullable_to_non_nullable
as List<VoucherOption>,ineligible: null == ineligible ? _self.ineligible : ineligible // ignore: cast_nullable_to_non_nullable
as List<VoucherOption>,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as int,appliedVoucherId: freezed == appliedVoucherId ? _self.appliedVoucherId : appliedVoucherId // ignore: cast_nullable_to_non_nullable
as String?,pendingVoucherId: freezed == pendingVoucherId ? _self.pendingVoucherId : pendingVoucherId // ignore: cast_nullable_to_non_nullable
as String?,applying: null == applying ? _self.applying : applying // ignore: cast_nullable_to_non_nullable
as bool,applied: null == applied ? _self.applied : applied // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [VoucherState].
extension VoucherStatePatterns on VoucherState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VoucherState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VoucherState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VoucherState value)  $default,){
final _that = this;
switch (_that) {
case _VoucherState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VoucherState value)?  $default,){
final _that = this;
switch (_that) {
case _VoucherState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  List<VoucherOption> eligible,  List<VoucherOption> ineligible,  int subtotal,  String? appliedVoucherId,  String? pendingVoucherId,  bool applying,  bool applied)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VoucherState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.eligible,_that.ineligible,_that.subtotal,_that.appliedVoucherId,_that.pendingVoucherId,_that.applying,_that.applied);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  List<VoucherOption> eligible,  List<VoucherOption> ineligible,  int subtotal,  String? appliedVoucherId,  String? pendingVoucherId,  bool applying,  bool applied)  $default,) {final _that = this;
switch (_that) {
case _VoucherState():
return $default(_that.isLoading,_that.hasError,_that.eligible,_that.ineligible,_that.subtotal,_that.appliedVoucherId,_that.pendingVoucherId,_that.applying,_that.applied);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool hasError,  List<VoucherOption> eligible,  List<VoucherOption> ineligible,  int subtotal,  String? appliedVoucherId,  String? pendingVoucherId,  bool applying,  bool applied)?  $default,) {final _that = this;
switch (_that) {
case _VoucherState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.eligible,_that.ineligible,_that.subtotal,_that.appliedVoucherId,_that.pendingVoucherId,_that.applying,_that.applied);case _:
  return null;

}
}

}

/// @nodoc


class _VoucherState implements VoucherState {
  const _VoucherState({this.isLoading = true, this.hasError = false, final  List<VoucherOption> eligible = const <VoucherOption>[], final  List<VoucherOption> ineligible = const <VoucherOption>[], this.subtotal = 0, this.appliedVoucherId, this.pendingVoucherId, this.applying = false, this.applied = false}): _eligible = eligible,_ineligible = ineligible;
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool hasError;
 final  List<VoucherOption> _eligible;
@override@JsonKey() List<VoucherOption> get eligible {
  if (_eligible is EqualUnmodifiableListView) return _eligible;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_eligible);
}

 final  List<VoucherOption> _ineligible;
@override@JsonKey() List<VoucherOption> get ineligible {
  if (_ineligible is EqualUnmodifiableListView) return _ineligible;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ineligible);
}

@override@JsonKey() final  int subtotal;
@override final  String? appliedVoucherId;
@override final  String? pendingVoucherId;
@override@JsonKey() final  bool applying;
@override@JsonKey() final  bool applied;

/// Create a copy of VoucherState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VoucherStateCopyWith<_VoucherState> get copyWith => __$VoucherStateCopyWithImpl<_VoucherState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VoucherState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&const DeepCollectionEquality().equals(other._eligible, _eligible)&&const DeepCollectionEquality().equals(other._ineligible, _ineligible)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.appliedVoucherId, appliedVoucherId) || other.appliedVoucherId == appliedVoucherId)&&(identical(other.pendingVoucherId, pendingVoucherId) || other.pendingVoucherId == pendingVoucherId)&&(identical(other.applying, applying) || other.applying == applying)&&(identical(other.applied, applied) || other.applied == applied));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,const DeepCollectionEquality().hash(_eligible),const DeepCollectionEquality().hash(_ineligible),subtotal,appliedVoucherId,pendingVoucherId,applying,applied);

@override
String toString() {
  return 'VoucherState(isLoading: $isLoading, hasError: $hasError, eligible: $eligible, ineligible: $ineligible, subtotal: $subtotal, appliedVoucherId: $appliedVoucherId, pendingVoucherId: $pendingVoucherId, applying: $applying, applied: $applied)';
}


}

/// @nodoc
abstract mixin class _$VoucherStateCopyWith<$Res> implements $VoucherStateCopyWith<$Res> {
  factory _$VoucherStateCopyWith(_VoucherState value, $Res Function(_VoucherState) _then) = __$VoucherStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool hasError, List<VoucherOption> eligible, List<VoucherOption> ineligible, int subtotal, String? appliedVoucherId, String? pendingVoucherId, bool applying, bool applied
});




}
/// @nodoc
class __$VoucherStateCopyWithImpl<$Res>
    implements _$VoucherStateCopyWith<$Res> {
  __$VoucherStateCopyWithImpl(this._self, this._then);

  final _VoucherState _self;
  final $Res Function(_VoucherState) _then;

/// Create a copy of VoucherState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? hasError = null,Object? eligible = null,Object? ineligible = null,Object? subtotal = null,Object? appliedVoucherId = freezed,Object? pendingVoucherId = freezed,Object? applying = null,Object? applied = null,}) {
  return _then(_VoucherState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,eligible: null == eligible ? _self._eligible : eligible // ignore: cast_nullable_to_non_nullable
as List<VoucherOption>,ineligible: null == ineligible ? _self._ineligible : ineligible // ignore: cast_nullable_to_non_nullable
as List<VoucherOption>,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as int,appliedVoucherId: freezed == appliedVoucherId ? _self.appliedVoucherId : appliedVoucherId // ignore: cast_nullable_to_non_nullable
as String?,pendingVoucherId: freezed == pendingVoucherId ? _self.pendingVoucherId : pendingVoucherId // ignore: cast_nullable_to_non_nullable
as String?,applying: null == applying ? _self.applying : applying // ignore: cast_nullable_to_non_nullable
as bool,applied: null == applied ? _self.applied : applied // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
