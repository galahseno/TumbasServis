// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'part.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Part {

 String get id; String get name; String get category; String get brand; String get grade; int get price; List<String> get compatibleModelIds;
/// Create a copy of Part
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartCopyWith<Part> get copyWith => _$PartCopyWithImpl<Part>(this as Part, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Part&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.grade, grade) || other.grade == grade)&&(identical(other.price, price) || other.price == price)&&const DeepCollectionEquality().equals(other.compatibleModelIds, compatibleModelIds));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,category,brand,grade,price,const DeepCollectionEquality().hash(compatibleModelIds));

@override
String toString() {
  return 'Part(id: $id, name: $name, category: $category, brand: $brand, grade: $grade, price: $price, compatibleModelIds: $compatibleModelIds)';
}


}

/// @nodoc
abstract mixin class $PartCopyWith<$Res>  {
  factory $PartCopyWith(Part value, $Res Function(Part) _then) = _$PartCopyWithImpl;
@useResult
$Res call({
 String id, String name, String category, String brand, String grade, int price, List<String> compatibleModelIds
});




}
/// @nodoc
class _$PartCopyWithImpl<$Res>
    implements $PartCopyWith<$Res> {
  _$PartCopyWithImpl(this._self, this._then);

  final Part _self;
  final $Res Function(Part) _then;

/// Create a copy of Part
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? category = null,Object? brand = null,Object? grade = null,Object? price = null,Object? compatibleModelIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,grade: null == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,compatibleModelIds: null == compatibleModelIds ? _self.compatibleModelIds : compatibleModelIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Part].
extension PartPatterns on Part {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Part value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Part() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Part value)  $default,){
final _that = this;
switch (_that) {
case _Part():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Part value)?  $default,){
final _that = this;
switch (_that) {
case _Part() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String category,  String brand,  String grade,  int price,  List<String> compatibleModelIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Part() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.brand,_that.grade,_that.price,_that.compatibleModelIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String category,  String brand,  String grade,  int price,  List<String> compatibleModelIds)  $default,) {final _that = this;
switch (_that) {
case _Part():
return $default(_that.id,_that.name,_that.category,_that.brand,_that.grade,_that.price,_that.compatibleModelIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String category,  String brand,  String grade,  int price,  List<String> compatibleModelIds)?  $default,) {final _that = this;
switch (_that) {
case _Part() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.brand,_that.grade,_that.price,_that.compatibleModelIds);case _:
  return null;

}
}

}

/// @nodoc


class _Part implements Part {
  const _Part({required this.id, required this.name, required this.category, required this.brand, required this.grade, required this.price, required final  List<String> compatibleModelIds}): _compatibleModelIds = compatibleModelIds;
  

@override final  String id;
@override final  String name;
@override final  String category;
@override final  String brand;
@override final  String grade;
@override final  int price;
 final  List<String> _compatibleModelIds;
@override List<String> get compatibleModelIds {
  if (_compatibleModelIds is EqualUnmodifiableListView) return _compatibleModelIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_compatibleModelIds);
}


/// Create a copy of Part
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartCopyWith<_Part> get copyWith => __$PartCopyWithImpl<_Part>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Part&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.grade, grade) || other.grade == grade)&&(identical(other.price, price) || other.price == price)&&const DeepCollectionEquality().equals(other._compatibleModelIds, _compatibleModelIds));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,category,brand,grade,price,const DeepCollectionEquality().hash(_compatibleModelIds));

@override
String toString() {
  return 'Part(id: $id, name: $name, category: $category, brand: $brand, grade: $grade, price: $price, compatibleModelIds: $compatibleModelIds)';
}


}

/// @nodoc
abstract mixin class _$PartCopyWith<$Res> implements $PartCopyWith<$Res> {
  factory _$PartCopyWith(_Part value, $Res Function(_Part) _then) = __$PartCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String category, String brand, String grade, int price, List<String> compatibleModelIds
});




}
/// @nodoc
class __$PartCopyWithImpl<$Res>
    implements _$PartCopyWith<$Res> {
  __$PartCopyWithImpl(this._self, this._then);

  final _Part _self;
  final $Res Function(_Part) _then;

/// Create a copy of Part
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? category = null,Object? brand = null,Object? grade = null,Object? price = null,Object? compatibleModelIds = null,}) {
  return _then(_Part(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,grade: null == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,compatibleModelIds: null == compatibleModelIds ? _self._compatibleModelIds : compatibleModelIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
