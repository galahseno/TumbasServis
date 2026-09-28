// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeState {

 bool get isLoading; bool get hasError; String get userName; int get unreadCount; List<Motor> get motors; Map<String, UnitStatus> get motorInServiceStatus; List<HomeActiveBookingDisplay> get activeBookings; int get activeBookingsTotalCount; HomeDraftDisplay? get draft; List<Promo> get promos;
/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeStateCopyWith<HomeState> get copyWith => _$HomeStateCopyWithImpl<HomeState>(this as HomeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&const DeepCollectionEquality().equals(other.motors, motors)&&const DeepCollectionEquality().equals(other.motorInServiceStatus, motorInServiceStatus)&&const DeepCollectionEquality().equals(other.activeBookings, activeBookings)&&(identical(other.activeBookingsTotalCount, activeBookingsTotalCount) || other.activeBookingsTotalCount == activeBookingsTotalCount)&&(identical(other.draft, draft) || other.draft == draft)&&const DeepCollectionEquality().equals(other.promos, promos));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,userName,unreadCount,const DeepCollectionEquality().hash(motors),const DeepCollectionEquality().hash(motorInServiceStatus),const DeepCollectionEquality().hash(activeBookings),activeBookingsTotalCount,draft,const DeepCollectionEquality().hash(promos));

@override
String toString() {
  return 'HomeState(isLoading: $isLoading, hasError: $hasError, userName: $userName, unreadCount: $unreadCount, motors: $motors, motorInServiceStatus: $motorInServiceStatus, activeBookings: $activeBookings, activeBookingsTotalCount: $activeBookingsTotalCount, draft: $draft, promos: $promos)';
}


}

/// @nodoc
abstract mixin class $HomeStateCopyWith<$Res>  {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) _then) = _$HomeStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool hasError, String userName, int unreadCount, List<Motor> motors, Map<String, UnitStatus> motorInServiceStatus, List<HomeActiveBookingDisplay> activeBookings, int activeBookingsTotalCount, HomeDraftDisplay? draft, List<Promo> promos
});




}
/// @nodoc
class _$HomeStateCopyWithImpl<$Res>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._self, this._then);

  final HomeState _self;
  final $Res Function(HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? hasError = null,Object? userName = null,Object? unreadCount = null,Object? motors = null,Object? motorInServiceStatus = null,Object? activeBookings = null,Object? activeBookingsTotalCount = null,Object? draft = freezed,Object? promos = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,motors: null == motors ? _self.motors : motors // ignore: cast_nullable_to_non_nullable
as List<Motor>,motorInServiceStatus: null == motorInServiceStatus ? _self.motorInServiceStatus : motorInServiceStatus // ignore: cast_nullable_to_non_nullable
as Map<String, UnitStatus>,activeBookings: null == activeBookings ? _self.activeBookings : activeBookings // ignore: cast_nullable_to_non_nullable
as List<HomeActiveBookingDisplay>,activeBookingsTotalCount: null == activeBookingsTotalCount ? _self.activeBookingsTotalCount : activeBookingsTotalCount // ignore: cast_nullable_to_non_nullable
as int,draft: freezed == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as HomeDraftDisplay?,promos: null == promos ? _self.promos : promos // ignore: cast_nullable_to_non_nullable
as List<Promo>,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeState value)  $default,){
final _that = this;
switch (_that) {
case _HomeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeState value)?  $default,){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  String userName,  int unreadCount,  List<Motor> motors,  Map<String, UnitStatus> motorInServiceStatus,  List<HomeActiveBookingDisplay> activeBookings,  int activeBookingsTotalCount,  HomeDraftDisplay? draft,  List<Promo> promos)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.userName,_that.unreadCount,_that.motors,_that.motorInServiceStatus,_that.activeBookings,_that.activeBookingsTotalCount,_that.draft,_that.promos);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  String userName,  int unreadCount,  List<Motor> motors,  Map<String, UnitStatus> motorInServiceStatus,  List<HomeActiveBookingDisplay> activeBookings,  int activeBookingsTotalCount,  HomeDraftDisplay? draft,  List<Promo> promos)  $default,) {final _that = this;
switch (_that) {
case _HomeState():
return $default(_that.isLoading,_that.hasError,_that.userName,_that.unreadCount,_that.motors,_that.motorInServiceStatus,_that.activeBookings,_that.activeBookingsTotalCount,_that.draft,_that.promos);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool hasError,  String userName,  int unreadCount,  List<Motor> motors,  Map<String, UnitStatus> motorInServiceStatus,  List<HomeActiveBookingDisplay> activeBookings,  int activeBookingsTotalCount,  HomeDraftDisplay? draft,  List<Promo> promos)?  $default,) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.userName,_that.unreadCount,_that.motors,_that.motorInServiceStatus,_that.activeBookings,_that.activeBookingsTotalCount,_that.draft,_that.promos);case _:
  return null;

}
}

}

