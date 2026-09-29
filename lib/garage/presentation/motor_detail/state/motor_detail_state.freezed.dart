// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'motor_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MotorDetailState {

 bool get isLoading; bool get hasError; Motor? get motor; MotorModel? get model; MotorHistoryEntry? get activeEntry; List<MotorHistoryEntry> get pastHistory; bool get isDeleting;
/// Create a copy of MotorDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MotorDetailStateCopyWith<MotorDetailState> get copyWith => _$MotorDetailStateCopyWithImpl<MotorDetailState>(this as MotorDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MotorDetailState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.motor, motor) || other.motor == motor)&&(identical(other.model, model) || other.model == model)&&(identical(other.activeEntry, activeEntry) || other.activeEntry == activeEntry)&&const DeepCollectionEquality().equals(other.pastHistory, pastHistory)&&(identical(other.isDeleting, isDeleting) || other.isDeleting == isDeleting));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,motor,model,activeEntry,const DeepCollectionEquality().hash(pastHistory),isDeleting);

@override
String toString() {
  return 'MotorDetailState(isLoading: $isLoading, hasError: $hasError, motor: $motor, model: $model, activeEntry: $activeEntry, pastHistory: $pastHistory, isDeleting: $isDeleting)';
}


}

/// @nodoc
abstract mixin class $MotorDetailStateCopyWith<$Res>  {
  factory $MotorDetailStateCopyWith(MotorDetailState value, $Res Function(MotorDetailState) _then) = _$MotorDetailStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool hasError, Motor? motor, MotorModel? model, MotorHistoryEntry? activeEntry, List<MotorHistoryEntry> pastHistory, bool isDeleting
});


$MotorCopyWith<$Res>? get motor;

}
/// @nodoc
class _$MotorDetailStateCopyWithImpl<$Res>
    implements $MotorDetailStateCopyWith<$Res> {
  _$MotorDetailStateCopyWithImpl(this._self, this._then);

  final MotorDetailState _self;
  final $Res Function(MotorDetailState) _then;

/// Create a copy of MotorDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? hasError = null,Object? motor = freezed,Object? model = freezed,Object? activeEntry = freezed,Object? pastHistory = null,Object? isDeleting = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,motor: freezed == motor ? _self.motor : motor // ignore: cast_nullable_to_non_nullable
as Motor?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as MotorModel?,activeEntry: freezed == activeEntry ? _self.activeEntry : activeEntry // ignore: cast_nullable_to_non_nullable
as MotorHistoryEntry?,pastHistory: null == pastHistory ? _self.pastHistory : pastHistory // ignore: cast_nullable_to_non_nullable
as List<MotorHistoryEntry>,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of MotorDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MotorCopyWith<$Res>? get motor {
    if (_self.motor == null) {
    return null;
  }

  return $MotorCopyWith<$Res>(_self.motor!, (value) {
    return _then(_self.copyWith(motor: value));
  });
}
}


/// Adds pattern-matching-related methods to [MotorDetailState].
extension MotorDetailStatePatterns on MotorDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MotorDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MotorDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MotorDetailState value)  $default,){
final _that = this;
switch (_that) {
case _MotorDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MotorDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _MotorDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  Motor? motor,  MotorModel? model,  MotorHistoryEntry? activeEntry,  List<MotorHistoryEntry> pastHistory,  bool isDeleting)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MotorDetailState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.motor,_that.model,_that.activeEntry,_that.pastHistory,_that.isDeleting);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  Motor? motor,  MotorModel? model,  MotorHistoryEntry? activeEntry,  List<MotorHistoryEntry> pastHistory,  bool isDeleting)  $default,) {final _that = this;
switch (_that) {
case _MotorDetailState():
return $default(_that.isLoading,_that.hasError,_that.motor,_that.model,_that.activeEntry,_that.pastHistory,_that.isDeleting);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool hasError,  Motor? motor,  MotorModel? model,  MotorHistoryEntry? activeEntry,  List<MotorHistoryEntry> pastHistory,  bool isDeleting)?  $default,) {final _that = this;
switch (_that) {
case _MotorDetailState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.motor,_that.model,_that.activeEntry,_that.pastHistory,_that.isDeleting);case _:
  return null;

}
}

}

/// @nodoc


class _MotorDetailState extends MotorDetailState {
  const _MotorDetailState({this.isLoading = true, this.hasError = false, this.motor, this.model, this.activeEntry, final  List<MotorHistoryEntry> pastHistory = const <MotorHistoryEntry>[], this.isDeleting = false}): _pastHistory = pastHistory,super._();
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool hasError;
@override final  Motor? motor;
@override final  MotorModel? model;
@override final  MotorHistoryEntry? activeEntry;
 final  List<MotorHistoryEntry> _pastHistory;
@override@JsonKey() List<MotorHistoryEntry> get pastHistory {
  if (_pastHistory is EqualUnmodifiableListView) return _pastHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pastHistory);
}

@override@JsonKey() final  bool isDeleting;

/// Create a copy of MotorDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MotorDetailStateCopyWith<_MotorDetailState> get copyWith => __$MotorDetailStateCopyWithImpl<_MotorDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MotorDetailState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.motor, motor) || other.motor == motor)&&(identical(other.model, model) || other.model == model)&&(identical(other.activeEntry, activeEntry) || other.activeEntry == activeEntry)&&const DeepCollectionEquality().equals(other._pastHistory, _pastHistory)&&(identical(other.isDeleting, isDeleting) || other.isDeleting == isDeleting));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,motor,model,activeEntry,const DeepCollectionEquality().hash(_pastHistory),isDeleting);

@override
String toString() {
  return 'MotorDetailState(isLoading: $isLoading, hasError: $hasError, motor: $motor, model: $model, activeEntry: $activeEntry, pastHistory: $pastHistory, isDeleting: $isDeleting)';
}


}

/// @nodoc
abstract mixin class _$MotorDetailStateCopyWith<$Res> implements $MotorDetailStateCopyWith<$Res> {
  factory _$MotorDetailStateCopyWith(_MotorDetailState value, $Res Function(_MotorDetailState) _then) = __$MotorDetailStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool hasError, Motor? motor, MotorModel? model, MotorHistoryEntry? activeEntry, List<MotorHistoryEntry> pastHistory, bool isDeleting
});


@override $MotorCopyWith<$Res>? get motor;

}
/// @nodoc
class __$MotorDetailStateCopyWithImpl<$Res>
    implements _$MotorDetailStateCopyWith<$Res> {
  __$MotorDetailStateCopyWithImpl(this._self, this._then);

  final _MotorDetailState _self;
  final $Res Function(_MotorDetailState) _then;

/// Create a copy of MotorDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? hasError = null,Object? motor = freezed,Object? model = freezed,Object? activeEntry = freezed,Object? pastHistory = null,Object? isDeleting = null,}) {
  return _then(_MotorDetailState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,motor: freezed == motor ? _self.motor : motor // ignore: cast_nullable_to_non_nullable
as Motor?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as MotorModel?,activeEntry: freezed == activeEntry ? _self.activeEntry : activeEntry // ignore: cast_nullable_to_non_nullable
as MotorHistoryEntry?,pastHistory: null == pastHistory ? _self._pastHistory : pastHistory // ignore: cast_nullable_to_non_nullable
as List<MotorHistoryEntry>,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of MotorDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MotorCopyWith<$Res>? get motor {
    if (_self.motor == null) {
    return null;
  }

  return $MotorCopyWith<$Res>(_self.motor!, (value) {
    return _then(_self.copyWith(motor: value));
  });
}
}

// dart format on
