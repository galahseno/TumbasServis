// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ulasan_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MechanicRatingItem {

 String get mechanicId; String get name; String get initial; String get unitsLabel;
/// Create a copy of MechanicRatingItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MechanicRatingItemCopyWith<MechanicRatingItem> get copyWith => _$MechanicRatingItemCopyWithImpl<MechanicRatingItem>(this as MechanicRatingItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MechanicRatingItem&&(identical(other.mechanicId, mechanicId) || other.mechanicId == mechanicId)&&(identical(other.name, name) || other.name == name)&&(identical(other.initial, initial) || other.initial == initial)&&(identical(other.unitsLabel, unitsLabel) || other.unitsLabel == unitsLabel));
}


@override
int get hashCode => Object.hash(runtimeType,mechanicId,name,initial,unitsLabel);

@override
String toString() {
  return 'MechanicRatingItem(mechanicId: $mechanicId, name: $name, initial: $initial, unitsLabel: $unitsLabel)';
}


}

/// @nodoc
abstract mixin class $MechanicRatingItemCopyWith<$Res>  {
  factory $MechanicRatingItemCopyWith(MechanicRatingItem value, $Res Function(MechanicRatingItem) _then) = _$MechanicRatingItemCopyWithImpl;
@useResult
$Res call({
 String mechanicId, String name, String initial, String unitsLabel
});




}
/// @nodoc
class _$MechanicRatingItemCopyWithImpl<$Res>
    implements $MechanicRatingItemCopyWith<$Res> {
  _$MechanicRatingItemCopyWithImpl(this._self, this._then);

  final MechanicRatingItem _self;
  final $Res Function(MechanicRatingItem) _then;

/// Create a copy of MechanicRatingItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mechanicId = null,Object? name = null,Object? initial = null,Object? unitsLabel = null,}) {
  return _then(_self.copyWith(
mechanicId: null == mechanicId ? _self.mechanicId : mechanicId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,initial: null == initial ? _self.initial : initial // ignore: cast_nullable_to_non_nullable
as String,unitsLabel: null == unitsLabel ? _self.unitsLabel : unitsLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MechanicRatingItem].
extension MechanicRatingItemPatterns on MechanicRatingItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MechanicRatingItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MechanicRatingItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MechanicRatingItem value)  $default,){
final _that = this;
switch (_that) {
case _MechanicRatingItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MechanicRatingItem value)?  $default,){
final _that = this;
switch (_that) {
case _MechanicRatingItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String mechanicId,  String name,  String initial,  String unitsLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MechanicRatingItem() when $default != null:
return $default(_that.mechanicId,_that.name,_that.initial,_that.unitsLabel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String mechanicId,  String name,  String initial,  String unitsLabel)  $default,) {final _that = this;
switch (_that) {
case _MechanicRatingItem():
return $default(_that.mechanicId,_that.name,_that.initial,_that.unitsLabel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String mechanicId,  String name,  String initial,  String unitsLabel)?  $default,) {final _that = this;
switch (_that) {
case _MechanicRatingItem() when $default != null:
return $default(_that.mechanicId,_that.name,_that.initial,_that.unitsLabel);case _:
  return null;

}
}

}

/// @nodoc


class _MechanicRatingItem implements MechanicRatingItem {
  const _MechanicRatingItem({required this.mechanicId, required this.name, required this.initial, required this.unitsLabel});
  

@override final  String mechanicId;
@override final  String name;
@override final  String initial;
@override final  String unitsLabel;

/// Create a copy of MechanicRatingItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MechanicRatingItemCopyWith<_MechanicRatingItem> get copyWith => __$MechanicRatingItemCopyWithImpl<_MechanicRatingItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MechanicRatingItem&&(identical(other.mechanicId, mechanicId) || other.mechanicId == mechanicId)&&(identical(other.name, name) || other.name == name)&&(identical(other.initial, initial) || other.initial == initial)&&(identical(other.unitsLabel, unitsLabel) || other.unitsLabel == unitsLabel));
}


@override
int get hashCode => Object.hash(runtimeType,mechanicId,name,initial,unitsLabel);

@override
String toString() {
  return 'MechanicRatingItem(mechanicId: $mechanicId, name: $name, initial: $initial, unitsLabel: $unitsLabel)';
}


}

