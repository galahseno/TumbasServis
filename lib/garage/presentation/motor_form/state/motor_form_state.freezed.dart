// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'motor_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MotorFormState {

 bool get isLoading; bool get isEditMode; String? get motorId; String? get ownerId; String get nickname; MotorModel? get selectedModel; String get plateNumber; String get year; String? get photoPath; List<MotorModel> get models; String? get nicknameError; String? get modelError; String? get plateError; String? get yearError; bool get isSaving; bool get saveError; bool get isDirty; String? get pendingSnackbarMessage;
/// Create a copy of MotorFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MotorFormStateCopyWith<MotorFormState> get copyWith => _$MotorFormStateCopyWithImpl<MotorFormState>(this as MotorFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MotorFormState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isEditMode, isEditMode) || other.isEditMode == isEditMode)&&(identical(other.motorId, motorId) || other.motorId == motorId)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.selectedModel, selectedModel) || other.selectedModel == selectedModel)&&(identical(other.plateNumber, plateNumber) || other.plateNumber == plateNumber)&&(identical(other.year, year) || other.year == year)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&const DeepCollectionEquality().equals(other.models, models)&&(identical(other.nicknameError, nicknameError) || other.nicknameError == nicknameError)&&(identical(other.modelError, modelError) || other.modelError == modelError)&&(identical(other.plateError, plateError) || other.plateError == plateError)&&(identical(other.yearError, yearError) || other.yearError == yearError)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.saveError, saveError) || other.saveError == saveError)&&(identical(other.isDirty, isDirty) || other.isDirty == isDirty)&&(identical(other.pendingSnackbarMessage, pendingSnackbarMessage) || other.pendingSnackbarMessage == pendingSnackbarMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isEditMode,motorId,ownerId,nickname,selectedModel,plateNumber,year,photoPath,const DeepCollectionEquality().hash(models),nicknameError,modelError,plateError,yearError,isSaving,saveError,isDirty,pendingSnackbarMessage);

@override
String toString() {
  return 'MotorFormState(isLoading: $isLoading, isEditMode: $isEditMode, motorId: $motorId, ownerId: $ownerId, nickname: $nickname, selectedModel: $selectedModel, plateNumber: $plateNumber, year: $year, photoPath: $photoPath, models: $models, nicknameError: $nicknameError, modelError: $modelError, plateError: $plateError, yearError: $yearError, isSaving: $isSaving, saveError: $saveError, isDirty: $isDirty, pendingSnackbarMessage: $pendingSnackbarMessage)';
}


}

