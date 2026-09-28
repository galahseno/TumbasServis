// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'detail_bengkel_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DetailBengkelState {

 bool get isLoading; bool get hasError; Workshop? get workshop; List<ServiceType> get serviceTypes;
/// Create a copy of DetailBengkelState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DetailBengkelStateCopyWith<DetailBengkelState> get copyWith => _$DetailBengkelStateCopyWithImpl<DetailBengkelState>(this as DetailBengkelState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DetailBengkelState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.workshop, workshop) || other.workshop == workshop)&&const DeepCollectionEquality().equals(other.serviceTypes, serviceTypes));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,workshop,const DeepCollectionEquality().hash(serviceTypes));

@override
String toString() {
  return 'DetailBengkelState(isLoading: $isLoading, hasError: $hasError, workshop: $workshop, serviceTypes: $serviceTypes)';
}


}

/// @nodoc
abstract mixin class $DetailBengkelStateCopyWith<$Res>  {
  factory $DetailBengkelStateCopyWith(DetailBengkelState value, $Res Function(DetailBengkelState) _then) = _$DetailBengkelStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool hasError, Workshop? workshop, List<ServiceType> serviceTypes
});


$WorkshopCopyWith<$Res>? get workshop;

}
/// @nodoc
class _$DetailBengkelStateCopyWithImpl<$Res>
    implements $DetailBengkelStateCopyWith<$Res> {
  _$DetailBengkelStateCopyWithImpl(this._self, this._then);

  final DetailBengkelState _self;
  final $Res Function(DetailBengkelState) _then;

/// Create a copy of DetailBengkelState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? hasError = null,Object? workshop = freezed,Object? serviceTypes = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,workshop: freezed == workshop ? _self.workshop : workshop // ignore: cast_nullable_to_non_nullable
as Workshop?,serviceTypes: null == serviceTypes ? _self.serviceTypes : serviceTypes // ignore: cast_nullable_to_non_nullable
as List<ServiceType>,
  ));
}
/// Create a copy of DetailBengkelState
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


/// Adds pattern-matching-related methods to [DetailBengkelState].
extension DetailBengkelStatePatterns on DetailBengkelState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DetailBengkelState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DetailBengkelState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DetailBengkelState value)  $default,){
final _that = this;
switch (_that) {
case _DetailBengkelState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DetailBengkelState value)?  $default,){
final _that = this;
switch (_that) {
case _DetailBengkelState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  Workshop? workshop,  List<ServiceType> serviceTypes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DetailBengkelState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.workshop,_that.serviceTypes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  Workshop? workshop,  List<ServiceType> serviceTypes)  $default,) {final _that = this;
switch (_that) {
case _DetailBengkelState():
return $default(_that.isLoading,_that.hasError,_that.workshop,_that.serviceTypes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool hasError,  Workshop? workshop,  List<ServiceType> serviceTypes)?  $default,) {final _that = this;
switch (_that) {
case _DetailBengkelState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.workshop,_that.serviceTypes);case _:
  return null;

}
}

}

/// @nodoc


class _DetailBengkelState implements DetailBengkelState {
  const _DetailBengkelState({this.isLoading = true, this.hasError = false, this.workshop, final  List<ServiceType> serviceTypes = const <ServiceType>[]}): _serviceTypes = serviceTypes;
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool hasError;
@override final  Workshop? workshop;
 final  List<ServiceType> _serviceTypes;
@override@JsonKey() List<ServiceType> get serviceTypes {
  if (_serviceTypes is EqualUnmodifiableListView) return _serviceTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_serviceTypes);
}


/// Create a copy of DetailBengkelState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DetailBengkelStateCopyWith<_DetailBengkelState> get copyWith => __$DetailBengkelStateCopyWithImpl<_DetailBengkelState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DetailBengkelState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.workshop, workshop) || other.workshop == workshop)&&const DeepCollectionEquality().equals(other._serviceTypes, _serviceTypes));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,workshop,const DeepCollectionEquality().hash(_serviceTypes));

@override
String toString() {
  return 'DetailBengkelState(isLoading: $isLoading, hasError: $hasError, workshop: $workshop, serviceTypes: $serviceTypes)';
}


}

/// @nodoc
abstract mixin class _$DetailBengkelStateCopyWith<$Res> implements $DetailBengkelStateCopyWith<$Res> {
  factory _$DetailBengkelStateCopyWith(_DetailBengkelState value, $Res Function(_DetailBengkelState) _then) = __$DetailBengkelStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool hasError, Workshop? workshop, List<ServiceType> serviceTypes
});


@override $WorkshopCopyWith<$Res>? get workshop;

}
/// @nodoc
class __$DetailBengkelStateCopyWithImpl<$Res>
    implements _$DetailBengkelStateCopyWith<$Res> {
  __$DetailBengkelStateCopyWithImpl(this._self, this._then);

  final _DetailBengkelState _self;
  final $Res Function(_DetailBengkelState) _then;

/// Create a copy of DetailBengkelState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? hasError = null,Object? workshop = freezed,Object? serviceTypes = null,}) {
  return _then(_DetailBengkelState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,workshop: freezed == workshop ? _self.workshop : workshop // ignore: cast_nullable_to_non_nullable
as Workshop?,serviceTypes: null == serviceTypes ? _self._serviceTypes : serviceTypes // ignore: cast_nullable_to_non_nullable
as List<ServiceType>,
  ));
}

/// Create a copy of DetailBengkelState
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
