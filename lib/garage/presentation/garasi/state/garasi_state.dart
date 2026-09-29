import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor_model.dart';

part 'garasi_state.freezed.dart';

@freezed
abstract class GarasiState with _$GarasiState {
  const factory GarasiState({
    @Default(true) bool isLoading,
    @Default(false) bool hasError,
    @Default(<Motor>[]) List<Motor> motors,
    @Default(<String, UnitStatus>{})
    Map<String, UnitStatus> motorInServiceStatus,
    @Default(<String, MotorModel>{}) Map<String, MotorModel> modelsById,
  }) = _GarasiState;

  const GarasiState._();

  bool get isConfirmedEmpty => !isLoading && !hasError && motors.isEmpty;
}
