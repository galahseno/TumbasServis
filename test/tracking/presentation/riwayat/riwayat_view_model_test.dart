import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/tracking/presentation/di/tracking_presentation_module.dart';
import 'package:tumbas_servis/tracking/presentation/riwayat/state/riwayat_state.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';

import '../../../support/fake_booking_repository.dart';
import '../../../support/fake_workshop_repository.dart';
import '../../../support/tracking_fixtures.dart';

/// The demo dataset: 5 seed bookings + the runtime canonical booking.
List<Booking> _demoBookings() => [
  trackedBooking('sel1', [
    trackedUnit('-A', UnitStatus.selesai, motorId: 'm1'),
  ], slot: slotFixture(date: DateTime(2026, 9, 10))),
  trackedBooking('sel2', [
    trackedUnit('-A', UnitStatus.selesai, motorId: 'm1'),
  ], slot: slotFixture(date: DateTime(2026, 7, 14))),
  trackedBooking('batal', [
    trackedUnit('-A', UnitStatus.dibatalkan, motorId: 'm2', nickname: 'Supra'),
  ], slot: slotFixture(date: DateTime(2026, 5, 2))),
  trackedBooking('next2', [
    trackedUnit('-A', UnitStatus.terjadwal, motorId: 'm2', nickname: 'Supra'),
  ], slot: slotFixture(date: DateTime(2026, 10, 7))),
  trackedBooking('next1', [
    trackedUnit('-A', UnitStatus.terjadwal, motorId: 'm2', nickname: 'Supra'),
  ], slot: slotFixture(date: DateTime(2026, 10, 6))),
  trackedBooking('live', [
    trackedUnit('-A', UnitStatus.dikerjakan, motorId: 'm1'),
    trackedUnit('-B', UnitStatus.dikerjakan, motorId: 'm3', nickname: 'PCX'),
    trackedUnit('-C', UnitStatus.diperiksa, motorId: 'm4', nickname: 'Vario'),
  ]),
];

void main() {
  late FakeBookingRepository bookingRepository;
  late FakeWorkshopRepository workshopRepository;
  late ProviderContainer container;

  setUp(() {
    bookingRepository = FakeBookingRepository()
      ..bookingsResult = Result.ok(_demoBookings());
    workshopRepository = FakeWorkshopRepository()
      ..workshopsResult = const Result.ok([workshopFixture]);
    container = ProviderContainer(
      overrides: [
        bookingRepositoryProvider.overrideWithValue(bookingRepository),
        workshopRepositoryProvider.overrideWithValue(workshopRepository),
      ],
    );
    addTearDown(container.dispose);
  });

  Future<RiwayatState> load([String? motorId]) async {
    final provider = riwayatViewModelProvider(motorId);
    container.listen(provider, (_, _) {});
    for (var i = 0; i < 50; i++) {
      if (!container.read(provider).isLoading) break;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    return container.read(provider);
  }

  test('tab counts follow the data: Mendatang 2 · Berlangsung 1 · '
      'Selesai 2 · Dibatalkan 1', () async {
    final state = await load();

    expect(state.countFor(RiwayatTab.mendatang), 2);
    expect(state.countFor(RiwayatTab.berlangsung), 1);
    expect(state.countFor(RiwayatTab.selesai), 2);
    expect(state.countFor(RiwayatTab.dibatalkan), 1);
  });

  test('opens on Berlangsung when it has bookings', () async {
    final state = await load();
    expect(state.selectedTab, RiwayatTab.berlangsung);
    expect(state.visibleEntries.single.booking.id, 'live');
    expect(state.visibleEntries.single.workshopName, 'Bengkel Jaya Motor');
  });

  test(
    'falls back to the first non-empty tab when nothing is in progress',
    () async {
      bookingRepository.bookingsResult = Result.ok(
        _demoBookings().where((b) => b.id != 'live').toList(),
      );
      final state = await load();
      expect(state.selectedTab, RiwayatTab.mendatang);
    },
  );

  test(
    'Mendatang lists the soonest first; Selesai lists the latest first',
    () async {
      final provider = riwayatViewModelProvider(null);
      await load();
      final viewModel = container.read(provider.notifier);

      viewModel.selectTab(RiwayatTab.mendatang);
      expect(container.read(provider).visibleEntries.map((e) => e.booking.id), [
        'next1',
        'next2',
      ]);

      viewModel.selectTab(RiwayatTab.selesai);
      expect(container.read(provider).visibleEntries.map((e) => e.booking.id), [
        'sel1',
        'sel2',
      ]);
    },
  );

  test('a user-picked tab survives a silent refresh', () async {
    final provider = riwayatViewModelProvider(null);
    await load();
    final viewModel = container.read(provider.notifier);
    viewModel.selectTab(RiwayatTab.selesai);

    await viewModel.refresh();

    expect(container.read(provider).selectedTab, RiwayatTab.selesai);
  });

  test('motor filter (from S09) narrows the list, recomputes the counts '
      'and shows a label; clearing restores everything', () async {
    final provider = riwayatViewModelProvider('m2');
    final state = await load('m2');

    expect(state.motorFilterLabel, 'Supra');
    expect(state.countFor(RiwayatTab.mendatang), 2);
    expect(state.countFor(RiwayatTab.berlangsung), 0);
    expect(state.countFor(RiwayatTab.selesai), 0);
    expect(state.countFor(RiwayatTab.dibatalkan), 1);
    // Nothing in progress for this motor → first non-empty tab.
    expect(state.selectedTab, RiwayatTab.mendatang);

    container.read(provider.notifier).clearMotorFilter();
    final cleared = container.read(provider);
    expect(cleared.motorFilterId, isNull);
    expect(cleared.countFor(RiwayatTab.selesai), 2);
    expect(cleared.selectedTab, RiwayatTab.berlangsung);
  });

  test('a filtered push never shares state with the Riwayat tab', () async {
    await load();
    await load('m2');

    expect(
      container
          .read(riwayatViewModelProvider(null))
          .countFor(RiwayatTab.selesai),
      2,
    );
    expect(
      container
          .read(riwayatViewModelProvider('m2'))
          .countFor(RiwayatTab.selesai),
      0,
    );
  });

  test('load failure sets hasError; retry recovers', () async {
    bookingRepository.bookingsResult = Result.error(Exception('boom'));
    final provider = riwayatViewModelProvider(null);
    final failed = await load();
    expect(failed.hasError, isTrue);

    bookingRepository.bookingsResult = Result.ok(_demoBookings());
    await container.read(provider.notifier).retry();

    final recovered = container.read(provider);
    expect(recovered.hasError, isFalse);
    expect(recovered.isLoading, isFalse);
    expect(recovered.entries, hasLength(6));
  });
}
