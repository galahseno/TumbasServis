// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Promo {

 String get id; String get title; String get imageAssetPath; String? get deepLink;
/// Create a copy of Promo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoCopyWith<Promo> get copyWith => _$PromoCopyWithImpl<Promo>(this as Promo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Promo&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.imageAssetPath, imageAssetPath) || other.imageAssetPath == imageAssetPath)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,imageAssetPath,deepLink);

@override
String toString() {
  return 'Promo(id: $id, title: $title, imageAssetPath: $imageAssetPath, deepLink: $deepLink)';
}


}

/// @nodoc
abstract mixin class $PromoCopyWith<$Res>  {
  factory $PromoCopyWith(Promo value, $Res Function(Promo) _then) = _$PromoCopyWithImpl;
@useResult
$Res call({
 String id, String title, String imageAssetPath, String? deepLink
});




}
/// @nodoc
class _$PromoCopyWithImpl<$Res>
    implements $PromoCopyWith<$Res> {
  _$PromoCopyWithImpl(this._self, this._then);

  final Promo _self;
  final $Res Function(Promo) _then;

/// Create a copy of Promo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? imageAssetPath = null,Object? deepLink = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,imageAssetPath: null == imageAssetPath ? _self.imageAssetPath : imageAssetPath // ignore: cast_nullable_to_non_nullable
as String,deepLink: freezed == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Promo].
extension PromoPatterns on Promo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Promo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Promo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Promo value)  $default,){
final _that = this;
switch (_that) {
case _Promo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Promo value)?  $default,){
final _that = this;
switch (_that) {
case _Promo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String imageAssetPath,  String? deepLink)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Promo() when $default != null:
return $default(_that.id,_that.title,_that.imageAssetPath,_that.deepLink);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String imageAssetPath,  String? deepLink)  $default,) {final _that = this;
switch (_that) {
case _Promo():
return $default(_that.id,_that.title,_that.imageAssetPath,_that.deepLink);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String imageAssetPath,  String? deepLink)?  $default,) {final _that = this;
switch (_that) {
case _Promo() when $default != null:
return $default(_that.id,_that.title,_that.imageAssetPath,_that.deepLink);case _:
  return null;

}
}

}

/// @nodoc


class _Promo implements Promo {
  const _Promo({required this.id, required this.title, required this.imageAssetPath, this.deepLink});
  

@override final  String id;
@override final  String title;
@override final  String imageAssetPath;
@override final  String? deepLink;

/// Create a copy of Promo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromoCopyWith<_Promo> get copyWith => __$PromoCopyWithImpl<_Promo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Promo&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.imageAssetPath, imageAssetPath) || other.imageAssetPath == imageAssetPath)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,imageAssetPath,deepLink);

@override
String toString() {
  return 'Promo(id: $id, title: $title, imageAssetPath: $imageAssetPath, deepLink: $deepLink)';
}


}

/// @nodoc
abstract mixin class _$PromoCopyWith<$Res> implements $PromoCopyWith<$Res> {
  factory _$PromoCopyWith(_Promo value, $Res Function(_Promo) _then) = __$PromoCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String imageAssetPath, String? deepLink
});




}
/// @nodoc
class __$PromoCopyWithImpl<$Res>
    implements _$PromoCopyWith<$Res> {
  __$PromoCopyWithImpl(this._self, this._then);

  final _Promo _self;
  final $Res Function(_Promo) _then;

/// Create a copy of Promo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? imageAssetPath = null,Object? deepLink = freezed,}) {
  return _then(_Promo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,imageAssetPath: null == imageAssetPath ? _self.imageAssetPath : imageAssetPath // ignore: cast_nullable_to_non_nullable
as String,deepLink: freezed == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
