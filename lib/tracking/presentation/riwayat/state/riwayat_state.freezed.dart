// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'riwayat_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RiwayatState {

 bool get isLoading; bool get hasError; List<HistoryEntry> get allEntries; RiwayatTab get selectedTab; String? get motorFilterId; String? get motorFilterLabel;
/// Create a copy of RiwayatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RiwayatStateCopyWith<RiwayatState> get copyWith => _$RiwayatStateCopyWithImpl<RiwayatState>(this as RiwayatState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RiwayatState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&const DeepCollectionEquality().equals(other.allEntries, allEntries)&&(identical(other.selectedTab, selectedTab) || other.selectedTab == selectedTab)&&(identical(other.motorFilterId, motorFilterId) || other.motorFilterId == motorFilterId)&&(identical(other.motorFilterLabel, motorFilterLabel) || other.motorFilterLabel == motorFilterLabel));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,const DeepCollectionEquality().hash(allEntries),selectedTab,motorFilterId,motorFilterLabel);

@override
String toString() {
  return 'RiwayatState(isLoading: $isLoading, hasError: $hasError, allEntries: $allEntries, selectedTab: $selectedTab, motorFilterId: $motorFilterId, motorFilterLabel: $motorFilterLabel)';
}


}

/// @nodoc
abstract mixin class $RiwayatStateCopyWith<$Res>  {
  factory $RiwayatStateCopyWith(RiwayatState value, $Res Function(RiwayatState) _then) = _$RiwayatStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool hasError, List<HistoryEntry> allEntries, RiwayatTab selectedTab, String? motorFilterId, String? motorFilterLabel
});




}
/// @nodoc
class _$RiwayatStateCopyWithImpl<$Res>
    implements $RiwayatStateCopyWith<$Res> {
  _$RiwayatStateCopyWithImpl(this._self, this._then);

  final RiwayatState _self;
  final $Res Function(RiwayatState) _then;

/// Create a copy of RiwayatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? hasError = null,Object? allEntries = null,Object? selectedTab = null,Object? motorFilterId = freezed,Object? motorFilterLabel = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,allEntries: null == allEntries ? _self.allEntries : allEntries // ignore: cast_nullable_to_non_nullable
as List<HistoryEntry>,selectedTab: null == selectedTab ? _self.selectedTab : selectedTab // ignore: cast_nullable_to_non_nullable
as RiwayatTab,motorFilterId: freezed == motorFilterId ? _self.motorFilterId : motorFilterId // ignore: cast_nullable_to_non_nullable
as String?,motorFilterLabel: freezed == motorFilterLabel ? _self.motorFilterLabel : motorFilterLabel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RiwayatState].
extension RiwayatStatePatterns on RiwayatState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RiwayatState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RiwayatState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RiwayatState value)  $default,){
final _that = this;
switch (_that) {
case _RiwayatState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RiwayatState value)?  $default,){
final _that = this;
switch (_that) {
case _RiwayatState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  List<HistoryEntry> allEntries,  RiwayatTab selectedTab,  String? motorFilterId,  String? motorFilterLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RiwayatState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.allEntries,_that.selectedTab,_that.motorFilterId,_that.motorFilterLabel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  List<HistoryEntry> allEntries,  RiwayatTab selectedTab,  String? motorFilterId,  String? motorFilterLabel)  $default,) {final _that = this;
switch (_that) {
case _RiwayatState():
return $default(_that.isLoading,_that.hasError,_that.allEntries,_that.selectedTab,_that.motorFilterId,_that.motorFilterLabel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool hasError,  List<HistoryEntry> allEntries,  RiwayatTab selectedTab,  String? motorFilterId,  String? motorFilterLabel)?  $default,) {final _that = this;
switch (_that) {
case _RiwayatState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.allEntries,_that.selectedTab,_that.motorFilterId,_that.motorFilterLabel);case _:
  return null;

}
}

}

/// @nodoc


class _RiwayatState extends RiwayatState {
  const _RiwayatState({this.isLoading = true, this.hasError = false, final  List<HistoryEntry> allEntries = const <HistoryEntry>[], this.selectedTab = RiwayatTab.berlangsung, this.motorFilterId, this.motorFilterLabel}): _allEntries = allEntries,super._();
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool hasError;
 final  List<HistoryEntry> _allEntries;
@override@JsonKey() List<HistoryEntry> get allEntries {
  if (_allEntries is EqualUnmodifiableListView) return _allEntries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allEntries);
}

@override@JsonKey() final  RiwayatTab selectedTab;
@override final  String? motorFilterId;
@override final  String? motorFilterLabel;

/// Create a copy of RiwayatState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RiwayatStateCopyWith<_RiwayatState> get copyWith => __$RiwayatStateCopyWithImpl<_RiwayatState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RiwayatState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&const DeepCollectionEquality().equals(other._allEntries, _allEntries)&&(identical(other.selectedTab, selectedTab) || other.selectedTab == selectedTab)&&(identical(other.motorFilterId, motorFilterId) || other.motorFilterId == motorFilterId)&&(identical(other.motorFilterLabel, motorFilterLabel) || other.motorFilterLabel == motorFilterLabel));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,const DeepCollectionEquality().hash(_allEntries),selectedTab,motorFilterId,motorFilterLabel);

@override
String toString() {
  return 'RiwayatState(isLoading: $isLoading, hasError: $hasError, allEntries: $allEntries, selectedTab: $selectedTab, motorFilterId: $motorFilterId, motorFilterLabel: $motorFilterLabel)';
}


}

/// @nodoc
abstract mixin class _$RiwayatStateCopyWith<$Res> implements $RiwayatStateCopyWith<$Res> {
  factory _$RiwayatStateCopyWith(_RiwayatState value, $Res Function(_RiwayatState) _then) = __$RiwayatStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool hasError, List<HistoryEntry> allEntries, RiwayatTab selectedTab, String? motorFilterId, String? motorFilterLabel
});




}
/// @nodoc
class __$RiwayatStateCopyWithImpl<$Res>
    implements _$RiwayatStateCopyWith<$Res> {
  __$RiwayatStateCopyWithImpl(this._self, this._then);

  final _RiwayatState _self;
  final $Res Function(_RiwayatState) _then;

/// Create a copy of RiwayatState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? hasError = null,Object? allEntries = null,Object? selectedTab = null,Object? motorFilterId = freezed,Object? motorFilterLabel = freezed,}) {
  return _then(_RiwayatState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,allEntries: null == allEntries ? _self._allEntries : allEntries // ignore: cast_nullable_to_non_nullable
as List<HistoryEntry>,selectedTab: null == selectedTab ? _self.selectedTab : selectedTab // ignore: cast_nullable_to_non_nullable
as RiwayatTab,motorFilterId: freezed == motorFilterId ? _self.motorFilterId : motorFilterId // ignore: cast_nullable_to_non_nullable
as String?,motorFilterLabel: freezed == motorFilterLabel ? _self.motorFilterLabel : motorFilterLabel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