/// @nodoc
abstract mixin class _$MechanicRatingItemCopyWith<$Res> implements $MechanicRatingItemCopyWith<$Res> {
  factory _$MechanicRatingItemCopyWith(_MechanicRatingItem value, $Res Function(_MechanicRatingItem) _then) = __$MechanicRatingItemCopyWithImpl;
@override @useResult
$Res call({
 String mechanicId, String name, String initial, String unitsLabel
});




}
/// @nodoc
class __$MechanicRatingItemCopyWithImpl<$Res>
    implements _$MechanicRatingItemCopyWith<$Res> {
  __$MechanicRatingItemCopyWithImpl(this._self, this._then);

  final _MechanicRatingItem _self;
  final $Res Function(_MechanicRatingItem) _then;

/// Create a copy of MechanicRatingItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mechanicId = null,Object? name = null,Object? initial = null,Object? unitsLabel = null,}) {
  return _then(_MechanicRatingItem(
mechanicId: null == mechanicId ? _self.mechanicId : mechanicId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,initial: null == initial ? _self.initial : initial // ignore: cast_nullable_to_non_nullable
as String,unitsLabel: null == unitsLabel ? _self.unitsLabel : unitsLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$UlasanState {

 bool get isLoading; bool get hasError; bool get blockedUnpaid; String get workshopName; List<MechanicRatingItem> get mechanics; int get workshopRating; Map<String, int> get mechanicRatings; String get comment; bool get ratingError; bool get isSubmitting; Review? get submitted;
/// Create a copy of UlasanState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UlasanStateCopyWith<UlasanState> get copyWith => _$UlasanStateCopyWithImpl<UlasanState>(this as UlasanState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UlasanState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.blockedUnpaid, blockedUnpaid) || other.blockedUnpaid == blockedUnpaid)&&(identical(other.workshopName, workshopName) || other.workshopName == workshopName)&&const DeepCollectionEquality().equals(other.mechanics, mechanics)&&(identical(other.workshopRating, workshopRating) || other.workshopRating == workshopRating)&&const DeepCollectionEquality().equals(other.mechanicRatings, mechanicRatings)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.ratingError, ratingError) || other.ratingError == ratingError)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.submitted, submitted) || other.submitted == submitted));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,blockedUnpaid,workshopName,const DeepCollectionEquality().hash(mechanics),workshopRating,const DeepCollectionEquality().hash(mechanicRatings),comment,ratingError,isSubmitting,submitted);

@override
String toString() {
  return 'UlasanState(isLoading: $isLoading, hasError: $hasError, blockedUnpaid: $blockedUnpaid, workshopName: $workshopName, mechanics: $mechanics, workshopRating: $workshopRating, mechanicRatings: $mechanicRatings, comment: $comment, ratingError: $ratingError, isSubmitting: $isSubmitting, submitted: $submitted)';
}


}

/// @nodoc
abstract mixin class $UlasanStateCopyWith<$Res>  {
  factory $UlasanStateCopyWith(UlasanState value, $Res Function(UlasanState) _then) = _$UlasanStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool hasError, bool blockedUnpaid, String workshopName, List<MechanicRatingItem> mechanics, int workshopRating, Map<String, int> mechanicRatings, String comment, bool ratingError, bool isSubmitting, Review? submitted
});


$ReviewCopyWith<$Res>? get submitted;

}
/// @nodoc
class _$UlasanStateCopyWithImpl<$Res>
    implements $UlasanStateCopyWith<$Res> {
  _$UlasanStateCopyWithImpl(this._self, this._then);

  final UlasanState _self;
  final $Res Function(UlasanState) _then;

/// Create a copy of UlasanState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? hasError = null,Object? blockedUnpaid = null,Object? workshopName = null,Object? mechanics = null,Object? workshopRating = null,Object? mechanicRatings = null,Object? comment = null,Object? ratingError = null,Object? isSubmitting = null,Object? submitted = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,blockedUnpaid: null == blockedUnpaid ? _self.blockedUnpaid : blockedUnpaid // ignore: cast_nullable_to_non_nullable
as bool,workshopName: null == workshopName ? _self.workshopName : workshopName // ignore: cast_nullable_to_non_nullable
as String,mechanics: null == mechanics ? _self.mechanics : mechanics // ignore: cast_nullable_to_non_nullable
as List<MechanicRatingItem>,workshopRating: null == workshopRating ? _self.workshopRating : workshopRating // ignore: cast_nullable_to_non_nullable
as int,mechanicRatings: null == mechanicRatings ? _self.mechanicRatings : mechanicRatings // ignore: cast_nullable_to_non_nullable
as Map<String, int>,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,ratingError: null == ratingError ? _self.ratingError : ratingError // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,submitted: freezed == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as Review?,
  ));
}
/// Create a copy of UlasanState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReviewCopyWith<$Res>? get submitted {
    if (_self.submitted == null) {
    return null;
  }

  return $ReviewCopyWith<$Res>(_self.submitted!, (value) {
    return _then(_self.copyWith(submitted: value));
  });
}
}


