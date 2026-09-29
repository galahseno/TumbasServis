import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbas_servis/core/data/service/demo_mode_controller.dart';
import 'package:tumbas_servis/core/data/service/latency_simulator.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/data/service/mock_json_loader.dart';
import 'package:tumbas_servis/core/data/service/photo_picker_service.dart';
import 'package:tumbas_servis/core/data/service/status_notification_coordinator.dart';
import 'package:tumbas_servis/core/data/service/system_clock.dart';
import 'package:tumbas_servis/core/data/service/tracking_simulator.dart';
import 'package:tumbas_servis/core/data/service/tracking_sync_coordinator.dart';
import 'package:tumbas_servis/core/domain/service/clock.dart';
import 'package:tumbas_servis/notification/data/di/notification_data_module.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in bootstrap with an '
    'awaited SharedPreferences.getInstance() result.',
  );
});

final mockJsonLoaderProvider = Provider<MockJsonLoader>(
  (ref) => MockJsonLoader(),
);

final latencySimulatorProvider = Provider<LatencySimulator>(
  (ref) => RandomLatencySimulator(),
);

final localStoreProvider = Provider<LocalStore>((ref) {
  return LocalStore(
    preferences: ref.watch(sharedPreferencesProvider),
    resolveStorageDirectory: () async =>
        (await getApplicationDocumentsDirectory()).path,
  );
});

final photoPickerServiceProvider = Provider<PhotoPickerService>(
  (ref) => PhotoPickerService(
    resolveStorageDirectory: () async =>
        (await getApplicationDocumentsDirectory()).path,
  ),
);

final demoModeControllerProvider = Provider<DemoModeController>((ref) {
  final controller = DemoModeController();
  ref.onDispose(controller.dispose);
  return controller;
});

final trackingSimulatorProvider = Provider<TrackingSimulator>((ref) {
  final simulator = TrackingSimulator(
    demoModeController: ref.watch(demoModeControllerProvider),
  );
  ref.onDispose(simulator.dispose);
  return simulator;
});

final clockProvider = Provider<Clock>((ref) => SystemClock());

final statusNotificationCoordinatorProvider =
    Provider<StatusNotificationCoordinator>((ref) {
      final coordinator = StatusNotificationCoordinator(
        trackingSimulator: ref.watch(trackingSimulatorProvider),
        localStore: ref.watch(localStoreProvider),
        notificationRepository: ref.watch(notificationRepositoryProvider),
        clock: ref.watch(clockProvider),
      );
      coordinator.start();
      ref.onDispose(coordinator.dispose);
      return coordinator;
    });

final trackingSyncCoordinatorProvider = Provider<TrackingSyncCoordinator>((
  ref,
) {
  final coordinator = TrackingSyncCoordinator(
    trackingSimulator: ref.watch(trackingSimulatorProvider),
    localStore: ref.watch(localStoreProvider),
    clock: ref.watch(clockProvider),
  );
  unawaited(coordinator.start());
  ref.onDispose(coordinator.dispose);
  return coordinator;
});
