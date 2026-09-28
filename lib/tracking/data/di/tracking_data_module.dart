import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/repository/tracking/tracking_repository.dart';
import 'package:tumbas_servis/tracking/data/repository/tracking_repository_impl.dart';

final Provider<TrackingRepository> trackingRepositoryProvider =
    Provider<TrackingRepository>((ref) {
      return TrackingRepositoryImpl(
        trackingSimulator: ref.watch(trackingSimulatorProvider),
        localStore: ref.watch(localStoreProvider),
        latencySimulator: ref.watch(latencySimulatorProvider),
        clock: ref.watch(clockProvider),
        bookingRepository: ref.watch(bookingRepositoryProvider),
      );
    });
