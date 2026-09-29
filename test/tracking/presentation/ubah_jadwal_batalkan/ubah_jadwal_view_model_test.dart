import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/core/data/di/core_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/domain/service/scheduling/slot_capacity_service.dart';
import 'package:tumbas_servis/tracking/presentation/di/tracking_presentation_module.dart';
import 'package:tumbas_servis/tracking/presentation/ubah_jadwal_batalkan/batalkan_dialog.dart';
import 'package:tumbas_servis/tracking/presentation/ubah_jadwal_batalkan/state/ubah_jadwal_state.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';

import '../../../support/fake_booking_repository.dart';
import '../../../support/fake_clock.dart';
import '../../../support/fake_workshop_repository.dart';
import '../../../support/tracking_fixtures.dart';

final _today = DateTime(2026, 9, 29);

/// 08.00–16.00 with a mix of availability; hour 9 is the booking's own slot.
List<TimeSlot> _daySlots(DateTime date) => [
  for (var hour = 8; hour <= 16; hour++)
    TimeSlot(
      date: date,
      hour: hour,
      capacity: 5,
      booked: switch (hour) {
        9 => 5, // the booking's own seats fill its slot
        10 => 5, // genuinely full
        11 => 4, // only 1 seat left (< 2 units)
        _ => 1,
      },
    ),
];

