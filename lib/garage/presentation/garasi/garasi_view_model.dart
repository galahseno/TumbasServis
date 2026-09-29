import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor_model.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';
import 'package:tumbas_servis/garage/presentation/garasi/state/garasi_state.dart';

class GarasiViewModel extends Notifier<GarasiState> {
  @override
  GarasiState build() {
    _load();
    return const GarasiState();
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, hasError: false);
    await _load();
  }

  Future<void> _load() async {
    final motorsResult = await ref.read(garageRepositoryProvider).getMotors();
    final modelsResult = await ref
        .read(garageRepositoryProvider)
        .getMotorModels();
    final bookingsResult = await ref
        .read(bookingRepositoryProvider)
        .getBookings();
    if (!ref.mounted) return;

    if (motorsResult is! Ok<List<Motor>> ||
        bookingsResult is! Ok<List<Booking>>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }

    state = state.copyWith(
      isLoading: false,
      hasError: false,
      motors: motorsResult.value,
      modelsById: modelsResult is Ok<List<MotorModel>>
          ? {for (final model in modelsResult.value) model.id: model}
          : const {},
      motorInServiceStatus: {
        for (final booking in bookingsResult.value)
          for (final unit in booking.units)
            if (!unit.status.isTerminal) unit.motorId: unit.status,
      },
    );
  }
}
