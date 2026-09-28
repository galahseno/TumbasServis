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
    mutate: (unit) {
      unit['status'] = status.name;
      final history = (unit['status_history'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      history.add({
        'status': status.name,
        'timestamp': clock.now().toIso8601String(),
      });
      unit['status_history'] = history;
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
    mutate: (unit) {
      unit['status'] = UnitStatus.terjadwal.name;
      unit['status_history'] = [
        {
          'status': UnitStatus.terjadwal.name,
          'timestamp': clock.now().toIso8601String(),
        },
      ];
    },
  );

  Future<void> _mutateUnit({
    required LocalStore localStore,
    required Clock clock,
    required String bookingId,
    required String unitCode,
    required void Function(Map<String, dynamic> unit) mutate,
  }) async {
    final row = await localStore.get(bookingsBox, bookingId);
    if (row == null) return;
    final units = (row['units'] as List<dynamic>).cast<Map<String, dynamic>>();
    Map<String, dynamic>? target;
    for (final unit in units) {
      if (unit['unit_code'] == unitCode) {
        target = unit;
        break;
      }
    }
    if (target == null) return;

    mutate(target);

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
  }
}
