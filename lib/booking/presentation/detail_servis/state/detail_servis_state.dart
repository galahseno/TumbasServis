import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';

part 'detail_servis_state.freezed.dart';

@freezed
abstract class DetailServisState with _$DetailServisState {
  const factory DetailServisState({
    @Default(true) bool isLoading,
    @Default(false) bool hasError,
    @Default(<ServiceType>[]) List<ServiceType> serviceTypes,
    @Default(<Part>[]) List<Part> parts,
    @Default(<String, Motor>{}) Map<String, Motor> motorsById,
    String? activeMotorId,
    @Default(<String>{}) Set<String> manuallyExpandedComplaintMotorIds,
    @Default(<String, int>{}) Map<String, int> droppedPartsCountByMotor,
  }) = _DetailServisState;
}
