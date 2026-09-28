import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';

part 'pilih_motor_state.freezed.dart';

@freezed
abstract class PilihMotorState with _$PilihMotorState {
  const factory PilihMotorState({
    @Default(true) bool isLoading,
    @Default(false) bool hasError,
    @Default(<Motor>[]) List<Motor> motors,
  }) = _PilihMotorState;

  const PilihMotorState._();

  bool get isGarageEmpty => !isLoading && !hasError && motors.isEmpty;
}
