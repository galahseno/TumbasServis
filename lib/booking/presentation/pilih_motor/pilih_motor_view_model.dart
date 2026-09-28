import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/booking/presentation/pilih_motor/state/pilih_motor_state.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';

class PilihMotorViewModel extends Notifier<PilihMotorState> {
  @override
  PilihMotorState build() {
    _load();
    return const PilihMotorState();
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, hasError: false);
    await _load();
  }

  Future<void> _load() async {
    final result = await ref.read(garageRepositoryProvider).getMotors();
    if (!ref.mounted) return;

    if (result is Error<List<Motor>>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }

    state = state.copyWith(
      isLoading: false,
      hasError: false,
      motors: (result as Ok<List<Motor>>).value,
    );
  }
}
