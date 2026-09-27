// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Review {

 String get bookingId; int get workshopRating; String? get workshopComment; Map<String, int> get mechanicRatings; DateTime get createdAt;
/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewCopyWith<Review> get copyWith => _$ReviewCopyWithImpl<Review>(this as Review, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Review&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.workshopRating, workshopRating) || other.workshopRating == workshopRating)&&(identical(other.workshopComment, workshopComment) || other.workshopComment == workshopComment)&&const DeepCollectionEquality().equals(other.mechanicRatings, mechanicRatings)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,bookingId,workshopRating,workshopComment,const DeepCollectionEquality().hash(mechanicRatings),createdAt);

@override
String toString() {
  return 'Review(bookingId: $bookingId, workshopRating: $workshopRating, workshopComment: $workshopComment, mechanicRatings: $mechanicRatings, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ReviewCopyWith<$Res>  {
  factory $ReviewCopyWith(Review value, $Res Function(Review) _then) = _$ReviewCopyWithImpl;
@useResult
$Res call({
 String bookingId, int workshopRating, String? workshopComment, Map<String, int> mechanicRatings, DateTime createdAt
});




}
/// @nodoc
class _$ReviewCopyWithImpl<$Res>
    implements $ReviewCopyWith<$Res> {
  _$ReviewCopyWithImpl(this._self, this._then);

  final Review _self;
  final $Res Function(Review) _then;

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bookingId = null,Object? workshopRating = null,Object? workshopComment = freezed,Object? mechanicRatings = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String,workshopRating: null == workshopRating ? _self.workshopRating : workshopRating // ignore: cast_nullable_to_non_nullable
as int,workshopComment: freezed == workshopComment ? _self.workshopComment : workshopComment // ignore: cast_nullable_to_non_nullable
as String?,mechanicRatings: null == mechanicRatings ? _self.mechanicRatings : mechanicRatings // ignore: cast_nullable_to_non_nullable
as Map<String, int>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Review].
extension ReviewPatterns on Review {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Review value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Review() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Review value)  $default,){
final _that = this;
switch (_that) {
case _Review():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Review value)?  $default,){
final _that = this;
switch (_that) {
case _Review() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String bookingId,  int workshopRating,  String? workshopComment,  Map<String, int> mechanicRatings,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Review() when $default != null:
return $default(_that.bookingId,_that.workshopRating,_that.workshopComment,_that.mechanicRatings,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String bookingId,  int workshopRating,  String? workshopComment,  Map<String, int> mechanicRatings,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Review():
return $default(_that.bookingId,_that.workshopRating,_that.workshopComment,_that.mechanicRatings,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String bookingId,  int workshopRating,  String? workshopComment,  Map<String, int> mechanicRatings,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Review() when $default != null:
return $default(_that.bookingId,_that.workshopRating,_that.workshopComment,_that.mechanicRatings,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _Review extends Review {
  const _Review({required this.bookingId, required this.workshopRating, this.workshopComment, required final  Map<String, int> mechanicRatings, required this.createdAt}): _mechanicRatings = mechanicRatings,super._();
  

@override final  String bookingId;
@override final  int workshopRating;
@override final  String? workshopComment;
 final  Map<String, int> _mechanicRatings;
@override Map<String, int> get mechanicRatings {
  if (_mechanicRatings is EqualUnmodifiableMapView) return _mechanicRatings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_mechanicRatings);
}

@override final  DateTime createdAt;

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewCopyWith<_Review> get copyWith => __$ReviewCopyWithImpl<_Review>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Review&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.workshopRating, workshopRating) || other.workshopRating == workshopRating)&&(identical(other.workshopComment, workshopComment) || other.workshopComment == workshopComment)&&const DeepCollectionEquality().equals(other._mechanicRatings, _mechanicRatings)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,bookingId,workshopRating,workshopComment,const DeepCollectionEquality().hash(_mechanicRatings),createdAt);

@override
String toString() {
  return 'Review(bookingId: $bookingId, workshopRating: $workshopRating, workshopComment: $workshopComment, mechanicRatings: $mechanicRatings, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ReviewCopyWith<$Res> implements $ReviewCopyWith<$Res> {
  factory _$ReviewCopyWith(_Review value, $Res Function(_Review) _then) = __$ReviewCopyWithImpl;
@override @useResult
$Res call({
 String bookingId, int workshopRating, String? workshopComment, Map<String, int> mechanicRatings, DateTime createdAt
});




}
/// @nodoc
class __$ReviewCopyWithImpl<$Res>
    implements _$ReviewCopyWith<$Res> {
  __$ReviewCopyWithImpl(this._self, this._then);

  final _Review _self;
  final $Res Function(_Review) _then;

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bookingId = null,Object? workshopRating = null,Object? workshopComment = freezed,Object? mechanicRatings = null,Object? createdAt = null,}) {
  return _then(_Review(
bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String,workshopRating: null == workshopRating ? _self.workshopRating : workshopRating // ignore: cast_nullable_to_non_nullable
as int,workshopComment: freezed == workshopComment ? _self.workshopComment : workshopComment // ignore: cast_nullable_to_non_nullable
as String?,mechanicRatings: null == mechanicRatings ? _self._mechanicRatings : mechanicRatings // ignore: cast_nullable_to_non_nullable
as Map<String, int>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