/// @nodoc
abstract mixin class $MotorFormStateCopyWith<$Res>  {
  factory $MotorFormStateCopyWith(MotorFormState value, $Res Function(MotorFormState) _then) = _$MotorFormStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isEditMode, String? motorId, String? ownerId, String nickname, MotorModel? selectedModel, String plateNumber, String year, String? photoPath, List<MotorModel> models, String? nicknameError, String? modelError, String? plateError, String? yearError, bool isSaving, bool saveError, bool isDirty, String? pendingSnackbarMessage
});




}
/// @nodoc
class _$MotorFormStateCopyWithImpl<$Res>
    implements $MotorFormStateCopyWith<$Res> {
  _$MotorFormStateCopyWithImpl(this._self, this._then);

  final MotorFormState _self;
  final $Res Function(MotorFormState) _then;

/// Create a copy of MotorFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isEditMode = null,Object? motorId = freezed,Object? ownerId = freezed,Object? nickname = null,Object? selectedModel = freezed,Object? plateNumber = null,Object? year = null,Object? photoPath = freezed,Object? models = null,Object? nicknameError = freezed,Object? modelError = freezed,Object? plateError = freezed,Object? yearError = freezed,Object? isSaving = null,Object? saveError = null,Object? isDirty = null,Object? pendingSnackbarMessage = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isEditMode: null == isEditMode ? _self.isEditMode : isEditMode // ignore: cast_nullable_to_non_nullable
as bool,motorId: freezed == motorId ? _self.motorId : motorId // ignore: cast_nullable_to_non_nullable
as String?,ownerId: freezed == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String?,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,selectedModel: freezed == selectedModel ? _self.selectedModel : selectedModel // ignore: cast_nullable_to_non_nullable
as MotorModel?,plateNumber: null == plateNumber ? _self.plateNumber : plateNumber // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as String,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,models: null == models ? _self.models : models // ignore: cast_nullable_to_non_nullable
as List<MotorModel>,nicknameError: freezed == nicknameError ? _self.nicknameError : nicknameError // ignore: cast_nullable_to_non_nullable
as String?,modelError: freezed == modelError ? _self.modelError : modelError // ignore: cast_nullable_to_non_nullable
as String?,plateError: freezed == plateError ? _self.plateError : plateError // ignore: cast_nullable_to_non_nullable
as String?,yearError: freezed == yearError ? _self.yearError : yearError // ignore: cast_nullable_to_non_nullable
as String?,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,saveError: null == saveError ? _self.saveError : saveError // ignore: cast_nullable_to_non_nullable
as bool,isDirty: null == isDirty ? _self.isDirty : isDirty // ignore: cast_nullable_to_non_nullable
as bool,pendingSnackbarMessage: freezed == pendingSnackbarMessage ? _self.pendingSnackbarMessage : pendingSnackbarMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MotorFormState].
extension MotorFormStatePatterns on MotorFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MotorFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MotorFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MotorFormState value)  $default,){
final _that = this;
switch (_that) {
case _MotorFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MotorFormState value)?  $default,){
final _that = this;
switch (_that) {
case _MotorFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isEditMode,  String? motorId,  String? ownerId,  String nickname,  MotorModel? selectedModel,  String plateNumber,  String year,  String? photoPath,  List<MotorModel> models,  String? nicknameError,  String? modelError,  String? plateError,  String? yearError,  bool isSaving,  bool saveError,  bool isDirty,  String? pendingSnackbarMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MotorFormState() when $default != null:
return $default(_that.isLoading,_that.isEditMode,_that.motorId,_that.ownerId,_that.nickname,_that.selectedModel,_that.plateNumber,_that.year,_that.photoPath,_that.models,_that.nicknameError,_that.modelError,_that.plateError,_that.yearError,_that.isSaving,_that.saveError,_that.isDirty,_that.pendingSnackbarMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isEditMode,  String? motorId,  String? ownerId,  String nickname,  MotorModel? selectedModel,  String plateNumber,  String year,  String? photoPath,  List<MotorModel> models,  String? nicknameError,  String? modelError,  String? plateError,  String? yearError,  bool isSaving,  bool saveError,  bool isDirty,  String? pendingSnackbarMessage)  $default,) {final _that = this;
switch (_that) {
case _MotorFormState():
return $default(_that.isLoading,_that.isEditMode,_that.motorId,_that.ownerId,_that.nickname,_that.selectedModel,_that.plateNumber,_that.year,_that.photoPath,_that.models,_that.nicknameError,_that.modelError,_that.plateError,_that.yearError,_that.isSaving,_that.saveError,_that.isDirty,_that.pendingSnackbarMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isEditMode,  String? motorId,  String? ownerId,  String nickname,  MotorModel? selectedModel,  String plateNumber,  String year,  String? photoPath,  List<MotorModel> models,  String? nicknameError,  String? modelError,  String? plateError,  String? yearError,  bool isSaving,  bool saveError,  bool isDirty,  String? pendingSnackbarMessage)?  $default,) {final _that = this;
switch (_that) {
case _MotorFormState() when $default != null:
return $default(_that.isLoading,_that.isEditMode,_that.motorId,_that.ownerId,_that.nickname,_that.selectedModel,_that.plateNumber,_that.year,_that.photoPath,_that.models,_that.nicknameError,_that.modelError,_that.plateError,_that.yearError,_that.isSaving,_that.saveError,_that.isDirty,_that.pendingSnackbarMessage);case _:
  return null;

}
}

}

/// @nodoc


class _MotorFormState extends MotorFormState {
  const _MotorFormState({this.isLoading = false, this.isEditMode = false, this.motorId, this.ownerId, this.nickname = '', this.selectedModel, this.plateNumber = '', this.year = '', this.photoPath, final  List<MotorModel> models = const <MotorModel>[], this.nicknameError, this.modelError, this.plateError, this.yearError, this.isSaving = false, this.saveError = false, this.isDirty = false, this.pendingSnackbarMessage}): _models = models,super._();
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isEditMode;
@override final  String? motorId;
@override final  String? ownerId;
@override@JsonKey() final  String nickname;
@override final  MotorModel? selectedModel;
@override@JsonKey() final  String plateNumber;
@override@JsonKey() final  String year;
@override final  String? photoPath;
 final  List<MotorModel> _models;
@override@JsonKey() List<MotorModel> get models {
  if (_models is EqualUnmodifiableListView) return _models;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_models);
}

@override final  String? nicknameError;
@override final  String? modelError;
@override final  String? plateError;
@override final  String? yearError;
@override@JsonKey() final  bool isSaving;
@override@JsonKey() final  bool saveError;
@override@JsonKey() final  bool isDirty;
@override final  String? pendingSnackbarMessage;

/// Create a copy of MotorFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MotorFormStateCopyWith<_MotorFormState> get copyWith => __$MotorFormStateCopyWithImpl<_MotorFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MotorFormState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isEditMode, isEditMode) || other.isEditMode == isEditMode)&&(identical(other.motorId, motorId) || other.motorId == motorId)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.selectedModel, selectedModel) || other.selectedModel == selectedModel)&&(identical(other.plateNumber, plateNumber) || other.plateNumber == plateNumber)&&(identical(other.year, year) || other.year == year)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&const DeepCollectionEquality().equals(other._models, _models)&&(identical(other.nicknameError, nicknameError) || other.nicknameError == nicknameError)&&(identical(other.modelError, modelError) || other.modelError == modelError)&&(identical(other.plateError, plateError) || other.plateError == plateError)&&(identical(other.yearError, yearError) || other.yearError == yearError)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.saveError, saveError) || other.saveError == saveError)&&(identical(other.isDirty, isDirty) || other.isDirty == isDirty)&&(identical(other.pendingSnackbarMessage, pendingSnackbarMessage) || other.pendingSnackbarMessage == pendingSnackbarMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isEditMode,motorId,ownerId,nickname,selectedModel,plateNumber,year,photoPath,const DeepCollectionEquality().hash(_models),nicknameError,modelError,plateError,yearError,isSaving,saveError,isDirty,pendingSnackbarMessage);

@override
String toString() {
  return 'MotorFormState(isLoading: $isLoading, isEditMode: $isEditMode, motorId: $motorId, ownerId: $ownerId, nickname: $nickname, selectedModel: $selectedModel, plateNumber: $plateNumber, year: $year, photoPath: $photoPath, models: $models, nicknameError: $nicknameError, modelError: $modelError, plateError: $plateError, yearError: $yearError, isSaving: $isSaving, saveError: $saveError, isDirty: $isDirty, pendingSnackbarMessage: $pendingSnackbarMessage)';
}


}