/// @nodoc


class _HomeState extends HomeState {
  const _HomeState({this.isLoading = true, this.hasError = false, this.userName = '', this.unreadCount = 0, final  List<Motor> motors = const <Motor>[], final  Map<String, UnitStatus> motorInServiceStatus = const <String, UnitStatus>{}, final  List<HomeActiveBookingDisplay> activeBookings = const <HomeActiveBookingDisplay>[], this.activeBookingsTotalCount = 0, this.draft, final  List<Promo> promos = const <Promo>[]}): _motors = motors,_motorInServiceStatus = motorInServiceStatus,_activeBookings = activeBookings,_promos = promos,super._();
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool hasError;
@override@JsonKey() final  String userName;
@override@JsonKey() final  int unreadCount;
 final  List<Motor> _motors;
@override@JsonKey() List<Motor> get motors {
  if (_motors is EqualUnmodifiableListView) return _motors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_motors);
}

 final  Map<String, UnitStatus> _motorInServiceStatus;
@override@JsonKey() Map<String, UnitStatus> get motorInServiceStatus {
  if (_motorInServiceStatus is EqualUnmodifiableMapView) return _motorInServiceStatus;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_motorInServiceStatus);
}

 final  List<HomeActiveBookingDisplay> _activeBookings;
@override@JsonKey() List<HomeActiveBookingDisplay> get activeBookings {
  if (_activeBookings is EqualUnmodifiableListView) return _activeBookings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activeBookings);
}

@override@JsonKey() final  int activeBookingsTotalCount;
@override final  HomeDraftDisplay? draft;
 final  List<Promo> _promos;
@override@JsonKey() List<Promo> get promos {
  if (_promos is EqualUnmodifiableListView) return _promos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_promos);
}


/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeStateCopyWith<_HomeState> get copyWith => __$HomeStateCopyWithImpl<_HomeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&const DeepCollectionEquality().equals(other._motors, _motors)&&const DeepCollectionEquality().equals(other._motorInServiceStatus, _motorInServiceStatus)&&const DeepCollectionEquality().equals(other._activeBookings, _activeBookings)&&(identical(other.activeBookingsTotalCount, activeBookingsTotalCount) || other.activeBookingsTotalCount == activeBookingsTotalCount)&&(identical(other.draft, draft) || other.draft == draft)&&const DeepCollectionEquality().equals(other._promos, _promos));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,userName,unreadCount,const DeepCollectionEquality().hash(_motors),const DeepCollectionEquality().hash(_motorInServiceStatus),const DeepCollectionEquality().hash(_activeBookings),activeBookingsTotalCount,draft,const DeepCollectionEquality().hash(_promos));

@override
String toString() {
  return 'HomeState(isLoading: $isLoading, hasError: $hasError, userName: $userName, unreadCount: $unreadCount, motors: $motors, motorInServiceStatus: $motorInServiceStatus, activeBookings: $activeBookings, activeBookingsTotalCount: $activeBookingsTotalCount, draft: $draft, promos: $promos)';
}


}

/// @nodoc
abstract mixin class _$HomeStateCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory _$HomeStateCopyWith(_HomeState value, $Res Function(_HomeState) _then) = __$HomeStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool hasError, String userName, int unreadCount, List<Motor> motors, Map<String, UnitStatus> motorInServiceStatus, List<HomeActiveBookingDisplay> activeBookings, int activeBookingsTotalCount, HomeDraftDisplay? draft, List<Promo> promos
});




}
/// @nodoc
class __$HomeStateCopyWithImpl<$Res>
    implements _$HomeStateCopyWith<$Res> {
  __$HomeStateCopyWithImpl(this._self, this._then);

  final _HomeState _self;
  final $Res Function(_HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? hasError = null,Object? userName = null,Object? unreadCount = null,Object? motors = null,Object? motorInServiceStatus = null,Object? activeBookings = null,Object? activeBookingsTotalCount = null,Object? draft = freezed,Object? promos = null,}) {
  return _then(_HomeState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,motors: null == motors ? _self._motors : motors // ignore: cast_nullable_to_non_nullable
as List<Motor>,motorInServiceStatus: null == motorInServiceStatus ? _self._motorInServiceStatus : motorInServiceStatus // ignore: cast_nullable_to_non_nullable
as Map<String, UnitStatus>,activeBookings: null == activeBookings ? _self._activeBookings : activeBookings // ignore: cast_nullable_to_non_nullable
as List<HomeActiveBookingDisplay>,activeBookingsTotalCount: null == activeBookingsTotalCount ? _self.activeBookingsTotalCount : activeBookingsTotalCount // ignore: cast_nullable_to_non_nullable
as int,draft: freezed == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as HomeDraftDisplay?,promos: null == promos ? _self._promos : promos // ignore: cast_nullable_to_non_nullable
as List<Promo>,
  ));
}


}

// dart format on
