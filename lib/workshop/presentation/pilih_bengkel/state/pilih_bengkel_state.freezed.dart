// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pilih_bengkel_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PilihBengkelState {

 bool get isLoading; bool get hasError; List<Workshop> get workshops; List<ServiceType> get serviceTypes; WorkshopFilter get filter; String get searchQuery;
/// Create a copy of PilihBengkelState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PilihBengkelStateCopyWith<PilihBengkelState> get copyWith => _$PilihBengkelStateCopyWithImpl<PilihBengkelState>(this as PilihBengkelState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PilihBengkelState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&const DeepCollectionEquality().equals(other.workshops, workshops)&&const DeepCollectionEquality().equals(other.serviceTypes, serviceTypes)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,const DeepCollectionEquality().hash(workshops),const DeepCollectionEquality().hash(serviceTypes),filter,searchQuery);

@override
String toString() {
  return 'PilihBengkelState(isLoading: $isLoading, hasError: $hasError, workshops: $workshops, serviceTypes: $serviceTypes, filter: $filter, searchQuery: $searchQuery)';
}


}

/// @nodoc
abstract mixin class $PilihBengkelStateCopyWith<$Res>  {
  factory $PilihBengkelStateCopyWith(PilihBengkelState value, $Res Function(PilihBengkelState) _then) = _$PilihBengkelStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool hasError, List<Workshop> workshops, List<ServiceType> serviceTypes, WorkshopFilter filter, String searchQuery
});




}
/// @nodoc
class _$PilihBengkelStateCopyWithImpl<$Res>
    implements $PilihBengkelStateCopyWith<$Res> {
  _$PilihBengkelStateCopyWithImpl(this._self, this._then);

  final PilihBengkelState _self;
  final $Res Function(PilihBengkelState) _then;

/// Create a copy of PilihBengkelState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? hasError = null,Object? workshops = null,Object? serviceTypes = null,Object? filter = null,Object? searchQuery = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,workshops: null == workshops ? _self.workshops : workshops // ignore: cast_nullable_to_non_nullable
as List<Workshop>,serviceTypes: null == serviceTypes ? _self.serviceTypes : serviceTypes // ignore: cast_nullable_to_non_nullable
as List<ServiceType>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as WorkshopFilter,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PilihBengkelState].
extension PilihBengkelStatePatterns on PilihBengkelState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PilihBengkelState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PilihBengkelState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PilihBengkelState value)  $default,){
final _that = this;
switch (_that) {
case _PilihBengkelState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PilihBengkelState value)?  $default,){
final _that = this;
switch (_that) {
case _PilihBengkelState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  List<Workshop> workshops,  List<ServiceType> serviceTypes,  WorkshopFilter filter,  String searchQuery)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PilihBengkelState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.workshops,_that.serviceTypes,_that.filter,_that.searchQuery);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  List<Workshop> workshops,  List<ServiceType> serviceTypes,  WorkshopFilter filter,  String searchQuery)  $default,) {final _that = this;
switch (_that) {
case _PilihBengkelState():
return $default(_that.isLoading,_that.hasError,_that.workshops,_that.serviceTypes,_that.filter,_that.searchQuery);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool hasError,  List<Workshop> workshops,  List<ServiceType> serviceTypes,  WorkshopFilter filter,  String searchQuery)?  $default,) {final _that = this;
switch (_that) {
case _PilihBengkelState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.workshops,_that.serviceTypes,_that.filter,_that.searchQuery);case _:
  return null;

}
}

}

/// @nodoc


class _PilihBengkelState implements PilihBengkelState {
  const _PilihBengkelState({this.isLoading = true, this.hasError = false, final  List<Workshop> workshops = const <Workshop>[], final  List<ServiceType> serviceTypes = const <ServiceType>[], this.filter = WorkshopFilter.terdekat, this.searchQuery = ''}): _workshops = workshops,_serviceTypes = serviceTypes;
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool hasError;
 final  List<Workshop> _workshops;
@override@JsonKey() List<Workshop> get workshops {
  if (_workshops is EqualUnmodifiableListView) return _workshops;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_workshops);
}

 final  List<ServiceType> _serviceTypes;
@override@JsonKey() List<ServiceType> get serviceTypes {
  if (_serviceTypes is EqualUnmodifiableListView) return _serviceTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_serviceTypes);
}

@override@JsonKey() final  WorkshopFilter filter;
@override@JsonKey() final  String searchQuery;

/// Create a copy of PilihBengkelState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PilihBengkelStateCopyWith<_PilihBengkelState> get copyWith => __$PilihBengkelStateCopyWithImpl<_PilihBengkelState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PilihBengkelState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&const DeepCollectionEquality().equals(other._workshops, _workshops)&&const DeepCollectionEquality().equals(other._serviceTypes, _serviceTypes)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,const DeepCollectionEquality().hash(_workshops),const DeepCollectionEquality().hash(_serviceTypes),filter,searchQuery);

@override
String toString() {
  return 'PilihBengkelState(isLoading: $isLoading, hasError: $hasError, workshops: $workshops, serviceTypes: $serviceTypes, filter: $filter, searchQuery: $searchQuery)';
}


}

/// @nodoc
abstract mixin class _$PilihBengkelStateCopyWith<$Res> implements $PilihBengkelStateCopyWith<$Res> {
  factory _$PilihBengkelStateCopyWith(_PilihBengkelState value, $Res Function(_PilihBengkelState) _then) = __$PilihBengkelStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool hasError, List<Workshop> workshops, List<ServiceType> serviceTypes, WorkshopFilter filter, String searchQuery
});




}
/// @nodoc
class __$PilihBengkelStateCopyWithImpl<$Res>
    implements _$PilihBengkelStateCopyWith<$Res> {
  __$PilihBengkelStateCopyWithImpl(this._self, this._then);

  final _PilihBengkelState _self;
  final $Res Function(_PilihBengkelState) _then;

/// Create a copy of PilihBengkelState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? hasError = null,Object? workshops = null,Object? serviceTypes = null,Object? filter = null,Object? searchQuery = null,}) {
  return _then(_PilihBengkelState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,workshops: null == workshops ? _self._workshops : workshops // ignore: cast_nullable_to_non_nullable
as List<Workshop>,serviceTypes: null == serviceTypes ? _self._serviceTypes : serviceTypes // ignore: cast_nullable_to_non_nullable
as List<ServiceType>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as WorkshopFilter,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