void main() {
  late FakeBookingRepository bookingRepository;
  late FakeWorkshopRepository workshopRepository;
  late ProviderContainer container;

  final booking = trackedBooking('bk', [
    trackedUnit('-A', UnitStatus.terjadwal, motorId: 'm1'),
    trackedUnit('-B', UnitStatus.terjadwal, motorId: 'm2'),
  ], slot: slotFixture(date: _today, booked: 2));
  final args = (booking: booking, workshopName: 'Bengkel', bayCount: 2);

  setUp(() {
    bookingRepository = FakeBookingRepository();
    workshopRepository = FakeWorkshopRepository()
      ..availableSlotsResult = Result.ok(_daySlots(_today));
    container = ProviderContainer(
      overrides: [
        bookingRepositoryProvider.overrideWithValue(bookingRepository),
        workshopRepositoryProvider.overrideWithValue(workshopRepository),
        // 06.00 on the booking's day: nothing is past the 2 h cut-off yet.
        clockProvider.overrideWithValue(FakeClock(DateTime(2026, 9, 29, 6))),
      ],
    );
    addTearDown(container.dispose);
  });

  Future<UbahJadwalState> load([UbahJadwalArgs? overrideArgs]) async {
    final provider = ubahJadwalViewModelProvider(overrideArgs ?? args);
    container.listen(provider, (_, _) {});
    for (var i = 0; i < 50; i++) {
      if (!container.read(provider).isLoadingSlots) break;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    return container.read(provider);
  }

  TimeSlot slotAt(UbahJadwalState state, int hour) =>
      state.slots.firstWhere((s) => s.hour == hour);

  test(
    'opens on the booking\'s own date with its current slot selected',
    () async {
      final state = await load();

      expect(state.selectedDate, _today);
      expect(state.selectedSlot!.hour, 9);
      expect(state.slots, hasLength(9));
    },
  );

  test(
    'the current slot is never locked out, even when its own seats fill it',
    () async {
      final state = await load();
      final viewModel = container.read(
        ubahJadwalViewModelProvider(args).notifier,
      );

      expect(viewModel.isCurrent(slotAt(state, 9)), isTrue);
      expect(viewModel.chipState(slotAt(state, 9)), SlotChipState.available);
      expect(viewModel.chipState(slotAt(state, 10)), SlotChipState.full);
      expect(viewModel.chipState(slotAt(state, 11)), SlotChipState.short);
    },
  );

  test('full / too-small slots cannot be selected; free ones can', () async {
    final provider = ubahJadwalViewModelProvider(args);
    final state = await load();
    final viewModel = container.read(provider.notifier);

    viewModel.selectSlot(slotAt(state, 10));
    expect(container.read(provider).selectedSlot!.hour, 9);
    viewModel.selectSlot(slotAt(state, 11));
    expect(container.read(provider).selectedSlot!.hour, 9);

    viewModel.selectSlot(slotAt(state, 14));
    expect(container.read(provider).selectedSlot!.hour, 14);
  });

  test(
    'past-cut-off slots on today show Lewat and are not selectable',
    () async {
      final clock = FakeClock(DateTime(2026, 9, 29, 12));
      final late = ProviderContainer(
        overrides: [
          bookingRepositoryProvider.overrideWithValue(bookingRepository),
          workshopRepositoryProvider.overrideWithValue(workshopRepository),
          clockProvider.overrideWithValue(clock),
        ],
      );
      addTearDown(late.dispose);
      final provider = ubahJadwalViewModelProvider(args);
      late.listen(provider, (_, _) {});
      await Future<void>.delayed(const Duration(milliseconds: 30));
      final viewModel = late.read(provider.notifier);
      final state = late.read(provider);

      expect(viewModel.chipState(slotAt(state, 13)), SlotChipState.lewat);
      viewModel.selectSlot(slotAt(state, 13));
      expect(late.read(provider).selectedSlot!.hour, 9);
    },
  );

  test(
    're-selecting the current slot saves as a no-op (no repository call)',
    () async {
      final provider = ubahJadwalViewModelProvider(args);
      await load();

      final saved = await container.read(provider.notifier).save();

      expect(saved, isTrue);
      expect(bookingRepository.rescheduleCalls, isEmpty);
    },
  );

  test('saving a new slot calls the repository once and closes', () async {
    final provider = ubahJadwalViewModelProvider(args);
    final state = await load();
    final viewModel = container.read(provider.notifier);
    bookingRepository.rescheduleBookingResult = Result.ok(booking);

    viewModel.selectSlot(slotAt(state, 14));
    final saved = await viewModel.save();

    expect(saved, isTrue);
    expect(bookingRepository.rescheduleCalls.single.id, 'bk');
    expect(bookingRepository.rescheduleCalls.single.slot!.hour, 14);
    expect(container.read(provider).isSaving, isFalse);
  });

  test('a failed save keeps the sheet open with the inline error; retry '
      'succeeds', () async {
    final provider = ubahJadwalViewModelProvider(args);
    final state = await load();
    final viewModel = container.read(provider.notifier);

    viewModel.selectSlot(slotAt(state, 14));
    expect(await viewModel.save(), isFalse);
    expect(container.read(provider).saveFailed, isTrue);
    expect(container.read(provider).isSaving, isFalse);

    bookingRepository.rescheduleBookingResult = Result.ok(booking);
    expect(await viewModel.save(), isTrue);
    expect(container.read(provider).saveFailed, isFalse);
  });

  test('changing the date clears the selection; coming back restores the '
      'current slot', () async {
    final provider = ubahJadwalViewModelProvider(args);
    await load();
    final viewModel = container.read(provider.notifier);

    await viewModel.selectDate(_today.add(const Duration(days: 1)));
    expect(container.read(provider).selectedSlot, isNull);
    expect(viewModel.canSave, isFalse);

    await viewModel.selectDate(_today);
    expect(container.read(provider).selectedSlot!.hour, 9);
  });

  test('the strip covers today..today+14', () async {
    await load();
    final dates = container
        .read(ubahJadwalViewModelProvider(args).notifier)
        .dates;

    expect(dates.first, _today);
    expect(dates.last, _today.add(const Duration(days: 14)));
    expect(dates, hasLength(15));
  });

  test('cancelled units do not count toward the needed seats', () async {
    final partlyCancelled = trackedBooking('bk2', [
      trackedUnit('-A', UnitStatus.terjadwal, motorId: 'm1'),
      trackedUnit('-B', UnitStatus.dibatalkan, motorId: 'm2'),
    ], slot: slotFixture(date: _today));
    final partial = (
      booking: partlyCancelled,
      workshopName: 'Bengkel',
      bayCount: 2,
    );
    final state = await load(partial);
    final viewModel = container.read(
      ubahJadwalViewModelProvider(partial).notifier,
    );

    expect(viewModel.unitCount, 1);
    // One seat left is enough for the single live unit.
    expect(viewModel.chipState(slotAt(state, 11)), SlotChipState.limited);
  });

  group('cancelScopeOptions', () {
    final threeUnits = trackedBooking('bk3', [
      trackedUnit(
        '-A',
        UnitStatus.terjadwal,
        motorId: 'm1',
        nickname: 'Vario 125',
      ),
      trackedUnit(
        '-B',
        UnitStatus.terjadwal,
        motorId: 'm2',
        nickname: 'Beat 110',
      ),
      trackedUnit(
        '-C',
        UnitStatus.terjadwal,
        motorId: 'm3',
        nickname: 'PCX 160',
      ),
    ]);

    test('whole booking first, then one row per Terjadwal unit', () {
      final options = cancelScopeOptions(threeUnits, canCancelWhole: true);

      expect(options.map((o) => o.label), [
        'Seluruh booking · 3 motor',
        'Hanya Vario 125 · Unit -A',
        'Hanya Beat 110 · Unit -B',
        'Hanya PCX 160 · Unit -C',
      ]);
      expect(options.first.unitCode, isNull);
      expect(options[2].unitCode, '-B');
    });

    test('a single-motor booking offers only the whole booking', () {
      final single = trackedBooking('bk4', [
        trackedUnit('-A', UnitStatus.terjadwal),
      ]);
      final options = cancelScopeOptions(single, canCancelWhole: true);

      expect(options.map((o) => o.label), ['Seluruh booking · 1 motor']);
    });

    test('when some units already checked in only Terjadwal ones are '
        'offered, and not the whole booking', () {
      final mixed = trackedBooking('bk5', [
        trackedUnit('-A', UnitStatus.terjadwal, nickname: 'Vario 125'),
        trackedUnit('-B', UnitStatus.dikerjakan, motorId: 'm2'),
      ], mode: ScheduleMode.split);
      final options = cancelScopeOptions(mixed, canCancelWhole: false);

      expect(options.map((o) => o.label), ['Hanya Vario 125 · Unit -A']);
    });
  });
}
