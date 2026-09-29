import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/booking/presentation/di/booking_presentation_module.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/pilih_jadwal_view_model.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/core/domain/service/scheduling/slot_capacity_service.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';

import '../../../support/fake_booking_repository.dart';
import '../../../support/fake_clock.dart';
import '../../../support/fake_garage_repository.dart';
import '../../../support/fake_workshop_repository.dart';

const _jaya = Workshop(
  id: 'ws_001',
  name: 'Bengkel Jaya Motor',
  rating: 4.8,
  reviewCount: 126,
  distanceKm: 1.2,
  address: 'Jl. Melati Raya No. 12, Sleman, DI Yogyakarta',
  openTime: 8,
  closeTime: 17,
  bayCount: 2,
  staticMapAssetPath: 'assets/images/maps/ws_001_map.png',
  serviceIds: ['svc_berkala'],
);

Motor _motor(String id, String nickname, String plate) => Motor(
  id: id,
  ownerId: 'u1',
  nickname: nickname,
  plateNumber: plate,
  modelId: 'model_x',
);

final _vario = _motor('m_vario', 'Vario 125', 'AB 1234 XY');
final _beat = _motor('m_beat', 'Beat 110', 'AB 5678 ZZ');
final _pcx = _motor('m_pcx', 'PCX 160', 'AB 9012 QR');

BookingDraft _draft({
  List<String> selectedMotorIds = const ['m_vario', 'm_beat', 'm_pcx'],
  ScheduleMode scheduleMode = ScheduleMode.shared,
  TimeSlot? sharedSlot,
  Map<String, TimeSlot> unitSlots = const {},
}) => BookingDraft(
  id: 'draft_1',
  selectedMotorIds: selectedMotorIds,
  unitConfigs: const {},
  workshopId: 'ws_001',
  scheduleMode: scheduleMode,
  sharedSlot: sharedSlot,
  unitSlots: unitSlots,
  createdAt: DateTime(2026, 9, 28),
  expiresAt: DateTime(2026, 9, 29, 12),
);

List<TimeSlot> _daySlots(DateTime date, List<int> remainingByHour) => [
  for (var i = 0; i < remainingByHour.length; i++)
    TimeSlot(
      date: date,
      hour: 8 + i,
      capacity: 5,
      booked: 5 - remainingByHour[i],
    ),
];