/// Adds pattern-matching-related methods to [UlasanState].
extension UlasanStatePatterns on UlasanState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UlasanState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UlasanState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UlasanState value)  $default,){
final _that = this;
switch (_that) {
case _UlasanState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UlasanState value)?  $default,){
final _that = this;
switch (_that) {
case _UlasanState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  bool blockedUnpaid,  String workshopName,  List<MechanicRatingItem> mechanics,  int workshopRating,  Map<String, int> mechanicRatings,  String comment,  bool ratingError,  bool isSubmitting,  Review? submitted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UlasanState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.blockedUnpaid,_that.workshopName,_that.mechanics,_that.workshopRating,_that.mechanicRatings,_that.comment,_that.ratingError,_that.isSubmitting,_that.submitted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  bool blockedUnpaid,  String workshopName,  List<MechanicRatingItem> mechanics,  int workshopRating,  Map<String, int> mechanicRatings,  String comment,  bool ratingError,  bool isSubmitting,  Review? submitted)  $default,) {final _that = this;
switch (_that) {
case _UlasanState():
return $default(_that.isLoading,_that.hasError,_that.blockedUnpaid,_that.workshopName,_that.mechanics,_that.workshopRating,_that.mechanicRatings,_that.comment,_that.ratingError,_that.isSubmitting,_that.submitted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool hasError,  bool blockedUnpaid,  String workshopName,  List<MechanicRatingItem> mechanics,  int workshopRating,  Map<String, int> mechanicRatings,  String comment,  bool ratingError,  bool isSubmitting,  Review? submitted)?  $default,) {final _that = this;
switch (_that) {
case _UlasanState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.blockedUnpaid,_that.workshopName,_that.mechanics,_that.workshopRating,_that.mechanicRatings,_that.comment,_that.ratingError,_that.isSubmitting,_that.submitted);case _:
  return null;

}
}

}

/// @nodoc


class _UlasanState extends UlasanState {
  const _UlasanState({this.isLoading = true, this.hasError = false, this.blockedUnpaid = false, this.workshopName = '', final  List<MechanicRatingItem> mechanics = const <MechanicRatingItem>[], this.workshopRating = 0, final  Map<String, int> mechanicRatings = const <String, int>{}, this.comment = '', this.ratingError = false, this.isSubmitting = false, this.submitted}): _mechanics = mechanics,_mechanicRatings = mechanicRatings,super._();
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool hasError;
@override@JsonKey() final  bool blockedUnpaid;
@override@JsonKey() final  String workshopName;
 final  List<MechanicRatingItem> _mechanics;
@override@JsonKey() List<MechanicRatingItem> get mechanics {
  if (_mechanics is EqualUnmodifiableListView) return _mechanics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mechanics);
}

@override@JsonKey() final  int workshopRating;
 final  Map<String, int> _mechanicRatings;
