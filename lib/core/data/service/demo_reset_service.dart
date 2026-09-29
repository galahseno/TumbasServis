// ignore_for_file: prefer_initializing_formals
import 'package:tumbas_servis/core/data/service/demo_mode_controller.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/data/service/tracking_simulator.dart';

class DemoResetService {
  DemoResetService({
    required LocalStore localStore,
    required TrackingSimulator trackingSimulator,
    required DemoModeController demoModeController,
  }) : _localStore = localStore,
       _trackingSimulator = trackingSimulator,
       _demoModeController = demoModeController;

  final LocalStore _localStore;
  final TrackingSimulator _trackingSimulator;
  final DemoModeController _demoModeController;

  static const resetBoxes = <String>[
    'garage',
    'bookings',
    'booking_drafts',
    'booking_code_counters',
    'invoices',
    'reviews',
    'notifications',
  ];

  Future<void> reset() async {
    _trackingSimulator.clearAll();
    for (final box in resetBoxes) {
      await _localStore.clear(box);
    }
    _demoModeController.disarmError();
  }
}
