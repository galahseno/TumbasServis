import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor_model.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';
import 'package:tumbas_servis/garage/presentation/motor_detail/state/motor_detail_state.dart';

class MotorDetailViewModel extends Notifier<MotorDetailState> {
  String? _motorId;

  @override
  MotorDetailState build() => const MotorDetailState();

  Future<void> initialize(String motorId) async {
    if (_motorId == motorId) return;
    _motorId = motorId;
    await _load(motorId);
  }

  Future<void> reload() async {
    final id = _motorId;
    if (id == null) return;
    await _load(id);
  }

  Future<void> retry() async {
    state = state.copyWith(isLoading: true, hasError: false);
    await reload();
  }

  Future<void> _load(String motorId) async {
    final motorsResult = await ref.read(garageRepositoryProvider).getMotors();
    final modelsResult = await ref
        .read(garageRepositoryProvider)
        .getMotorModels();
    final servicesResult = await ref
        .read(catalogRepositoryProvider)
        .getServiceTypes();
    final bookingsResult = await ref
        .read(bookingRepositoryProvider)
        .getBookings();
    if (!ref.mounted) return;

    if (motorsResult is! Ok<List<Motor>> ||
        modelsResult is! Ok<List<MotorModel>> ||
        servicesResult is! Ok<List<ServiceType>> ||
        bookingsResult is! Ok<List<Booking>>) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }

    final motor = motorsResult.value.where((m) => m.id == motorId).firstOrNull;
    if (motor == null) {
      state = state.copyWith(isLoading: false, hasError: true);
      return;
    }
    final model = modelsResult.value
        .where((m) => m.id == motor.modelId)
        .firstOrNull;
    final serviceNames = {
      for (final service in servicesResult.value) service.id: service.name,
    };

    MotorHistoryEntry? active;
    final past = <MotorHistoryEntry>[];
    for (final booking in bookingsResult.value) {
      for (final unit in booking.units) {
        if (unit.motorId != motorId) continue;
        final entry = (
          bookingId: booking.id,
          bookingCode: booking.code,
          unitCode: unit.unitCode,
          code: unit.unitCode,
          status: unit.status,
          dateTime: booking.completedAt ?? booking.createdAt,
          servicesSummary: [
            for (final id in unit.serviceIds)
              if (serviceNames[id] != null) serviceNames[id]!,
          ].join(' + '),
          subtotal: unit.subtotal,
        );
        if (unit.status.isTerminal) {
          past.add(entry);
        } else {
          active ??= entry;
        }
      }
    }
    past.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    state = state.copyWith(
      isLoading: false,
      hasError: false,
      motor: motor,
      model: model,
      activeEntry: active,
      pastHistory: past,
    );
  }

  Future<bool> deleteMotor() async {
    final motor = state.motor;
    if (motor == null) return false;
    state = state.copyWith(isDeleting: true);
    final result = await ref
        .read(garageRepositoryProvider)
        .deleteMotor(motor.id);
    if (!ref.mounted) return false;
    state = state.copyWith(isDeleting: false);
    return result is Ok<void>;
  }
}
