import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/auth/data/di/auth_data_module.dart';
import 'package:tumbas_servis/booking/data/repository/booking_repository_impl.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/repository/booking/booking_repository.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';

final Provider<BookingRepository> bookingRepositoryProvider =
    Provider<BookingRepository>((ref) {
      return BookingRepositoryImpl(
        localStore: ref.watch(localStoreProvider),
        mockJsonLoader: ref.watch(mockJsonLoaderProvider),
        latencySimulator: ref.watch(latencySimulatorProvider),
        clock: ref.watch(clockProvider),
        catalogRepository: ref.watch(catalogRepositoryProvider),
        garageRepository: ref.watch(garageRepositoryProvider),
        sessionRepository: ref.watch(sessionRepositoryProvider),
      );
    });
