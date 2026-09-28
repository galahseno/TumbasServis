import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor_model.dart';

part 'katalog_state.freezed.dart';

enum KatalogMode { select, browse }

const katalogCategories = [
  'Semua',
  'Oli',
  'Kampas rem',
  'Busi',
  'Aki',
  'Ban',
  'Filter udara',
];

@freezed
abstract class KatalogState with _$KatalogState {
  const factory KatalogState({
    @Default(false) bool initialized,
    @Default(KatalogMode.browse) KatalogMode mode,
    @Default(true) bool isLoading,
    @Default(false) bool hasError,
    @Default(<Part>[]) List<Part> parts,
    @Default(<String, MotorModel>{}) Map<String, MotorModel> motorModelsById,
    @Default(<Motor>[]) List<Motor> garageMotors,
    String? unitModelId,
    String? unitNickname,
    String? unitPlateNumber,
    @Default('Semua') String selectedCategory,
    @Default('') String searchQuery,
    @Default(true) bool compatOnlyEnabled,
    @Default(<String>{}) Set<String> stagedPartIds,
    @Default(<String>{}) Set<String> initialPartIds,
  }) = _KatalogState;
}
