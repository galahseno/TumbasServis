import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/domain/model/booking/status_event.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/home/presentation/utils/home_booking_display.dart';

Motor _motor(String id) => Motor(
  id: id,
  ownerId: 'user_001',
  nickname: id,
  plateNumber: 'AB 0000 XY',
  modelId: 'model_x',
);

BookingUnit _unit(String code, String motorId, UnitStatus status) =>
    BookingUnit(
      unitCode: code,
      motorId: motorId,
      motorSnapshot: _motor(motorId),
      serviceIds: const ['svc_berkala'],
      partIds: const [],
      status: status,
      statusHistory: [
        StatusEvent(status: status, timestamp: DateTime(2026, 9, 29)),
      ],
      subtotal: 85000,
      durationMin: 60,
    );

Booking _booking({required List<BookingUnit> units, TimeSlot? sharedSlot}) =>
    Booking(
      id: 'bk_1',
      code: 'TS-260929-0417',
      userId: 'user_001',
      workshopId: 'ws_001',
      units: units,
      scheduleMode: sharedSlot != null ? ScheduleMode.shared : ScheduleMode.split,
      sharedSlot: sharedSlot,
      unitSlots: sharedSlot != null
          ? null
          : {
              for (final u in units)
                u.unitCode: TimeSlot(
                  date: DateTime(2026, 9, 29),
                  hour: 8 + units.indexOf(u),
                  capacity: 5,
                  booked: 1,
                ),
            },
      status: BookingStatus.berlangsung,
      subtotal: 255000,
      discount: 0,
      total: 255000,
      createdAt: DateTime(2026, 9, 20),
    );

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  group('majorityStatus', () {
    test('empty → empty label, no caption', () {
      expect(<UnitStatus>[].majorityStatus, ('', null));
    });

    test('single distinct status → no caption', () {
      final (label, caption) = [UnitStatus.qc, UnitStatus.qc].majorityStatus;
      expect(label, 'QC');
      expect(caption, isNull);
    });

    test('2-1 majority → minority caption lowercase', () {
      final (label, caption) = [
        UnitStatus.dikerjakan,
        UnitStatus.dikerjakan,
        UnitStatus.checkIn,
      ].majorityStatus;
      expect(label, 'Dikerjakan');
      expect(caption, '1 motor masih check-in');
    });

    test('exact tie → lowest stageIndex wins', () {
      final (label, caption) = [
        UnitStatus.qc,
        UnitStatus.diperiksa,
      ].majorityStatus;
      expect(label, 'Diperiksa');
      expect(caption, '1 motor masih qc');
    });
  });

  group('motorInServiceStatus', () {
    test('terminal units excluded, non-terminal and unknown included', () {
      final bookings = [
        _booking(
          units: [
            _unit('-A', 'motor_a', UnitStatus.selesai),
            _unit('-B', 'motor_b', UnitStatus.dikerjakan),
          ],
          sharedSlot: TimeSlot(
            date: DateTime(2026, 9, 29),
            hour: 9,
            capacity: 5,
            booked: 1,
          ),
        ),
        _booking(
          units: [_unit('-C', 'motor_c', UnitStatus.unknown)],
          sharedSlot: TimeSlot(
            date: DateTime(2026, 9, 30),
            hour: 9,
            capacity: 5,
            booked: 1,
          ),
        ),
      ];
      final map = bookings.motorInServiceStatus;
      expect(map, {
        'motor_b': UnitStatus.dikerjakan,
        'motor_c': UnitStatus.unknown,
      });
    });

    test('later booking wins per motorId', () {
      final bookings = [
        _booking(
          units: [_unit('-A', 'motor_a', UnitStatus.diperiksa)],
          sharedSlot: TimeSlot(
            date: DateTime(2026, 9, 29),
            hour: 9,
            capacity: 5,
            booked: 1,
          ),
        ),
        _booking(
          units: [_unit('-B', 'motor_a', UnitStatus.dikerjakan)],
          sharedSlot: TimeSlot(
            date: DateTime(2026, 9, 30),
            hour: 9,
            capacity: 5,
            booked: 1,
          ),
        ),
      ];
      expect(bookings.motorInServiceStatus['motor_a'], UnitStatus.dikerjakan);
    });
  });

  group('toActiveBookingDisplay', () {
    test('sharedSlot used for scheduleLine', () {
      final booking = _booking(
        units: [_unit('-A', 'motor_a', UnitStatus.qc)],
        sharedSlot: TimeSlot(
          date: DateTime(2026, 9, 29),
          hour: 9,
          capacity: 5,
          booked: 1,
        ),
      );
      final display = booking.toActiveBookingDisplay({'ws_001': 'Bengkel A'});
      expect(display.statusLabel, 'QC');
      expect(
        display.scheduleLine,
        startsWith('Bengkel A · Sel, 29 Sep · 09.00'),
      );
    });

    test('split mode → earliest unitSlots date wins', () {
      final booking = _booking(units: [
        _unit('-B', 'motor_b', UnitStatus.terjadwal),
        _unit('-C', 'motor_c', UnitStatus.terjadwal),
      ]);
      final display = booking.toActiveBookingDisplay({'ws_001': 'Bengkel A'});
      expect(display.scheduleLine, contains('09.00'));
    });

    test('missing workshop name → empty name, separator kept', () {
      final booking = _booking(
        units: [_unit('-A', 'motor_a', UnitStatus.qc)],
        sharedSlot: TimeSlot(
          date: DateTime(2026, 9, 29),
          hour: 9,
          capacity: 5,
          booked: 1,
        ),
      );
      final display = booking.toActiveBookingDisplay({});
      expect(display.scheduleLine, ' · Sel, 29 Sep · 09.00');
    });
  });

  group('displayLabel', () {
    test('covers every status', () {
      expect(UnitStatus.terjadwal.displayLabel, 'Terjadwal');
      expect(UnitStatus.unknown.displayLabel, 'Terjadwal');
      expect(UnitStatus.checkIn.displayLabel, 'Check-in');
      expect(UnitStatus.diperiksa.displayLabel, 'Diperiksa');
      expect(UnitStatus.dikerjakan.displayLabel, 'Dikerjakan');
      expect(UnitStatus.qc.displayLabel, 'QC');
      expect(UnitStatus.selesai.displayLabel, 'Selesai');
      expect(UnitStatus.dibatalkan.displayLabel, 'Dibatalkan');
    });
  });
}
