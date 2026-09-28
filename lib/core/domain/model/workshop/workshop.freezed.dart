// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workshop.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Workshop {

 String get id; String get name; double get rating; int get reviewCount; double get distanceKm; String get address; int get openTime; int get closeTime; int get bayCount; String get staticMapAssetPath; List<String> get serviceIds;
/// Create a copy of Workshop
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkshopCopyWith<Workshop> get copyWith => _$WorkshopCopyWithImpl<Workshop>(this as Workshop, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Workshop&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.address, address) || other.address == address)&&(identical(other.openTime, openTime) || other.openTime == openTime)&&(identical(other.closeTime, closeTime) || other.closeTime == closeTime)&&(identical(other.bayCount, bayCount) || other.bayCount == bayCount)&&(identical(other.staticMapAssetPath, staticMapAssetPath) || other.staticMapAssetPath == staticMapAssetPath)&&const DeepCollectionEquality().equals(other.serviceIds, serviceIds));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,rating,reviewCount,distanceKm,address,openTime,closeTime,bayCount,staticMapAssetPath,const DeepCollectionEquality().hash(serviceIds));

@override
String toString() {
  return 'Workshop(id: $id, name: $name, rating: $rating, reviewCount: $reviewCount, distanceKm: $distanceKm, address: $address, openTime: $openTime, closeTime: $closeTime, bayCount: $bayCount, staticMapAssetPath: $staticMapAssetPath, serviceIds: $serviceIds)';
}


}

/// @nodoc
abstract mixin class $WorkshopCopyWith<$Res>  {
  factory $WorkshopCopyWith(Workshop value, $Res Function(Workshop) _then) = _$WorkshopCopyWithImpl;
@useResult
$Res call({
 String id, String name, double rating, int reviewCount, double distanceKm, String address, int openTime, int closeTime, int bayCount, String staticMapAssetPath, List<String> serviceIds
});




}
/// @nodoc
class _$WorkshopCopyWithImpl<$Res>
    implements $WorkshopCopyWith<$Res> {
  _$WorkshopCopyWithImpl(this._self, this._then);

  final Workshop _self;
  final $Res Function(Workshop) _then;

/// Create a copy of Workshop
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? rating = null,Object? reviewCount = null,Object? distanceKm = null,Object? address = null,Object? openTime = null,Object? closeTime = null,Object? bayCount = null,Object? staticMapAssetPath = null,Object? serviceIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,openTime: null == openTime ? _self.openTime : openTime // ignore: cast_nullable_to_non_nullable
as int,closeTime: null == closeTime ? _self.closeTime : closeTime // ignore: cast_nullable_to_non_nullable
as int,bayCount: null == bayCount ? _self.bayCount : bayCount // ignore: cast_nullable_to_non_nullable
as int,staticMapAssetPath: null == staticMapAssetPath ? _self.staticMapAssetPath : staticMapAssetPath // ignore: cast_nullable_to_non_nullable
as String,serviceIds: null == serviceIds ? _self.serviceIds : serviceIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Workshop].
extension WorkshopPatterns on Workshop {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Workshop value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Workshop() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Workshop value)  $default,){
final _that = this;
switch (_that) {
case _Workshop():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Workshop value)?  $default,){
final _that = this;
switch (_that) {
case _Workshop() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  double rating,  int reviewCount,  double distanceKm,  String address,  int openTime,  int closeTime,  int bayCount,  String staticMapAssetPath,  List<String> serviceIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Workshop() when $default != null:
return $default(_that.id,_that.name,_that.rating,_that.reviewCount,_that.distanceKm,_that.address,_that.openTime,_that.closeTime,_that.bayCount,_that.staticMapAssetPath,_that.serviceIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  double rating,  int reviewCount,  double distanceKm,  String address,  int openTime,  int closeTime,  int bayCount,  String staticMapAssetPath,  List<String> serviceIds)  $default,) {final _that = this;
switch (_that) {
case _Workshop():
return $default(_that.id,_that.name,_that.rating,_that.reviewCount,_that.distanceKm,_that.address,_that.openTime,_that.closeTime,_that.bayCount,_that.staticMapAssetPath,_that.serviceIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  double rating,  int reviewCount,  double distanceKm,  String address,  int openTime,  int closeTime,  int bayCount,  String staticMapAssetPath,  List<String> serviceIds)?  $default,) {final _that = this;
switch (_that) {
case _Workshop() when $default != null:
return $default(_that.id,_that.name,_that.rating,_that.reviewCount,_that.distanceKm,_that.address,_that.openTime,_that.closeTime,_that.bayCount,_that.staticMapAssetPath,_that.serviceIds);case _:
  return null;

}
}

}

/// @nodoc


class _Workshop implements Workshop {
  const _Workshop({required this.id, required this.name, required this.rating, required this.reviewCount, required this.distanceKm, required this.address, required this.openTime, required this.closeTime, required this.bayCount, required this.staticMapAssetPath, required final  List<String> serviceIds}): _serviceIds = serviceIds;
  

@override final  String id;
@override final  String name;
@override final  double rating;
@override final  int reviewCount;
@override final  double distanceKm;
@override final  String address;
@override final  int openTime;
@override final  int closeTime;
@override final  int bayCount;
@override final  String staticMapAssetPath;
 final  List<String> _serviceIds;
@override List<String> get serviceIds {
  if (_serviceIds is EqualUnmodifiableListView) return _serviceIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_serviceIds);
}


/// Create a copy of Workshop
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkshopCopyWith<_Workshop> get copyWith => __$WorkshopCopyWithImpl<_Workshop>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Workshop&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.address, address) || other.address == address)&&(identical(other.openTime, openTime) || other.openTime == openTime)&&(identical(other.closeTime, closeTime) || other.closeTime == closeTime)&&(identical(other.bayCount, bayCount) || other.bayCount == bayCount)&&(identical(other.staticMapAssetPath, staticMapAssetPath) || other.staticMapAssetPath == staticMapAssetPath)&&const DeepCollectionEquality().equals(other._serviceIds, _serviceIds));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,rating,reviewCount,distanceKm,address,openTime,closeTime,bayCount,staticMapAssetPath,const DeepCollectionEquality().hash(_serviceIds));