@override@JsonKey() Map<String, int> get mechanicRatings {
  if (_mechanicRatings is EqualUnmodifiableMapView) return _mechanicRatings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_mechanicRatings);
}

@override@JsonKey() final  String comment;
@override@JsonKey() final  bool ratingError;
@override@JsonKey() final  bool isSubmitting;
@override final  Review? submitted;

/// Create a copy of UlasanState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UlasanStateCopyWith<_UlasanState> get copyWith => __$UlasanStateCopyWithImpl<_UlasanState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UlasanState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.blockedUnpaid, blockedUnpaid) || other.blockedUnpaid == blockedUnpaid)&&(identical(other.workshopName, workshopName) || other.workshopName == workshopName)&&const DeepCollectionEquality().equals(other._mechanics, _mechanics)&&(identical(other.workshopRating, workshopRating) || other.workshopRating == workshopRating)&&const DeepCollectionEquality().equals(other._mechanicRatings, _mechanicRatings)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.ratingError, ratingError) || other.ratingError == ratingError)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.submitted, submitted) || other.submitted == submitted));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,blockedUnpaid,workshopName,const DeepCollectionEquality().hash(_mechanics),workshopRating,const DeepCollectionEquality().hash(_mechanicRatings),comment,ratingError,isSubmitting,submitted);

@override
String toString() {
  return 'UlasanState(isLoading: $isLoading, hasError: $hasError, blockedUnpaid: $blockedUnpaid, workshopName: $workshopName, mechanics: $mechanics, workshopRating: $workshopRating, mechanicRatings: $mechanicRatings, comment: $comment, ratingError: $ratingError, isSubmitting: $isSubmitting, submitted: $submitted)';
}


}

/// @nodoc
abstract mixin class _$UlasanStateCopyWith<$Res> implements $UlasanStateCopyWith<$Res> {
  factory _$UlasanStateCopyWith(_UlasanState value, $Res Function(_UlasanState) _then) = __$UlasanStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool hasError, bool blockedUnpaid, String workshopName, List<MechanicRatingItem> mechanics, int workshopRating, Map<String, int> mechanicRatings, String comment, bool ratingError, bool isSubmitting, Review? submitted
});


@override $ReviewCopyWith<$Res>? get submitted;

}
/// @nodoc
class __$UlasanStateCopyWithImpl<$Res>
    implements _$UlasanStateCopyWith<$Res> {
  __$UlasanStateCopyWithImpl(this._self, this._then);

  final _UlasanState _self;
  final $Res Function(_UlasanState) _then;

/// Create a copy of UlasanState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? hasError = null,Object? blockedUnpaid = null,Object? workshopName = null,Object? mechanics = null,Object? workshopRating = null,Object? mechanicRatings = null,Object? comment = null,Object? ratingError = null,Object? isSubmitting = null,Object? submitted = freezed,}) {
  return _then(_UlasanState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,blockedUnpaid: null == blockedUnpaid ? _self.blockedUnpaid : blockedUnpaid // ignore: cast_nullable_to_non_nullable
as bool,workshopName: null == workshopName ? _self.workshopName : workshopName // ignore: cast_nullable_to_non_nullable
as String,mechanics: null == mechanics ? _self._mechanics : mechanics // ignore: cast_nullable_to_non_nullable
as List<MechanicRatingItem>,workshopRating: null == workshopRating ? _self.workshopRating : workshopRating // ignore: cast_nullable_to_non_nullable
as int,mechanicRatings: null == mechanicRatings ? _self._mechanicRatings : mechanicRatings // ignore: cast_nullable_to_non_nullable
as Map<String, int>,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,ratingError: null == ratingError ? _self.ratingError : ratingError // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,submitted: freezed == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as Review?,
  ));
}

/// Create a copy of UlasanState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReviewCopyWith<$Res>? get submitted {
    if (_self.submitted == null) {
    return null;
  }

  return $ReviewCopyWith<$Res>(_self.submitted!, (value) {
    return _then(_self.copyWith(submitted: value));
  });
}
}

// dart format on