void main() {
  group('PilihJadwalViewModel', () {
    late FakeBookingRepository bookingRepository;
    late FakeWorkshopRepository workshopRepository;
    late FakeGarageRepository garageRepository;
    late FakeClock clock;
    late ProviderContainer container;

    setUp(() {
      bookingRepository = FakeBookingRepository()
        ..createDraftResult = Result.ok(_draft());
      workshopRepository = FakeWorkshopRepository()
        ..workshopResult = const Result.ok(_jaya);
      garageRepository = FakeGarageRepository()
        ..motorsResult = Result.ok([_vario, _beat, _pcx]);
      clock = FakeClock(DateTime(2026, 9, 28, 10, 20));
      container = ProviderContainer(
        overrides: [
          bookingRepositoryProvider.overrideWithValue(bookingRepository),
          workshopRepositoryProvider.overrideWithValue(workshopRepository),
          garageRepositoryProvider.overrideWithValue(garageRepository),
          clockProvider.overrideWithValue(clock),
        ],
      );
      addTearDown(container.dispose);
    });

    Future<void> waitForLoad() async {
      container.listen(pilihJadwalViewModelProvider, (_, _) {});
      for (var i = 0; i < 100; i++) {
        if (!container.read(pilihJadwalViewModelProvider).isLoading &&
            container.read(bookingDraftProvider) != null) {
          return;
        }
        await Future<void>.delayed(const Duration(milliseconds: 5));
      }
      throw StateError('PilihJadwalViewModel never finished loading');
    }

    Future<void> waitForSearchDone() async {
      for (var i = 0; i < 200; i++) {
        if (!container.read(pilihJadwalViewModelProvider).allFullSearching) {
          return;
        }
        await Future<void>.delayed(const Duration(milliseconds: 5));
      }
      throw StateError('all-full next-day search never finished');
    }

    test('loads workshop, motors and today\'s slots for D+0', () async {
      await waitForLoad();
      final state = container.read(pilihJadwalViewModelProvider);

      expect(state.hasError, isFalse);
      expect(state.workshop?.id, 'ws_001');
      expect(
        state.motorsById.keys,
        containsAll(['m_vario', 'm_beat', 'm_pcx']),
      );
      expect(state.sharedDate, DateTime(2026, 9, 28));
    });

    test('canonical Sel 29 Sep table: shared chip states match the design '
        'doc\'s table for 3 units, "limited" never appears', () async {
      final canonicalDate = DateTime(2026, 9, 29);
      workshopRepository.availableSlotsByDate['2026-9-29'] = Result.ok(
        _daySlots(canonicalDate, [4, 4, 2, 1, 0, 3, 2, 4, 0]),
      );
      await waitForLoad();
      final notifier = container.read(pilihJadwalViewModelProvider.notifier);

      await notifier.selectDate(canonicalDate);
      final state = container.read(pilihJadwalViewModelProvider);

      const expected = [
        SlotChipState.available,
        SlotChipState.available,
        SlotChipState.short,
        SlotChipState.short,
        SlotChipState.full,
        SlotChipState.available,
        SlotChipState.short,
        SlotChipState.available,
        SlotChipState.full,
      ];
      for (var i = 0; i < state.sharedSlots.length; i++) {
        expect(
          notifier.sharedChipStateFor(state.sharedSlots[i], 3),
          expected[i],
          reason: 'hour ${8 + i}',
        );
      }
      expect(expected, isNot(contains(SlotChipState.limited)));
    });

    test('D+0: an hour before now+2h reads Lewat', () async {
      workshopRepository.availableSlotsByDate['2026-9-28'] = Result.ok(
        _daySlots(DateTime(2026, 9, 28), [4, 4, 2, 1, 0, 3, 2, 4, 0]),
      );
      await waitForLoad();
      final notifier = container.read(pilihJadwalViewModelProvider.notifier);
      final state = container.read(pilihJadwalViewModelProvider);

      final slot8 = state.sharedSlots.firstWhere((s) => s.hour == 8);
      expect(notifier.sharedChipStateFor(slot8, 3), SlotChipState.lewat);
    });

    test('selecting an invalid (full) slot is a no-op', () async {
      final date = DateTime(2026, 9, 29);
      workshopRepository.availableSlotsByDate['2026-9-29'] = Result.ok(
        _daySlots(date, [0, 4, 4, 4, 4, 4, 4, 4, 4]),
      );
      await waitForLoad();
      final notifier = container.read(pilihJadwalViewModelProvider.notifier);
      await notifier.selectDate(date);
      final fullSlot = container
          .read(pilihJadwalViewModelProvider)
          .sharedSlots
          .firstWhere((s) => s.hour == 8);

      await notifier.selectSharedSlot(fullSlot, 3);

      expect(container.read(bookingDraftProvider)!.sharedSlot, isNull);
    });

    test('selecting a valid slot persists it on the draft', () async {
      final date = DateTime(2026, 9, 29);
      workshopRepository.availableSlotsByDate['2026-9-29'] = Result.ok(
        _daySlots(date, [4, 4, 2, 1, 0, 3, 2, 4, 0]),
      );
      await waitForLoad();
      final notifier = container.read(pilihJadwalViewModelProvider.notifier);
      await notifier.selectDate(date);
      final slot9 = container
          .read(pilihJadwalViewModelProvider)
          .sharedSlots
          .firstWhere((s) => s.hour == 9);

      await notifier.selectSharedSlot(slot9, 3);

      expect(container.read(bookingDraftProvider)!.sharedSlot, slot9);
    });

    test('changing the date clears a previously chosen shared slot', () async {
      final date1 = DateTime(2026, 9, 29);
      final date2 = DateTime(2026, 9, 30);
      workshopRepository.availableSlotsByDate['2026-9-29'] = Result.ok(
        _daySlots(date1, [4, 4, 2, 1, 0, 3, 2, 4, 0]),
      );
      workshopRepository.availableSlotsByDate['2026-9-30'] = Result.ok(
        _daySlots(date2, [4, 4, 2, 1, 0, 3, 2, 4, 0]),
      );
      await waitForLoad();
      final notifier = container.read(pilihJadwalViewModelProvider.notifier);
      await notifier.selectDate(date1);
      final slot9 = container
          .read(pilihJadwalViewModelProvider)
          .sharedSlots
          .firstWhere((s) => s.hour == 9);
      await notifier.selectSharedSlot(slot9, 3);
      expect(container.read(bookingDraftProvider)!.sharedSlot, isNotNull);

      await notifier.selectDate(date2);

      expect(container.read(bookingDraftProvider)!.sharedSlot, isNull);
    });

    test(
      'all-full day finds the next date that actually fits the fleet',
      () async {
        final fullDate = DateTime(2026, 10, 1);
        final nextFitDate = DateTime(2026, 10, 2);
        workshopRepository.availableSlotsByDate['2026-10-1'] = Result.ok(
          _daySlots(fullDate, [0, 0, 0, 0, 0, 0, 0, 0, 0]),
        );
        workshopRepository.availableSlotsByDate['2026-10-2'] = Result.ok(
          _daySlots(nextFitDate, [4, 4, 4, 4, 4, 4, 4, 4, 4]),
        );
        await waitForLoad();
        final notifier = container.read(pilihJadwalViewModelProvider.notifier);

        await notifier.selectDate(fullDate);
        await waitForSearchDone();
        final state = container.read(pilihJadwalViewModelProvider);

        expect(notifier.isDayPureFull(state.sharedSlots), isTrue);
        expect(state.allFullNextDate, nextFitDate);
      },
    );

    group('split mode', () {
      test('mode toggle is non-destructive to the shared slot', () async {
        final date = DateTime(2026, 9, 29);
        workshopRepository.availableSlotsByDate['2026-9-29'] = Result.ok(
          _daySlots(date, [4, 4, 2, 1, 0, 3, 2, 4, 0]),
        );
        await waitForLoad();
        final notifier = container.read(pilihJadwalViewModelProvider.notifier);
        await notifier.selectDate(date);
        final slot9 = container
            .read(pilihJadwalViewModelProvider)
            .sharedSlots
            .firstWhere((s) => s.hour == 9);
        await notifier.selectSharedSlot(slot9, 3);

        await notifier.setScheduleMode(ScheduleMode.split);
        await notifier.setScheduleMode(ScheduleMode.shared);

        expect(container.read(bookingDraftProvider)!.sharedSlot, slot9);
      });

      test('sibling conflict: the last seat taken by one motor blocks another '
          'on the same slot', () async {
        final date = DateTime(2026, 9, 29);
        workshopRepository.availableSlotsByDate['2026-9-29'] = Result.ok(
          _daySlots(date, [
            4,
            4,
            2,
            1,
            0,
            3,
            2,
            4,
            0,
          ]), // hour 11 -> remaining 1
        );
        bookingRepository.createDraftResult = Result.ok(
          _draft(scheduleMode: ScheduleMode.split),
        );
        await waitForLoad();
        final notifier = container.read(pilihJadwalViewModelProvider.notifier);
        await notifier.selectUnitDate('m_vario', date);
        final slot11 = container
            .read(pilihJadwalViewModelProvider)
            .unitSlotsByMotor['m_vario']!
            .firstWhere((s) => s.hour == 11);

        await notifier.selectUnitSlot(
          'm_vario',
          slot11,
          container.read(bookingDraftProvider)!,
        );
        expect(
          container.read(bookingDraftProvider)!.unitSlots['m_vario'],
          slot11,
        );

        await notifier.selectUnitDate('m_beat', date);
        final draftAfterVario = container.read(bookingDraftProvider)!;
        final chip = notifier.splitChipStateFor(
          slot11,
          'm_beat',
          draftAfterVario,
        );
        expect(chip, SlotChipState.full);

        final conflict = notifier.siblingConflictLabel(
          slot11,
          'm_beat',
          draftAfterVario,
        );
        expect(conflict, contains('Vario 125'));

        await notifier.selectUnitSlot('m_beat', slot11, draftAfterVario);
        expect(
          container.read(bookingDraftProvider)!.unitSlots.containsKey('m_beat'),
          isFalse,
        );
      });

      test('split chip state collapses "short" into "limited" — a split unit '
          'only ever needs 1 seat', () async {
        final date = DateTime(2026, 9, 29);
        workshopRepository.availableSlotsByDate['2026-9-29'] = Result.ok(
          _daySlots(date, [4, 4, 2, 1, 0, 3, 2, 4, 0]),
        );
        bookingRepository.createDraftResult = Result.ok(
          _draft(scheduleMode: ScheduleMode.split),
        );
        await waitForLoad();
        final notifier = container.read(pilihJadwalViewModelProvider.notifier);
        await notifier.selectUnitDate('m_beat', date);
        final draft = container.read(bookingDraftProvider)!;
        final slot10 = container
            .read(pilihJadwalViewModelProvider)
            .unitSlotsByMotor['m_beat']!
            .firstWhere((s) => s.hour == 10);

        expect(
          notifier.splitChipStateFor(slot10, 'm_beat', draft),
          SlotChipState.limited,
        );
      });
    });

    group('slot tap outcomes & split assist', () {
      final date = DateTime(2026, 9, 29);

      setUp(() {
        workshopRepository.availableSlotsByDate['2026-9-29'] = Result.ok(
          _daySlots(date, [4, 4, 2, 1, 0, 3, 2, 4, 0]),
        );
      });

      test(
        'a short hour reports SlotTapShort and leaves the draft alone',
        () async {
          await waitForLoad();
          final notifier = container.read(
            pilihJadwalViewModelProvider.notifier,
          );
          await notifier.selectDate(date);
          final slot10 = container
              .read(pilihJadwalViewModelProvider)
              .sharedSlots
              .firstWhere((s) => s.hour == 10);

          final outcome = await notifier.selectSharedSlot(slot10, 3);

          expect(outcome, isA<SlotTapShort>());
          expect((outcome as SlotTapShort).slot.remaining, 2);
          expect(container.read(bookingDraftProvider)!.sharedSlot, isNull);
        },
      );

      test('a valid hour reports SlotTapSelected', () async {
        await waitForLoad();
        final notifier = container.read(pilihJadwalViewModelProvider.notifier);
        await notifier.selectDate(date);
        final slot8 = container
            .read(pilihJadwalViewModelProvider)
            .sharedSlots
            .firstWhere((s) => s.hour == 8);

        expect(
          await notifier.selectSharedSlot(slot8, 3),
          isA<SlotTapSelected>(),
        );
      });

      test('splitFromShortSlot switches to split, seats as many motors as '
          'fit and opens the next unscheduled motor', () async {
        await waitForLoad();
        final notifier = container.read(pilihJadwalViewModelProvider.notifier);
        await notifier.selectDate(date);
        final slot10 = container
            .read(pilihJadwalViewModelProvider)
            .sharedSlots
            .firstWhere((s) => s.hour == 10);

        await notifier.splitFromShortSlot(slot10);

        final draft = container.read(bookingDraftProvider)!;
        final state = container.read(pilihJadwalViewModelProvider);
        expect(draft.scheduleMode, ScheduleMode.split);
        expect(draft.unitSlots.keys, ['m_vario', 'm_beat']);
        expect(draft.unitSlots['m_vario']!.hour, 10);
        expect(draft.unitSlots['m_beat']!.hour, 10);
        expect(state.expandedMotorId, 'm_pcx');
        expect(state.unitDates['m_pcx'], date);
        expect(state.unitSlotsByMotor['m_pcx'], isNotEmpty);
        expect(state.unitSlotsByMotor['m_vario'], isNotEmpty);
      });

      test('split mode: an hour whose last bay a sibling holds reports '
          'SlotTapSiblingConflict naming that sibling', () async {
        final slot9 = TimeSlot(date: date, hour: 11, capacity: 5, booked: 4);
        bookingRepository.createDraftResult = Result.ok(
          _draft(
            scheduleMode: ScheduleMode.split,
            unitSlots: {'m_vario': slot9},
          ),
        );
        await waitForLoad();
        final notifier = container.read(pilihJadwalViewModelProvider.notifier);
        final draft = container.read(bookingDraftProvider)!;

        final outcome = await notifier.selectUnitSlot('m_beat', slot9, draft);

        expect(outcome, isA<SlotTapSiblingConflict>());
        expect((outcome as SlotTapSiblingConflict).nickname, 'Vario 125');
        expect(container.read(bookingDraftProvider)!.unitSlots.keys, [
          'm_vario',
        ]);
      });

      test('changing date shows loading immediately and a stale response is '
          'ignored', () async {
        final nextDate = DateTime(2026, 9, 30);
        workshopRepository.availableSlotsByDate['2026-9-30'] = Result.ok(
          _daySlots(nextDate, [4, 4, 4, 4, 4, 4, 4, 4, 4]),
        );
        await waitForLoad();
        final notifier = container.read(pilihJadwalViewModelProvider.notifier);

        final first = notifier.selectDate(date);
        expect(
          container.read(pilihJadwalViewModelProvider).sharedSlotsLoading,
          isTrue,
        );
        final second = notifier.selectDate(nextDate);
        await Future.wait([first, second]);

        final state = container.read(pilihJadwalViewModelProvider);
        expect(state.sharedDate, nextDate);
        expect(state.sharedSlotsLoading, isFalse);
        expect(state.sharedSlots.first.date, nextDate);
      });
    });
  });
}
