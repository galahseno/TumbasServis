import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/catalog/presentation/katalog/state/katalog_state.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor_model.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';

String motorCategoryLabel(MotorCategory category) => switch (category) {
  MotorCategory.matic => 'matic',
  MotorCategory.bebek => 'bebek',
  MotorCategory.sport => 'sport',
  MotorCategory.unknown => 'motor',
};

class KatalogViewModel extends Notifier<KatalogState> {
  @override
  KatalogState build() => const KatalogState();

  Future<void> initialize({
    required KatalogMode mode,
    String? modelId,
    String? unitNickname,
    String? unitPlateNumber,
    required Set<String> initialPartIds,
  }) async {
    if (state.initialized) return;
    state = state.copyWith(
      initialized: true,
      mode: mode,
      unitModelId: modelId,
      unitNickname: unitNickname,
      unitPlateNumber: unitPlateNumber,
      stagedPartIds: initialPartIds,
      initialPartIds: initialPartIds,
    );
    await _load();
  }

  Future<void> retry() async {
    state = state.copyWith(isLoading: true, hasError: false);
    await _load();
  }

  Future<void> _load() async {
    final catalogRepo = ref.read(catalogRepositoryProvider);
    final garageRepo = ref.read(garageRepositoryProvider);

    final partsResult = await catalogRepo.getParts();
    if (!ref.mounted) return;
    if (partsResult is Error<List<Part>>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }

    final modelsResult = await garageRepo.getMotorModels();
    if (!ref.mounted) return;
    if (modelsResult is Error<List<MotorModel>>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }

    final motorsResult = await garageRepo.getMotors();
    if (!ref.mounted) return;
    if (motorsResult is Error<List<Motor>>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }

    state = state.copyWith(
      isLoading: false,
      hasError: false,
      parts: (partsResult as Ok<List<Part>>).value,
      motorModelsById: {
        for (final model in (modelsResult as Ok<List<MotorModel>>).value)
          model.id: model,
      },
      garageMotors: (motorsResult as Ok<List<Motor>>).value,
    );
  }

  void setCategory(String category) =>
      state = state.copyWith(selectedCategory: category);

  void setSearchQuery(String query) =>
      state = state.copyWith(searchQuery: query);

  void setCompatOnly(bool value) =>
      state = state.copyWith(compatOnlyEnabled: value);

  void toggleStaged(String partId) {
    final staged = {...state.stagedPartIds};
    if (!staged.remove(partId)) staged.add(partId);
    state = state.copyWith(stagedPartIds: staged);
  }

  bool get isDirty {
    final staged = state.stagedPartIds;
    final initial = state.initialPartIds;
    return staged.length != initial.length || !staged.containsAll(initial);
  }

  bool isCompatible(Part part) {
    final modelId = state.unitModelId;
    if (modelId == null) return true;
    return part.compatibleModelIds.contains(modelId);
  }

  List<MotorModel> _compatibleModels(Part part) => part.compatibleModelIds
      .map((id) => state.motorModelsById[id])
      .whereType<MotorModel>()
      .toList();

  String compatibilityRuleLine(Part part) {
    final models = _compatibleModels(part);
    if (models.isEmpty) return '';
    final categories = models.map((m) => m.category).toSet();
    final ccs = models.map((m) => m.cc).toList()..sort();
    final categoryLabel = categories.length == 1
        ? motorCategoryLabel(categories.first)
        : categories.map(motorCategoryLabel).join(' dan ');
    final ccRange = ccs.first == ccs.last
        ? '${ccs.first} cc'
        : '${ccs.first}–${ccs.last} cc';
    return '$categoryLabel $ccRange';
  }

  String incompatibleReason(Part part) {
    final rule = compatibilityRuleLine(part);
    return rule.isEmpty
        ? 'Tidak cocok untuk motor ini'
        : 'Tidak cocok · untuk $rule';
  }

  List<Part> get visibleParts {
    final query = state.searchQuery.trim().toLowerCase();
    return state.parts.where((part) {
      if (state.selectedCategory != 'Semua' &&
          part.category != state.selectedCategory) {
        return false;
      }
      if (query.isNotEmpty && !part.name.toLowerCase().contains(query)) {
        return false;
      }
      if (state.mode == KatalogMode.select &&
          state.compatOnlyEnabled &&
          !isCompatible(part)) {
        return false;
      }
      return true;
    }).toList();
  }

  int get stagedSubtotal => state.parts
      .where((part) => state.stagedPartIds.contains(part.id))
      .fold(0, (sum, part) => sum + part.price);
}
