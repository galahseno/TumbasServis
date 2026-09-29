import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor_model.dart';

part 'motor_form_state.freezed.dart';

enum MotorFormField { nickname, model, plate, year }

@freezed
abstract class MotorFormState with _$MotorFormState {
  const factory MotorFormState({
    @Default(false) bool isLoading,
    @Default(false) bool isEditMode,
    String? motorId,
    String? ownerId,
    @Default('') String nickname,
    MotorModel? selectedModel,
    @Default('') String plateNumber,
    @Default('') String year,
    String? photoPath,
    @Default(<MotorModel>[]) List<MotorModel> models,
    String? nicknameError,
    String? modelError,
    String? plateError,
    String? yearError,
    @Default(false) bool isSaving,
    @Default(false) bool saveError,
    @Default(false) bool isDirty,
    String? pendingSnackbarMessage,
  }) = _MotorFormState;

  const MotorFormState._();

  bool get hasPhoto => photoPath != null;

  MotorFormField? get firstInvalidField {
    if (nicknameError != null) return MotorFormField.nickname;
    if (modelError != null) return MotorFormField.model;
    if (plateError != null) return MotorFormField.plate;
    if (yearError != null) return MotorFormField.year;
    return null;
  }
}
