// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'motor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Motor {

 String get id; String get ownerId; String get nickname; String get plateNumber; int? get year; String? get photoUrl; String get modelId;
/// Create a copy of Motor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MotorCopyWith<Motor> get copyWith => _$MotorCopyWithImpl<Motor>(this as Motor, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Motor&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.plateNumber, plateNumber) || other.plateNumber == plateNumber)&&(identical(other.year, year) || other.year == year)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.modelId, modelId) || other.modelId == modelId));
}


@override
int get hashCode => Object.hash(runtimeType,id,ownerId,nickname,plateNumber,year,photoUrl,modelId);

@override
String toString() {
  return 'Motor(id: $id, ownerId: $ownerId, nickname: $nickname, plateNumber: $plateNumber, year: $year, photoUrl: $photoUrl, modelId: $modelId)';
}


}

/// @nodoc
abstract mixin class $MotorCopyWith<$Res>  {
  factory $MotorCopyWith(Motor value, $Res Function(Motor) _then) = _$MotorCopyWithImpl;
@useResult
$Res call({
 String id, String ownerId, String nickname, String plateNumber, int? year, String? photoUrl, String modelId
});




}
/// @nodoc
class _$MotorCopyWithImpl<$Res>
    implements $MotorCopyWith<$Res> {
  _$MotorCopyWithImpl(this._self, this._then);

  final Motor _self;
  final $Res Function(Motor) _then;

/// Create a copy of Motor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerId = null,Object? nickname = null,Object? plateNumber = null,Object? year = freezed,Object? photoUrl = freezed,Object? modelId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,plateNumber: null == plateNumber ? _self.plateNumber : plateNumber // ignore: cast_nullable_to_non_nullable
as String,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,modelId: null == modelId ? _self.modelId : modelId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Motor].
extension MotorPatterns on Motor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Motor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Motor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Motor value)  $default,){
final _that = this;
switch (_that) {
case _Motor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Motor value)?  $default,){
final _that = this;
switch (_that) {
case _Motor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ownerId,  String nickname,  String plateNumber,  int? year,  String? photoUrl,  String modelId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Motor() when $default != null:
return $default(_that.id,_that.ownerId,_that.nickname,_that.plateNumber,_that.year,_that.photoUrl,_that.modelId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ownerId,  String nickname,  String plateNumber,  int? year,  String? photoUrl,  String modelId)  $default,) {final _that = this;
switch (_that) {
case _Motor():
return $default(_that.id,_that.ownerId,_that.nickname,_that.plateNumber,_that.year,_that.photoUrl,_that.modelId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ownerId,  String nickname,  String plateNumber,  int? year,  String? photoUrl,  String modelId)?  $default,) {final _that = this;
switch (_that) {
case _Motor() when $default != null:
return $default(_that.id,_that.ownerId,_that.nickname,_that.plateNumber,_that.year,_that.photoUrl,_that.modelId);case _:
  return null;

}
}

}

/// @nodoc


class _Motor extends Motor {
  const _Motor({required this.id, required this.ownerId, required this.nickname, required this.plateNumber, this.year, this.photoUrl, required this.modelId}): super._();
  

@override final  String id;
@override final  String ownerId;
@override final  String nickname;
@override final  String plateNumber;
@override final  int? year;
@override final  String? photoUrl;
@override final  String modelId;

/// Create a copy of Motor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MotorCopyWith<_Motor> get copyWith => __$MotorCopyWithImpl<_Motor>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Motor&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.plateNumber, plateNumber) || other.plateNumber == plateNumber)&&(identical(other.year, year) || other.year == year)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.modelId, modelId) || other.modelId == modelId));
}


@override
int get hashCode => Object.hash(runtimeType,id,ownerId,nickname,plateNumber,year,photoUrl,modelId);

@override
String toString() {
  return 'Motor(id: $id, ownerId: $ownerId, nickname: $nickname, plateNumber: $plateNumber, year: $year, photoUrl: $photoUrl, modelId: $modelId)';
}


}

/// @nodoc
abstract mixin class _$MotorCopyWith<$Res> implements $MotorCopyWith<$Res> {
  factory _$MotorCopyWith(_Motor value, $Res Function(_Motor) _then) = __$MotorCopyWithImpl;
@override @useResult
$Res call({
 String id, String ownerId, String nickname, String plateNumber, int? year, String? photoUrl, String modelId
});




}
/// @nodoc
class __$MotorCopyWithImpl<$Res>
    implements _$MotorCopyWith<$Res> {
  __$MotorCopyWithImpl(this._self, this._then);

  final _Motor _self;
  final $Res Function(_Motor) _then;

/// Create a copy of Motor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerId = null,Object? nickname = null,Object? plateNumber = null,Object? year = freezed,Object? photoUrl = freezed,Object? modelId = null,}) {
  return _then(_Motor(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,plateNumber: null == plateNumber ? _self.plateNumber : plateNumber // ignore: cast_nullable_to_non_nullable
as String,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,modelId: null == modelId ? _self.modelId : modelId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
