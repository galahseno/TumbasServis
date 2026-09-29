// ignore_for_file: prefer_initializing_formals
import 'dart:async';

import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/data/service/slot_occupancy_calculator.dart';
import 'package:tumbas_servis/core/data/service/tracking_simulator.dart';
import 'package:tumbas_servis/core/data/service/tracking_status_writer.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/service/clock.dart';

class TrackingSyncCoordinator {
  TrackingSyncCoordinator({
    required TrackingSimulator trackingSimulator,
    required LocalStore localStore,
    required Clock clock,
  }) : _trackingSimulator = trackingSimulator,
       _localStore = localStore,
       _clock = clock;

  final TrackingSimulator _trackingSimulator;
  final LocalStore _localStore;
  final Clock _clock;

  static const _bookingsBox = SlotOccupancyCalculator.bookingsBox;
  static const _writer = TrackingStatusWriter();

  StreamSubscription<TrackingTransition>? _subscription;

  Future<void> start() async {
    _subscription ??= _trackingSimulator.transitions.listen(
      (transition) => unawaited(_persist(transition)),
    );
    await hydrateFromStore();
  }

  Future<void> hydrateFromStore() async {
    final rows = await _localStore.getAll(_bookingsBox);
    for (final row in rows) {
      final bookingId = row['id'] as String?;
      final units = (row['units'] as List<dynamic>?)
          ?.cast<Map<String, dynamic>>();
      if (bookingId == null || units == null) continue;
      for (final unit in units) {
        final unitCode = unit['unit_code'] as String?;
        if (unitCode == null) continue;
        final status = UnitStatusX.fromString(unit['status'] as String?);
        if (status == UnitStatus.terjadwal || status.isTerminal) continue;
        if (_trackingSimulator.isTracking(bookingId, unitCode)) continue;
        _trackingSimulator.hydrate(bookingId, unitCode, status);
      }
    }
  }

  Future<void> _persist(TrackingTransition transition) async {
    try {
      if (transition.status == UnitStatus.terjadwal) {
        await _writer.writeReset(
          localStore: _localStore,
          clock: _clock,
          bookingId: transition.bookingId,
          unitCode: transition.unitCode,
        );
      } else {
        await _writer.writeAdvance(
          localStore: _localStore,
          clock: _clock,
          bookingId: transition.bookingId,
          unitCode: transition.unitCode,
          status: transition.status,
        );
      }
    } catch (_) {
      // Persistence is best effort here; explicit advance/reset surface errors.
    }
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}