/// @nodoc
abstract mixin class _$MotorFormStateCopyWith<$Res> implements $MotorFormStateCopyWith<$Res> {
  factory _$MotorFormStateCopyWith(_MotorFormState value, $Res Function(_MotorFormState) _then) = __$MotorFormStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isEditMode, String? motorId, String? ownerId, String nickname, MotorModel? selectedModel, String plateNumber, String year, String? photoPath, List<MotorModel> models, String? nicknameError, String? modelError, String? plateError, String? yearError, bool isSaving, bool saveError, bool isDirty, String? pendingSnackbarMessage
});




}
/// @nodoc
class __$MotorFormStateCopyWithImpl<$Res>
    implements _$MotorFormStateCopyWith<$Res> {
  __$MotorFormStateCopyWithImpl(this._self, this._then);

  final _MotorFormState _self;
  final $Res Function(_MotorFormState) _then;

/// Create a copy of MotorFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isEditMode = null,Object? motorId = freezed,Object? ownerId = freezed,Object? nickname = null,Object? selectedModel = freezed,Object? plateNumber = null,Object? year = null,Object? photoPath = freezed,Object? models = null,Object? nicknameError = freezed,Object? modelError = freezed,Object? plateError = freezed,Object? yearError = freezed,Object? isSaving = null,Object? saveError = null,Object? isDirty = null,Object? pendingSnackbarMessage = freezed,}) {
  return _then(_MotorFormState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isEditMode: null == isEditMode ? _self.isEditMode : isEditMode // ignore: cast_nullable_to_non_nullable
as bool,motorId: freezed == motorId ? _self.motorId : motorId // ignore: cast_nullable_to_non_nullable
as String?,ownerId: freezed == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String?,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,selectedModel: freezed == selectedModel ? _self.selectedModel : selectedModel // ignore: cast_nullable_to_non_nullable
as MotorModel?,plateNumber: null == plateNumber ? _self.plateNumber : plateNumber // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as String,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,models: null == models ? _self._models : models // ignore: cast_nullable_to_non_nullable
as List<MotorModel>,nicknameError: freezed == nicknameError ? _self.nicknameError : nicknameError // ignore: cast_nullable_to_non_nullable
as String?,modelError: freezed == modelError ? _self.modelError : modelError // ignore: cast_nullable_to_non_nullable
as String?,plateError: freezed == plateError ? _self.plateError : plateError // ignore: cast_nullable_to_non_nullable
as String?,yearError: freezed == yearError ? _self.yearError : yearError // ignore: cast_nullable_to_non_nullable
as String?,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,saveError: null == saveError ? _self.saveError : saveError // ignore: cast_nullable_to_non_nullable
as bool,isDirty: null == isDirty ? _self.isDirty : isDirty // ignore: cast_nullable_to_non_nullable
as bool,pendingSnackbarMessage: freezed == pendingSnackbarMessage ? _self.pendingSnackbarMessage : pendingSnackbarMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
