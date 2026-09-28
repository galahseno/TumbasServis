import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbas_servis/auth/data/repository/session_repository_impl.dart';
import 'package:tumbas_servis/booking/data/repository/booking_repository_impl.dart';
import 'package:tumbas_servis/catalog/data/repository/catalog_repository_impl.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/data/service/mock_json_loader.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/garage/data/repository/garage_repository_impl.dart';

import '../../../support/fake_clock.dart';
import '../../../support/fake_latency_simulator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late LocalStore localStore;
  late FakeClock clock;
  late BookingRepositoryImpl repository;

  BookingDraft canonicalDraft() => BookingDraft(
    id: 'draft_test',
    selectedMotorIds: const ['motor_001', 'motor_002', 'motor_003'],
    unitConfigs: const {
      'motor_001': UnitConfig(serviceIds: ['svc_berkala'], partIds: []),
      'motor_002': UnitConfig(
        serviceIds: ['svc_berkala'],
        partIds: ['part_oli_mpx1'],
      ),
      'motor_003': UnitConfig(
        serviceIds: ['svc_berkala'],
        partIds: ['part_oli_mpx2', 'part_kampas_matic'],
      ),
    },
    workshopId: 'ws_001',
    scheduleMode: ScheduleMode.shared,
    sharedSlot: TimeSlot(
      date: DateTime(2026, 9, 29),
      hour: 9,
      capacity: 5,
      booked: 1,
    ),
    unitSlots: const {},
    voucherId: 'voucher_diskon10',
    createdAt: DateTime(2026, 9, 20),
    expiresAt: DateTime(2026, 9, 21),
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tempDir = Directory.systemTemp.createTempSync('booking_repo_test');
    localStore = LocalStore(
      preferences: await SharedPreferences.getInstance(),
      resolveStorageDirectory: () async => tempDir.path,
    );
    clock = FakeClock(DateTime(2026, 9, 20, 9, 0));

    final sessionRepository = SessionRepositoryImpl(
      localStore: localStore,
      mockJsonLoader: MockJsonLoader(),
      latencySimulator: FakeLatencySimulator(),
    );
    await sessionRepository.verifyOtp('123456');

    repository = BookingRepositoryImpl(
      localStore: localStore,
      mockJsonLoader: MockJsonLoader(),
      latencySimulator: FakeLatencySimulator(),
      clock: clock,
      catalogRepository: CatalogRepositoryImpl(
        mockJsonLoader: MockJsonLoader(),
        latencySimulator: FakeLatencySimulator(),
      ),
      garageRepository: GarageRepositoryImpl(
        localStore: localStore,
        mockJsonLoader: MockJsonLoader(),
        latencySimulator: FakeLatencySimulator(),
        hasActiveBooking: (_) async => false,
      ),
      sessionRepository: sessionRepository,
    );
  });

  tearDown(() async {
    await Hive.close();
    tempDir.deleteSync(recursive: true);
  });

  group('createDraft', () {
    test('creates a fresh empty draft on first call', () async {
      final result = await repository.createDraft();
      expect(result, isA<Ok<BookingDraft>>());
      final draft = (result as Ok<BookingDraft>).value;
      expect(draft.selectedMotorIds, isEmpty);
      expect(
        draft.expiresAt.difference(draft.createdAt),
        const Duration(hours: 24),
      );
    });

    test('reuses the same draft while unexpired', () async {
      final first =
          ((await repository.createDraft()) as Ok<BookingDraft>).value;
      final second =
          ((await repository.createDraft()) as Ok<BookingDraft>).value;
      expect(second.id, first.id);
    });

    test('discards an expired draft and creates a new one', () async {
      final first =
          ((await repository.createDraft()) as Ok<BookingDraft>).value;
      clock.setNow(first.expiresAt.add(const Duration(minutes: 1)));
      final second =
          ((await repository.createDraft()) as Ok<BookingDraft>).value;
      expect(second.id, isNot(first.id));
    });
  });

  group('confirmBooking', () {
    test(
      'produces the canonical 3-unit booking total and code from the slot date',
      () async {
        final result = await repository.confirmBooking(canonicalDraft());
        expect(result, isA<Ok<Booking>>());
        final booking = (result as Ok<Booking>).value;

        expect(booking.subtotal, 428000);
        expect(booking.discount, 42800);
        expect(booking.total, 385200);
        expect(booking.code, 'TS-260929-0417');
        expect(booking.units, hasLength(3));
        expect(booking.units[0].subtotal, 85000);
        expect(booking.units[1].subtotal, 143000);
        expect(booking.units[2].subtotal, 200000);
      },
    );

    test('clears the draft after confirming', () async {
      await repository.updateDraft(canonicalDraft());
      await repository.confirmBooking(canonicalDraft());
      final freshDraft =
          ((await repository.createDraft()) as Ok<BookingDraft>).value;
      expect(freshDraft.selectedMotorIds, isEmpty);
    });

    test('refuses when the target slot is already at capacity', () async {
      final draft = canonicalDraft().copyWith(
        selectedMotorIds: const ['motor_001'],
        unitConfigs: const {
          'motor_001': UnitConfig(serviceIds: ['svc_berkala'], partIds: []),
        },
        sharedSlot: TimeSlot(
          date: DateTime(2026, 9, 29),
          hour: 12,
          capacity: 5,
          booked: 5,
        ),
      );

      final result = await repository.confirmBooking(draft);
      expect(result, isA<Error<Booking>>());
    });

    test(
      'split-mode confirm persists unitSlots and is reflected in slot occupancy',
      () async {
        final draft = canonicalDraft().copyWith(
          selectedMotorIds: const ['motor_001', 'motor_002'],
          scheduleMode: ScheduleMode.split,
          sharedSlot: null,
          unitSlots: {
            'motor_001': TimeSlot(
              date: DateTime(2026, 9, 29),
              hour: 10,
              capacity: 5,
              booked: 3,
            ),
            'motor_002': TimeSlot(
              date: DateTime(2026, 9, 29),
              hour: 11,
              capacity: 5,
              booked: 4,
            ),
          },
          voucherId: null,
        );

        final result = await repository.confirmBooking(draft);
        expect(result, isA<Ok<Booking>>());
        final booking = (result as Ok<Booking>).value;
        expect(booking.unitSlots, isNotNull);
        expect(booking.unitSlots!['-A']!.hour, 10);
        expect(booking.unitSlots!['-B']!.hour, 11);

        final slots =
            ((await repository.getBooking(booking.id)) as Ok<Booking>).value;
        expect(slots.unitSlots!['-A']!.hour, 10);
      },
    );
  });

  group('cancelBooking', () {
    test(
      'whole-booking cancel zeroes pricing and derives dibatalkan',
      () async {
        final booking =
            ((await repository.confirmBooking(canonicalDraft())) as Ok<Booking>)
                .value;

        final cancelResult = await repository.cancelBooking(booking.id);
        expect(cancelResult, isA<Ok<void>>());

        final updated =
            ((await repository.getBooking(booking.id)) as Ok<Booking>).value;
        expect(updated.status, BookingStatus.dibatalkan);
        expect(updated.subtotal, 0);
        expect(updated.discount, 0);
        expect(updated.total, 0);
        expect(updated.voucherId, isNull);
        expect(
          updated.units.every((u) => u.status == UnitStatus.dibatalkan),
          isTrue,
        );
      },
    );

    test(
      'single-unit cancel recomputes pricing and drops the voucher once minUnits is no longer met',
      () async {
        final booking =
            ((await repository.confirmBooking(canonicalDraft())) as Ok<Booking>)
                .value;

        final afterFirstCancel = await repository.cancelBooking(
          booking.id,
          unitCode: '-C',
        );
        expect(afterFirstCancel, isA<Ok<void>>());
        final afterFirst =
            ((await repository.getBooking(booking.id)) as Ok<Booking>).value;
        expect(afterFirst.subtotal, 85000 + 143000);
        expect(afterFirst.discount, 22800);
        expect(afterFirst.total, 205200);
        expect(afterFirst.voucherId, isNotNull);
        expect(afterFirst.status, BookingStatus.terjadwal);

        final afterSecondCancel = await repository.cancelBooking(
          booking.id,
          unitCode: '-B',
        );
        expect(afterSecondCancel, isA<Ok<void>>());
        final afterSecond =
            ((await repository.getBooking(booking.id)) as Ok<Booking>).value;
        expect(afterSecond.subtotal, 85000);
        expect(afterSecond.discount, 0);
        expect(afterSecond.total, 85000);
        expect(afterSecond.voucherId, isNull);
        expect(afterSecond.status, BookingStatus.terjadwal);
      },
    );

    test(
      'is blocked once the whole booking has moved past terjadwal',
      () async {
        final booking =
            ((await repository.confirmBooking(canonicalDraft())) as Ok<Booking>)
                .value;
        await localStore.put(
          'bookings',
          booking.id,
          (await localStore.get('bookings', booking.id))!
            ..['status'] = 'berlangsung',
        );

        final result = await repository.cancelBooking(booking.id);
        expect(result, isA<Error<void>>());
      },
    );

    test(
      'is blocked for a specific unit once it has moved past terjadwal',
      () async {
        final booking =
            ((await repository.confirmBooking(canonicalDraft())) as Ok<Booking>)
                .value;
        final raw = (await localStore.get('bookings', booking.id))!;
        final units = (raw['units'] as List<dynamic>)
            .cast<Map<String, dynamic>>();
        units[0]['status'] = 'checkIn';
        await localStore.put('bookings', booking.id, raw);

        final result = await repository.cancelBooking(
          booking.id,
          unitCode: '-A',
        );
        expect(result, isA<Error<void>>());
      },
    );
  });

  group('rescheduleBooking', () {
    test('happy path moves the shared slot and logs an audit event', () async {
      final booking =
          ((await repository.confirmBooking(canonicalDraft())) as Ok<Booking>)
              .value;

      final result = await repository.rescheduleBooking(
        id: booking.id,
        newSharedSlot: TimeSlot(
          date: DateTime(2026, 9, 29),
          hour: 15,
          capacity: 5,
          booked: 1,
        ),
      );

      expect(result, isA<Ok<Booking>>());
      final updated = (result as Ok<Booking>).value;
      expect(updated.sharedSlot!.hour, 15);
      expect(
        updated.units.first.statusHistory.last.note,
        contains('Dijadwal ulang'),
      );
    });

    test('refuses to reschedule into an already-full slot', () async {
      final booking =
          ((await repository.confirmBooking(canonicalDraft())) as Ok<Booking>)
              .value;

      final result = await repository.rescheduleBooking(
        id: booking.id,
        newSharedSlot: TimeSlot(
          date: DateTime(2026, 9, 29),
          hour: 12,
          capacity: 5,
          booked: 5,
        ),
      );

      expect(result, isA<Error<Booking>>());
    });

    test('is guarded once a unit has moved past terjadwal', () async {
      final booking =
          ((await repository.confirmBooking(canonicalDraft())) as Ok<Booking>)
              .value;
      final raw = (await localStore.get('bookings', booking.id))!;
      final units = (raw['units'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      units[0]['status'] = 'checkIn';
      await localStore.put('bookings', booking.id, raw);

      final result = await repository.rescheduleBooking(
        id: booking.id,
        newSharedSlot: TimeSlot(
          date: DateTime(2026, 9, 29),
          hour: 15,
          capacity: 5,
          booked: 1,
        ),
      );

      expect(result, isA<Error<Booking>>());
    });
  });
}
