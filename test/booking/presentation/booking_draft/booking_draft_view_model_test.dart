import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/booking/presentation/di/booking_presentation_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/domain/model/booking/status_event.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';

import '../../../support/fake_booking_repository.dart';

Motor _motor(String id) => Motor(
  id: id,
  ownerId: 'user_001',
  nickname: id,
  plateNumber: 'AB 0000 XY',
  modelId: 'model_x',
);

BookingDraft _draft({List<String> selectedMotorIds = const []}) => BookingDraft(
  id: 'draft_1',
  selectedMotorIds: selectedMotorIds,
  unitConfigs: const {},
  scheduleMode: ScheduleMode.shared,
  unitSlots: const {},
  createdAt: DateTime(2026, 9, 28),
  expiresAt: DateTime(2026, 9, 29, 12),
);

void main() {
  late FakeBookingRepository bookingRepository;
  late ProviderContainer container;

  setUp(() {
    bookingRepository = FakeBookingRepository()
      ..createDraftResult = Result.ok(_draft());
    container = ProviderContainer(
      overrides: [
        bookingRepositoryProvider.overrideWithValue(bookingRepository),
      ],
    );
    addTearDown(container.dispose);
  });

  Future<void> waitForLoad() async {
    for (var i = 0; i < 100; i++) {
      if (container.read(bookingDraftProvider) != null) return;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    throw StateError('BookingDraftViewModel never finished loading');
  }

  test('selectMotor adds a motor id and persists via updateDraft', () async {
    await waitForLoad();
    final notifier = container.read(bookingDraftProvider.notifier);

    await notifier.selectMotor('motor_001');

    expect(container.read(bookingDraftProvider)!.selectedMotorIds, [
      'motor_001',
    ]);
    expect(bookingRepository.lastUpdatedDraft!.selectedMotorIds, ['motor_001']);
  });

  test('deselectMotor removes a motor id', () async {
    bookingRepository.createDraftResult = Result.ok(
      _draft(selectedMotorIds: const ['motor_001', 'motor_002']),
    );
    await waitForLoad();
    final notifier = container.read(bookingDraftProvider.notifier);

    await notifier.deselectMotor('motor_001');

    expect(container.read(bookingDraftProvider)!.selectedMotorIds, [
      'motor_002',
    ]);
  });

  test('a 6th motor is blocked once 5 are selected', () async {
    bookingRepository.createDraftResult = Result.ok(
      _draft(selectedMotorIds: const ['m1', 'm2', 'm3', 'm4', 'm5']),
    );
    await waitForLoad();
    final notifier = container.read(bookingDraftProvider.notifier);

    await notifier.selectMotor('m6');

    expect(
      container.read(bookingDraftProvider)!.selectedMotorIds,
      hasLength(5),
    );
    expect(notifier.isMotorSelectable(_motor('m6')), isFalse);
  });

  test('a motor with a non-terminal booking is not selectable', () async {
    bookingRepository.bookingsResult = Result.ok([
      Booking(
        id: 'bk_1',
        code: 'TS-1',
        userId: 'u',
        workshopId: 'ws',
        units: [
          BookingUnit(
            unitCode: '-A',
            motorId: 'motor_busy',
            motorSnapshot: _motor('motor_busy'),
            serviceIds: const [],
            partIds: const [],
            status: UnitStatus.dikerjakan,
            statusHistory: [
              StatusEvent(
                status: UnitStatus.dikerjakan,
                timestamp: DateTime(2026, 9, 29),
              ),
            ],
            subtotal: 0,
            durationMin: 0,
          ),
        ],
        scheduleMode: ScheduleMode.shared,
        status: BookingStatus.berlangsung,
        subtotal: 0,
        discount: 0,
        total: 0,
        createdAt: DateTime(2026, 9, 20),
      ),
    ]);
    await waitForLoad();
    final notifier = container.read(bookingDraftProvider.notifier);

    expect(notifier.isMotorSelectable(_motor('motor_busy')), isFalse);
    expect(notifier.hasActiveBooking('motor_busy'), isTrue);
  });

  test(
    'a terminal booking does not block re-selection of that motor',
    () async {
      bookingRepository.bookingsResult = Result.ok([
        Booking(
          id: 'bk_1',
          code: 'TS-1',
          userId: 'u',
          workshopId: 'ws',
          units: [
            BookingUnit(
              unitCode: '-A',
              motorId: 'motor_done',
              motorSnapshot: _motor('motor_done'),
              serviceIds: const [],
              partIds: const [],
              status: UnitStatus.selesai,
              statusHistory: [
                StatusEvent(
                  status: UnitStatus.selesai,
                  timestamp: DateTime(2026, 9, 29),
                ),
              ],
              subtotal: 0,
              durationMin: 0,
            ),
          ],
          scheduleMode: ScheduleMode.shared,
          status: BookingStatus.selesai,
          subtotal: 0,
          discount: 0,
          total: 0,
          createdAt: DateTime(2026, 9, 20),
        ),
      ]);
      await waitForLoad();
      final notifier = container.read(bookingDraftProvider.notifier);

      expect(notifier.isMotorSelectable(_motor('motor_done')), isTrue);
    },
  );

  test('selectWorkshop persists the chosen workshop id on the draft', () async {
    await waitForLoad();
    final notifier = container.read(bookingDraftProvider.notifier);

    await notifier.selectWorkshop('ws_001');

    expect(container.read(bookingDraftProvider)!.workshopId, 'ws_001');
    expect(bookingRepository.lastUpdatedDraft!.workshopId, 'ws_001');
  });

  test('standalone entry: reset then selectWorkshop carries only the workshop '
      'id into a fresh, motor-less draft (S13 skipped)', () async {
    bookingRepository.createDraftResult = Result.ok(
      _draft(selectedMotorIds: const ['m1', 'm2']),
    );
    await waitForLoad();
    final notifier = container.read(bookingDraftProvider.notifier);

    bookingRepository.createDraftResult = Result.ok(_draft());
    await notifier.reset();
    await notifier.selectWorkshop('ws_005');

    final draft = container.read(bookingDraftProvider)!;
    expect(draft.workshopId, 'ws_005');
    expect(draft.selectedMotorIds, isEmpty);
    expect(bookingRepository.draftDeleted, isTrue);
  });

  group('schedule mutations', () {
    final slot = TimeSlot(
      date: DateTime(2026, 9, 29),
      hour: 9,
      capacity: 5,
      booked: 1,
    );

    test('setScheduleMode persists the mode', () async {
      await waitForLoad();
      final notifier = container.read(bookingDraftProvider.notifier);

      await notifier.setScheduleMode(ScheduleMode.split);

      expect(
        container.read(bookingDraftProvider)!.scheduleMode,
        ScheduleMode.split,
      );
    });

    test('selectSharedSlot then clearSharedSlot round-trips to null', () async {
      await waitForLoad();
      final notifier = container.read(bookingDraftProvider.notifier);

      await notifier.selectSharedSlot(slot);
      expect(container.read(bookingDraftProvider)!.sharedSlot, slot);

      await notifier.clearSharedSlot();
      expect(container.read(bookingDraftProvider)!.sharedSlot, isNull);
    });

    test(
      'selectUnitSlot then clearUnitSlot round-trips that unit only',
      () async {
        bookingRepository.createDraftResult = Result.ok(
          _draft(selectedMotorIds: const ['m1', 'm2']),
        );
        await waitForLoad();
        final notifier = container.read(bookingDraftProvider.notifier);

        await notifier.selectUnitSlot('m1', slot);
        await notifier.selectUnitSlot('m2', slot);
        expect(container.read(bookingDraftProvider)!.unitSlots['m1'], slot);
        expect(container.read(bookingDraftProvider)!.unitSlots['m2'], slot);

        await notifier.clearUnitSlot('m1');
        expect(
          container.read(bookingDraftProvider)!.unitSlots.containsKey('m1'),
          isFalse,
        );
        expect(container.read(bookingDraftProvider)!.unitSlots['m2'], slot);
      },
    );
  });

  group('unit config mutations', () {
    test('toggleService adds then removes a service id', () async {
      bookingRepository.createDraftResult = Result.ok(
        _draft(selectedMotorIds: const ['m1']),
      );
      await waitForLoad();
      final notifier = container.read(bookingDraftProvider.notifier);

      await notifier.toggleService('m1', 'svc_berkala');
      expect(
        container.read(bookingDraftProvider)!.unitConfigs['m1']!.serviceIds,
        ['svc_berkala'],
      );

      await notifier.toggleService('m1', 'svc_berkala');
      expect(
        container.read(bookingDraftProvider)!.unitConfigs['m1']!.serviceIds,
        isEmpty,
      );
    });

    test('togglePart adds then removes a part id', () async {
      bookingRepository.createDraftResult = Result.ok(
        _draft(selectedMotorIds: const ['m1']),
      );
      await waitForLoad();
      final notifier = container.read(bookingDraftProvider.notifier);

      await notifier.togglePart('m1', 'part_kampas_matic');
      expect(container.read(bookingDraftProvider)!.unitConfigs['m1']!.partIds, [
        'part_kampas_matic',
      ]);

      await notifier.togglePart('m1', 'part_kampas_matic');
      expect(
        container.read(bookingDraftProvider)!.unitConfigs['m1']!.partIds,
        isEmpty,
      );
    });

    test('setComplaintNote sets the note for the given unit', () async {
      bookingRepository.createDraftResult = Result.ok(
        _draft(selectedMotorIds: const ['m1']),
      );
      await waitForLoad();
      final notifier = container.read(bookingDraftProvider.notifier);

      await notifier.setComplaintNote('m1', 'Rem bunyi');

      expect(
        container.read(bookingDraftProvider)!.unitConfigs['m1']!.complaintNote,
        'Rem bunyi',
      );
    });

    test('setUnitConfig replaces the whole config for a unit', () async {
      bookingRepository.createDraftResult = Result.ok(
        _draft(selectedMotorIds: const ['m1']),
      );
      await waitForLoad();
      final notifier = container.read(bookingDraftProvider.notifier);

      await notifier.setUnitConfig(
        'm1',
        const UnitConfig(serviceIds: ['svc_berkala'], partIds: ['part_a']),
      );

      final config = container.read(bookingDraftProvider)!.unitConfigs['m1']!;
      expect(config.serviceIds, ['svc_berkala']);
      expect(config.partIds, ['part_a']);
    });

    test(
      'removeUnit drops the motor from selection and clears its config',
      () async {
        bookingRepository.createDraftResult = Result.ok(
          _draft(selectedMotorIds: const ['m1', 'm2']),
        );
        await waitForLoad();
        final notifier = container.read(bookingDraftProvider.notifier);
        await notifier.toggleService('m1', 'svc_berkala');

        await notifier.removeUnit('m1');

        final draft = container.read(bookingDraftProvider)!;
        expect(draft.selectedMotorIds, ['m2']);
        expect(draft.unitConfigs.containsKey('m1'), isFalse);
      },
    );
  });
}
