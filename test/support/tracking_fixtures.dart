import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/domain/model/booking/status_event.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/workshop/mechanic.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/core/domain/service/status/booking_status_derivation.dart';

import 'garage_fixtures.dart';

const workshopFixture = Workshop(
  id: 'ws_001',
  name: 'Bengkel Jaya Motor',
  rating: 4.7,
  reviewCount: 120,
  distanceKm: 1.2,
  address: 'Jl. Kaliurang',
  openTime: 8,
  closeTime: 17,
  bayCount: 2,
  staticMapAssetPath: 'assets/map.png',
  serviceIds: ['svc_berkala'],
);

const serviceFixtures = [
  ServiceType(
    id: 'svc_berkala',
    name: 'Servis Berkala',
    price: 85000,
    durationMin: 60,
    requiresComplaint: false,
  ),
];

const partFixtures = [
  Part(
    id: 'part_oli',
    name: 'AHM Oli MPX1',
    category: 'Oli',
    brand: 'AHM',
    grade: 'MPX1',
    price: 58000,
    compatibleModelIds: ['model_beat'],
  ),
];

const mechanicFixtures = [
  Mechanic(id: 'mech_001', name: 'Mas Rudi', avatarInitial: 'R', rating: 4.8),
  Mechanic(id: 'mech_002', name: 'Pak Anto', avatarInitial: 'A', rating: 4.7),
];

TimeSlot slotFixture({
  DateTime? date,
  int hour = 9,
  int capacity = 5,
  int booked = 1,
}) => TimeSlot(
  date: date ?? DateTime(2026, 9, 29),
  hour: hour,
  capacity: capacity,
  booked: booked,
);

BookingUnit trackedUnit(
  String code,
  UnitStatus status, {
  String motorId = 'm1',
  String nickname = 'Beat 110',
  String? mechanicId,
  List<String> partIds = const [],
  List<StatusEvent>? history,
}) {
  final stages = [
    UnitStatus.terjadwal,
    UnitStatus.checkIn,
    UnitStatus.diperiksa,
    UnitStatus.dikerjakan,
    UnitStatus.qc,
    UnitStatus.selesai,
  ];
  final reached = status == UnitStatus.dibatalkan
      ? const [UnitStatus.terjadwal]
      : stages.sublist(0, stages.indexOf(status) + 1);
  return BookingUnit(
    unitCode: code,
    motorId: motorId,
    motorSnapshot: motorFixture(motorId, nickname: nickname),
    serviceIds: const ['svc_berkala'],
    partIds: partIds,
    status: status,
    statusHistory:
        history ??
        [
          for (var i = 0; i < reached.length; i++)
            StatusEvent(
              status: reached[i],
              timestamp: DateTime(2026, 9, 29, 9, i * 5),
            ),
          if (status == UnitStatus.dibatalkan)
            StatusEvent(
              status: UnitStatus.dibatalkan,
              timestamp: DateTime(2026, 9, 29, 8, 55),
              note: 'Dibatalkan oleh pengguna: Jadwal bentrok',
            ),
        ],
    mechanicId: mechanicId,
    subtotal: 85000,
    durationMin: 75,
  );
}

Booking trackedBooking(
  String id,
  List<BookingUnit> units, {
  ScheduleMode mode = ScheduleMode.shared,
  TimeSlot? slot,
  String workshopId = 'ws_001',
  DateTime? createdAt,
  BookingStatus? status,
}) => Booking(
  id: id,
  code: 'TS-$id',
  userId: 'user_001',
  workshopId: workshopId,
  units: units,
  scheduleMode: mode,
  sharedSlot: mode == ScheduleMode.shared ? (slot ?? slotFixture()) : null,
  unitSlots: mode == ScheduleMode.split
      ? {for (final u in units) u.unitCode: slot ?? slotFixture()}
      : null,
  status:
      status ??
      const BookingStatusDerivation().deriveStatus([
        for (final u in units) u.status,
      ]),
  subtotal: 85000 * units.length,
  discount: 0,
  total: 85000 * units.length,
  createdAt: createdAt ?? DateTime(2026, 9, 20),
);
