import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/auth/data/di/auth_data_module.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/data/service/photo_picker_service.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor_model.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/user/user.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';
import 'package:tumbas_servis/garage/presentation/motor_form/state/motor_form_state.dart';
import 'package:tumbas_servis/garage/presentation/utils/motor_display.dart';

class MotorFormViewModel extends Notifier<MotorFormState> {
  static const minYear = 1990;
  static const maxYear = 2026;

  bool _initialized = false;
  late String _newMotorKey;
  ({
    String nickname,
    String? modelId,
    String plate,
    String year,
    String? photoPath,
  })
  _initial = (
    nickname: '',
    modelId: null,
    plate: '',
    year: '',
    photoPath: null,
  );
  final Set<String> _sessionPhotos = {};

  @override
  MotorFormState build() {
    _newMotorKey = 'motor_${DateTime.now().microsecondsSinceEpoch}';
    return const MotorFormState();
  }

  Future<void> initialize({Motor? existingMotor}) async {
    if (_initialized) return;
    _initialized = true;

    state = state.copyWith(
      isLoading: true,
      isEditMode: existingMotor != null,
      motorId: existingMotor?.id,
      ownerId: existingMotor?.ownerId,
      nickname: existingMotor?.nickname ?? '',
      plateNumber: existingMotor?.plateNumber ?? '',
      year: existingMotor?.year?.toString() ?? '',
      photoPath: existingMotor?.photoUrl,
    );

    final modelsResult = await ref
        .read(garageRepositoryProvider)
        .getMotorModels();
    User? user;
    if (existingMotor == null) {
      final userResult = await ref
          .read(sessionRepositoryProvider)
          .currentUser();
      if (userResult is Ok<User?>) user = userResult.value;
    }
    if (!ref.mounted) return;

    final models = modelsResult is Ok<List<MotorModel>>
        ? _pickerModels(modelsResult.value)
        : const <MotorModel>[];
    final selected = existingMotor == null
        ? null
        : _findModel(modelsResult, existingMotor.modelId);

    _initial = (
      nickname: state.nickname,
      modelId: existingMotor?.modelId,
      plate: state.plateNumber,
      year: state.year,
      photoPath: state.photoPath,
    );
    state = state.copyWith(
      isLoading: false,
      models: models,
      selectedModel: selected,
      ownerId: existingMotor?.ownerId ?? user?.id,
    );
  }

  List<MotorModel> _pickerModels(List<MotorModel> all) {
    final filtered = all.where((m) => pickerBrands.contains(m.brand)).toList();
    filtered.sort((a, b) {
      final byBrand = pickerBrands
          .indexOf(a.brand)
          .compareTo(pickerBrands.indexOf(b.brand));
      return byBrand != 0 ? byBrand : a.name.compareTo(b.name);
    });
    return filtered;
  }

  MotorModel? _findModel(Result<List<MotorModel>> result, String modelId) {
    if (result is! Ok<List<MotorModel>>) return null;
    for (final model in result.value) {
      if (model.id == modelId) return model;
    }
    return null;
  }

  void _recomputeDirty() {
    state = state.copyWith(
      isDirty:
          state.nickname != _initial.nickname ||
          state.selectedModel?.id != _initial.modelId ||
          state.plateNumber != _initial.plate ||
          state.year != _initial.year ||
          state.photoPath != _initial.photoPath,
    );
  }

  void updateNickname(String value) {
    state = state.copyWith(nickname: value, nicknameError: null);
    _recomputeDirty();
  }

  void selectModel(MotorModel model) {
    state = state.copyWith(
      selectedModel: model,
      modelError: null,
      nickname: state.nickname.trim().isEmpty ? model.name : state.nickname,
      nicknameError: state.nickname.trim().isEmpty ? null : state.nicknameError,
    );
    _recomputeDirty();
  }

  void updatePlate(String formatted) {
    state = state.copyWith(plateNumber: formatted, plateError: null);
    _recomputeDirty();
  }

