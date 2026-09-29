import 'dart:async';

import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/data/service/slot_occupancy_calculator.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/service/clock.dart';
import 'package:tumbas_servis/core/domain/service/status/booking_status_derivation.dart';

class TrackingStatusWriter {
  const TrackingStatusWriter();

  static const bookingsBox = SlotOccupancyCalculator.bookingsBox;
  static const _statusDerivation = BookingStatusDerivation();

  static const _mechanicPool = ['mech_002', 'mech_001'];

  static Future<void> _queue = Future<void>.value();

  static Future<void> get pendingWrites => _queue;

  static Future<void> _enqueue(Future<void> Function() task) {
    final run = _queue.then((_) => task());
    _queue = run.catchError((Object _) {});
    return run;
  }

  Future<void> writeAdvance({
    required LocalStore localStore,
    required Clock clock,
    required String bookingId,
    required String unitCode,
    required UnitStatus status,
  }) => _mutateUnit(
    localStore: localStore,
    clock: clock,
    bookingId: bookingId,
    unitCode: unitCode,
    mutate: (unit, index) {
      final stored = UnitStatusX.fromString(unit['status'] as String?);
      if (stored == status || stored.isTerminal) return false;
      unit['status'] = status.name;
      final history = (unit['status_history'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      history.add({
        'status': status.name,
        'timestamp': clock.now().toIso8601String(),
      });
      unit['status_history'] = history;
      if (status != UnitStatus.terjadwal && unit['mechanic_id'] == null) {
        unit['mechanic_id'] = _mechanicPool[index % _mechanicPool.length];
      }
      return true;
    },
  );

  Future<void> writeReset({
    required LocalStore localStore,
    required Clock clock,
    required String bookingId,
    required String unitCode,
  }) => _mutateUnit(
    localStore: localStore,
    clock: clock,
    bookingId: bookingId,
    unitCode: unitCode,
    mutate: (unit, index) {
      if (UnitStatusX.fromString(unit['status'] as String?) ==
          UnitStatus.terjadwal) {
        return false;
      }
      unit['status'] = UnitStatus.terjadwal.name;
      unit['status_history'] = [
        {
          'status': UnitStatus.terjadwal.name,
          'timestamp': clock.now().toIso8601String(),
        },
      ];
      return true;
    },
  );

  Future<void> _mutateUnit({
    required LocalStore localStore,
    required Clock clock,
    required String bookingId,
    required String unitCode,
    required bool Function(Map<String, dynamic> unit, int index) mutate,
  }) => _enqueue(() async {
    final row = await localStore.get(bookingsBox, bookingId);
    if (row == null) return;
    final units = (row['units'] as List<dynamic>).cast<Map<String, dynamic>>();
    final index = units.indexWhereUnit(unitCode);
    if (index == -1) return;

    if (!mutate(units[index], index)) return;

    final unitStatuses = units
        .map((u) => UnitStatusX.fromString(u['status'] as String?))
        .toList();
    final derivedStatus = _statusDerivation.deriveStatus(unitStatuses);
    row['status'] = derivedStatus.name;
    row['completed_at'] = derivedStatus == BookingStatus.selesai
        ? clock.now().toIso8601String()
        : null;
    row['units'] = units;

    await localStore.put(bookingsBox, bookingId, row);
  });
}

extension on List<Map<String, dynamic>> {
  int indexWhereUnit(String unitCode) =>
      indexWhere((unit) => unit['unit_code'] == unitCode);
}
