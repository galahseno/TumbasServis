import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';

part 'pilih_bengkel_state.freezed.dart';

enum WorkshopSortMode { terdekat, ratingTertinggi }

@freezed
abstract class PilihBengkelState with _$PilihBengkelState {
  const factory PilihBengkelState({
    @Default(true) bool isLoading,
    @Default(false) bool hasError,
    @Default(<Workshop>[]) List<Workshop> workshops,
    @Default(<ServiceType>[]) List<ServiceType> serviceTypes,
    @Default(false) bool openNowOnly,
    @Default(WorkshopSortMode.terdekat) WorkshopSortMode sortMode,
    @Default('') String searchQuery,
  }) = _PilihBengkelState;
}
