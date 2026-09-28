import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbas_servis/booking/data/util/slot_capacity_validator.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';

TimeSlot _slot(DateTime date, int hour, {int booked = 0}) =>
    TimeSlot(date: date, hour: hour, capacity: 5, booked: booked);

BookingDraft _sharedDraft(TimeSlot slot) => BookingDraft(
  id: 'draft_1',
  selectedMotorIds: const ['motor_001'],
  unitConfigs: const {},
  workshopId: 'ws_001',
  scheduleMode: ScheduleMode.shared,
  sharedSlot: slot,
  unitSlots: const {},
  createdAt: DateTime(2026, 9, 28),
  expiresAt: DateTime(2026, 9, 29),
);

BookingDraft _splitDraft(Map<String, TimeSlot> slots,
        {String? missingMotorId}) =>
    BookingDraft(
      id: 'draft_1',
      selectedMotorIds: [
        'motor_001',
        'motor_002',
        ?missingMotorId,
      ],
      unitConfigs: const {},
      workshopId: 'ws_001',
      scheduleMode: ScheduleMode.split,
      unitSlots: slots,
      createdAt: DateTime(2026, 9, 28),
      expiresAt: DateTime(2026, 9, 29),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late LocalStore localStore;
  late SlotCapacityValidator validator;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tempDir = Directory.systemTemp.createTempSync('slot_capacity_test');
    localStore = LocalStore(
      preferences: await SharedPreferences.getInstance(),
      resolveStorageDirectory: () async => tempDir.path,
    );
    validator = SlotCapacityValidator(localStore: localStore);
  });

  tearDown(() async {
    await Hive.close();
    tempDir.deleteSync(recursive: true);
  });

  group('validateDraft', () {
    test('null workshopId → bengkel error', () async {
      final error = await validator.validateDraft(
        _sharedDraft(_slot(DateTime(2026, 9, 29), 9)).copyWith(workshopId: null),
      );
      expect(error?.toString(), contains('Draft belum memiliki bengkel.'));
    });

    test('shared mode without slot → jadwal error', () async {
      final error = await validator.validateDraft(
        _sharedDraft(_slot(DateTime(2026, 9, 29), 9))
            .copyWith(sharedSlot: null),
      );
      expect(error?.toString(), contains('Draft belum memiliki jadwal.'));
    });

    test('shared mode into full slot (hour 12, baseline 5) → penuh', () async {
      final error = await validator.validateDraft(
        _sharedDraft(_slot(DateTime(2026, 9, 29), 12)),
      );
      expect(error?.toString(), contains('Slot penuh'));
    });

    test('shared mode with room (hour 9, baseline 1) → null', () async {
      final error = await validator.validateDraft(
        _sharedDraft(_slot(DateTime(2026, 9, 29), 9)),
      );
      expect(error, isNull);
    });

    test('split mode missing a unit slot → jadwal error', () async {
      final error = await validator.validateDraft(
        _splitDraft({'motor_001': _slot(DateTime(2026, 9, 29), 9)},
            missingMotorId: 'motor_002'),
      );
      expect(
        error?.toString(),
        contains('Draft belum memiliki jadwal untuk salah satu motor.'),
      );
    });

    test('split mode two units sharing hour 10 (baseline 3) → null', () async {
      final slot = _slot(DateTime(2026, 9, 29), 10);
      final error = await validator.validateDraft(
        _splitDraft({'motor_001': slot, 'motor_002': slot}),
      );
      expect(error, isNull);
    });

    test('split mode into full slot → penuh', () async {
      final slot = _slot(DateTime(2026, 9, 29), 12);
      final error = await validator.validateDraft(
        _splitDraft({'motor_001': slot, 'motor_002': slot}),
      );
      expect(error?.toString(), contains('Slot penuh'));
    });
  });

  group('hasSharedCapacityFor', () {
    test('recomputes booked from store, ignoring stale slot values', () async {
      // Stale slot claims 5 booked at hour 9, but the store is empty and the
      // canonical baseline for hour 9 is 1 — a single unit still fits.
      final fits = await validator.hasSharedCapacityFor(
        workshopId: 'ws_001',
        slot: _slot(DateTime(2026, 9, 29), 9, booked: 5),
        unitCount: 1,
      );
      expect(fits, isTrue);

      final full = await validator.hasSharedCapacityFor(
        workshopId: 'ws_001',
        slot: _slot(DateTime(2026, 9, 29), 12, booked: 0),
        unitCount: 1,
      );
      expect(full, isFalse);
    });
  });

  group('canPlaceUnits', () {
    test('sibling grouping counts shared units against capacity', () async {
      final slot = _slot(DateTime(2026, 9, 29), 11); // baseline 4
      final twoUnits = await validator.canPlaceUnits(
        workshopId: 'ws_001',
        slots: {'-A': slot, '-B': slot},
      );
      expect(twoUnits, isFalse);

      final oneUnit = await validator.canPlaceUnits(
        workshopId: 'ws_001',
        slots: {'-A': slot},
      );
      expect(oneUnit, isTrue);
    });
  });
}