@override
String toString() {
  return 'Workshop(id: $id, name: $name, rating: $rating, reviewCount: $reviewCount, distanceKm: $distanceKm, address: $address, openTime: $openTime, closeTime: $closeTime, bayCount: $bayCount, staticMapAssetPath: $staticMapAssetPath, serviceIds: $serviceIds)';
}


}

/// @nodoc
abstract mixin class _$WorkshopCopyWith<$Res> implements $WorkshopCopyWith<$Res> {
  factory _$WorkshopCopyWith(_Workshop value, $Res Function(_Workshop) _then) = __$WorkshopCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, double rating, int reviewCount, double distanceKm, String address, int openTime, int closeTime, int bayCount, String staticMapAssetPath, List<String> serviceIds
});




}
/// @nodoc
class __$WorkshopCopyWithImpl<$Res>
    implements _$WorkshopCopyWith<$Res> {
  __$WorkshopCopyWithImpl(this._self, this._then);

  final _Workshop _self;
  final $Res Function(_Workshop) _then;

/// Create a copy of Workshop
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? rating = null,Object? reviewCount = null,Object? distanceKm = null,Object? address = null,Object? openTime = null,Object? closeTime = null,Object? bayCount = null,Object? staticMapAssetPath = null,Object? serviceIds = null,}) {
  return _then(_Workshop(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,openTime: null == openTime ? _self.openTime : openTime // ignore: cast_nullable_to_non_nullable
as int,closeTime: null == closeTime ? _self.closeTime : closeTime // ignore: cast_nullable_to_non_nullable
as int,bayCount: null == bayCount ? _self.bayCount : bayCount // ignore: cast_nullable_to_non_nullable
as int,staticMapAssetPath: null == staticMapAssetPath ? _self.staticMapAssetPath : staticMapAssetPath // ignore: cast_nullable_to_non_nullable
as String,serviceIds: null == serviceIds ? _self._serviceIds : serviceIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
