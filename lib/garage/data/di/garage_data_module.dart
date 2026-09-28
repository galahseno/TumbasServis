import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/repository/garage/garage_repository.dart';
import 'package:tumbas_servis/garage/data/repository/garage_repository_impl.dart';

final Provider<GarageRepository> garageRepositoryProvider =
    Provider<GarageRepository>((ref) {
      return GarageRepositoryImpl(
        localStore: ref.watch(localStoreProvider),
        mockJsonLoader: ref.watch(mockJsonLoaderProvider),
        latencySimulator: ref.watch(latencySimulatorProvider),
        hasActiveBooking: (motorId) async {
          final result = await ref
              .read(bookingRepositoryProvider)
              .getBookings();
          return switch (result) {
            Ok(:final value) => value.any(
              (booking) => booking.units.any(
                (unit) => unit.motorId == motorId && !unit.status.isTerminal,
              ),
            ),
            Error() => true,
          };
        },
      );
    });
