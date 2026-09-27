// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_type.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ServiceType {

 String get id; String get name; int get price; int get durationMin; bool get requiresComplaint;
/// Create a copy of ServiceType
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceTypeCopyWith<ServiceType> get copyWith => _$ServiceTypeCopyWithImpl<ServiceType>(this as ServiceType, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceType&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.durationMin, durationMin) || other.durationMin == durationMin)&&(identical(other.requiresComplaint, requiresComplaint) || other.requiresComplaint == requiresComplaint));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,price,durationMin,requiresComplaint);

@override
String toString() {
  return 'ServiceType(id: $id, name: $name, price: $price, durationMin: $durationMin, requiresComplaint: $requiresComplaint)';
}


}

/// @nodoc
abstract mixin class $ServiceTypeCopyWith<$Res>  {
  factory $ServiceTypeCopyWith(ServiceType value, $Res Function(ServiceType) _then) = _$ServiceTypeCopyWithImpl;
@useResult
$Res call({
 String id, String name, int price, int durationMin, bool requiresComplaint
});




}
/// @nodoc
class _$ServiceTypeCopyWithImpl<$Res>
    implements $ServiceTypeCopyWith<$Res> {
  _$ServiceTypeCopyWithImpl(this._self, this._then);

  final ServiceType _self;
  final $Res Function(ServiceType) _then;

/// Create a copy of ServiceType
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? price = null,Object? durationMin = null,Object? requiresComplaint = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,durationMin: null == durationMin ? _self.durationMin : durationMin // ignore: cast_nullable_to_non_nullable
as int,requiresComplaint: null == requiresComplaint ? _self.requiresComplaint : requiresComplaint // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ServiceType].
extension ServiceTypePatterns on ServiceType {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceType value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceType() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceType value)  $default,){
final _that = this;
switch (_that) {
case _ServiceType():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceType value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceType() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int price,  int durationMin,  bool requiresComplaint)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceType() when $default != null:
return $default(_that.id,_that.name,_that.price,_that.durationMin,_that.requiresComplaint);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int price,  int durationMin,  bool requiresComplaint)  $default,) {final _that = this;
switch (_that) {
case _ServiceType():
return $default(_that.id,_that.name,_that.price,_that.durationMin,_that.requiresComplaint);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int price,  int durationMin,  bool requiresComplaint)?  $default,) {final _that = this;
switch (_that) {
case _ServiceType() when $default != null:
return $default(_that.id,_that.name,_that.price,_that.durationMin,_that.requiresComplaint);case _:
  return null;

}
}

}

/// @nodoc


class _ServiceType implements ServiceType {
  const _ServiceType({required this.id, required this.name, required this.price, required this.durationMin, required this.requiresComplaint});
  

@override final  String id;
@override final  String name;
@override final  int price;
@override final  int durationMin;
@override final  bool requiresComplaint;

/// Create a copy of ServiceType
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceTypeCopyWith<_ServiceType> get copyWith => __$ServiceTypeCopyWithImpl<_ServiceType>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceType&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.durationMin, durationMin) || other.durationMin == durationMin)&&(identical(other.requiresComplaint, requiresComplaint) || other.requiresComplaint == requiresComplaint));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,price,durationMin,requiresComplaint);

@override
String toString() {
  return 'ServiceType(id: $id, name: $name, price: $price, durationMin: $durationMin, requiresComplaint: $requiresComplaint)';
}


}

/// @nodoc
abstract mixin class _$ServiceTypeCopyWith<$Res> implements $ServiceTypeCopyWith<$Res> {
  factory _$ServiceTypeCopyWith(_ServiceType value, $Res Function(_ServiceType) _then) = __$ServiceTypeCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int price, int durationMin, bool requiresComplaint
});




}
/// @nodoc
class __$ServiceTypeCopyWithImpl<$Res>
    implements _$ServiceTypeCopyWith<$Res> {
  __$ServiceTypeCopyWithImpl(this._self, this._then);

  final _ServiceType _self;
  final $Res Function(_ServiceType) _then;

/// Create a copy of ServiceType
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? price = null,Object? durationMin = null,Object? requiresComplaint = null,}) {
  return _then(_ServiceType(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,durationMin: null == durationMin ? _self.durationMin : durationMin // ignore: cast_nullable_to_non_nullable
as int,requiresComplaint: null == requiresComplaint ? _self.requiresComplaint : requiresComplaint // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