  void validatePlateOnBlur() {
    if (state.plateNumber.trim().isEmpty) return;
    state = state.copyWith(plateError: _plateFormatError(state.plateNumber));
  }

  void updateYear(String value) {
    state = state.copyWith(year: value, yearError: null);
    _recomputeDirty();
  }

  void validateYearOnBlur() {
    state = state.copyWith(yearError: _yearError(state.year));
  }

  String? _plateFormatError(String plate) {
    final formatted = Motor.formatPlateNumber(plate);
    return formatted.contains(' ')
        ? null
        : 'Format plat tidak valid. Contoh: AB 1234 XY';
  }

  String? _yearError(String year) {
    if (year.trim().isEmpty) return null;
    final parsed = int.tryParse(year.trim());
    if (parsed == null || parsed < minYear || parsed > maxYear) {
      return 'Tahun $minYear–$maxYear';
    }
    return null;
  }

  Future<void> pickPhoto(PhotoPickSource source) async {
    final service = ref.read(photoPickerServiceProvider);
    final result = await service.pickAndPersist(
      source: source,
      fileNameHint: state.motorId ?? _newMotorKey,
    );
    if (!ref.mounted) return;

    switch (result) {
      case PhotoPicked(:final path):
        await _discardSessionPhoto(state.photoPath);
        _sessionPhotos.add(path);
        state = state.copyWith(photoPath: path);
        _recomputeDirty();
      case PhotoPickCancelled():
        break;
      case PhotoPickPermissionDenied():
        state = state.copyWith(
          pendingSnackbarMessage: source == PhotoPickSource.camera
              ? 'Izin kamera ditolak. Aktifkan di pengaturan.'
              : 'Izin galeri ditolak. Aktifkan di pengaturan.',
        );
      case PhotoPickFailed():
        state = state.copyWith(
          pendingSnackbarMessage: 'Gagal mengambil foto. Coba lagi.',
        );
    }
  }

  Future<void> removePhoto() async {
    await _discardSessionPhoto(state.photoPath);
    if (!ref.mounted) return;
    state = state.copyWith(photoPath: null);
    _recomputeDirty();
  }

  Future<void> _discardSessionPhoto(String? path) async {
    if (path == null || !_sessionPhotos.remove(path)) return;
    await ref.read(photoPickerServiceProvider).deletePhoto(path);
  }

  void clearPendingSnackbar() {
    state = state.copyWith(pendingSnackbarMessage: null);
  }

  Future<bool> submit() async {
    if (state.isSaving) return false;

    final nickname = state.nickname.trim();
    final plate = state.plateNumber.trim();
    state = state.copyWith(
      saveError: false,
      nicknameError: nickname.isEmpty
          ? 'Nama panggilan wajib diisi'
          : (nickname.length > Motor.nicknameMaxLength
                ? 'Maks. ${Motor.nicknameMaxLength} karakter'
                : null),
      modelError: state.selectedModel == null ? 'Pilih model motor' : null,
      plateError: plate.isEmpty
          ? 'Plat nomor wajib diisi'
          : _plateFormatError(plate),
      yearError: _yearError(state.year),
    );
    if (state.firstInvalidField != null) return false;

    final ownerId = state.ownerId;
    if (ownerId == null) {
      state = state.copyWith(saveError: true);
      return false;
    }

    state = state.copyWith(isSaving: true);
    final motor = Motor(
      id: state.motorId ?? _newMotorKey,
      ownerId: ownerId,
      nickname: nickname,
      plateNumber: plate,
      year: int.tryParse(state.year.trim()),
      photoUrl: state.photoPath,
      modelId: state.selectedModel!.id,
    );
    final repository = ref.read(garageRepositoryProvider);
    final result = state.isEditMode
        ? await repository.updateMotor(motor)
        : await repository.addMotor(motor);
    if (!ref.mounted) return false;

    if (result is Ok<Motor>) {
      state = state.copyWith(isSaving: false);
      return true;
    }
    state = state.copyWith(
      isSaving: false,
      plateError: 'Plat ini sudah ada di garasimu',
    );
    return false;
  }
}
