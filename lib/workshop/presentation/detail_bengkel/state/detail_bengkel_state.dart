import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';

part 'detail_bengkel_state.freezed.dart';

enum WorkshopDetailVariant { inFlow, standalone }

@freezed
abstract class DetailBengkelState with _$DetailBengkelState {
  const factory DetailBengkelState({
    @Default(true) bool isLoading,
    @Default(false) bool hasError,
    Workshop? workshop,
    @Default(<ServiceType>[]) List<ServiceType> serviceTypes,
  }) = _DetailBengkelState;
}
