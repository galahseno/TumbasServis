import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/tracking/data/di/tracking_data_module.dart';
import 'package:tumbas_servis/tracking/presentation/di/tracking_presentation_module.dart';
import 'package:tumbas_servis/tracking/presentation/lacak_unit/state/lacak_unit_state.dart';
import 'package:tumbas_servis/workshop/data/di/workshop_data_module.dart';

import '../../../support/fake_booking_repository.dart';
import '../../../support/fake_catalog_repository.dart';
import '../../../support/fake_tracking_repository.dart';
import '../../../support/fake_workshop_repository.dart';
import '../../../support/tracking_fixtures.dart';

const _args = (bookingId: 'bk', unitCode: '-B');

void main() {
  late FakeBookingRepository bookingRepository;
  late FakeTrackingRepository trackingRepository;
  late FakeWorkshopRepository workshopRepository;
  late ProviderContainer container;

  setUp(() {
    bookingRepository = FakeBookingRepository();
    trackingRepository = FakeTrackingRepository();
    workshopRepository = FakeWorkshopRepository()
      ..mechanicsResult = const Result.ok(mechanicFixtures);
    container = ProviderContainer(
      overrides: [
        bookingRepositoryProvider.overrideWithValue(bookingRepository),
        trackingRepositoryProvider.overrideWithValue(trackingRepository),
        workshopRepositoryProvider.overrideWithValue(workshopRepository),
        catalogRepositoryProvider.overrideWithValue(
          FakeCatalogRepository()
            ..serviceTypesResult = const Result.ok(serviceFixtures)
            ..partsResult = const Result.ok(partFixtures),
        ),
      ],
    );
    addTearDown(container.dispose);
  });

  Booking bookingWith(UnitStatus status, {String? mechanicId}) =>
      trackedBooking('bk', [
        trackedUnit('-A', UnitStatus.terjadwal, motorId: 'm1'),
        trackedUnit(
          '-B',
          status,
          motorId: 'm2',
          nickname: 'Beat 110',
          mechanicId: mechanicId,
          partIds: const ['part_oli'],
        ),
      ]);

  Future<LacakUnitState> load(Booking booking) async {
    bookingRepository.getBookingResult = Result.ok(booking);
    final provider = lacakUnitViewModelProvider(_args);
    container.listen(provider, (_, _) {});
    for (var i = 0; i < 50; i++) {
      if (!container.read(provider).isLoading) break;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    return container.read(provider);
  }

  test('loads the unit, its services summary and the ETA', () async {
    final state = await load(bookingWith(UnitStatus.dikerjakan));

    expect(state.unit!.unitCode, '-B');
    expect(state.servicesSummary, 'Servis Berkala + Oli');
    // 09.00 slot + 75 min.
    expect(state.estimatedFinish, DateTime(2026, 9, 29, 10, 15));
    expect(state.showDemoShortcut, isTrue);
  });

  test('resolves the assigned mechanic; unassigned stays null', () async {
    final assigned = await load(
      bookingWith(UnitStatus.dikerjakan, mechanicId: 'mech_001'),
    );
    expect(assigned.mechanic?.name, 'Mas Rudi');

    final other = ProviderContainer(
      overrides: [
        bookingRepositoryProvider.overrideWithValue(
          FakeBookingRepository()
            ..getBookingResult = Result.ok(bookingWith(UnitStatus.terjadwal)),
        ),
        trackingRepositoryProvider.overrideWithValue(FakeTrackingRepository()),
        workshopRepositoryProvider.overrideWithValue(workshopRepository),
        catalogRepositoryProvider.overrideWithValue(
          FakeCatalogRepository()
            ..serviceTypesResult = const Result.ok(serviceFixtures)
            ..partsResult = const Result.ok(partFixtures),
        ),
      ],
    );
    addTearDown(other.dispose);
    other.listen(lacakUnitViewModelProvider(_args), (_, _) {});
    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(other.read(lacakUnitViewModelProvider(_args)).mechanic, isNull);
  });

  test('a failed mechanic lookup does not block tracking', () async {
    workshopRepository.mechanicsResult = Result.error(Exception('x'));
    final state = await load(
      bookingWith(UnitStatus.dikerjakan, mechanicId: 'mech_001'),
    );

    expect(state.hasError, isFalse);
    expect(state.unit, isNotNull);
    expect(state.mechanic, isNull);
  });

  test('stream updates walk the timeline live to Selesai', () async {
    final provider = lacakUnitViewModelProvider(_args);
    await load(bookingWith(UnitStatus.checkIn, mechanicId: 'mech_001'));

    for (final status in [
      UnitStatus.diperiksa,
      UnitStatus.dikerjakan,
      UnitStatus.qc,
      UnitStatus.selesai,
    ]) {
      trackingRepository.emit(
        'bk',
        trackedUnit('-B', status, motorId: 'm2', mechanicId: 'mech_001'),
      );
      expect(container.read(provider).status, status);
    }

    final done = container.read(provider);
    expect(done.isCompleted, isTrue);
    expect(done.canAdvance, isFalse);
    expect(done.canReset, isTrue);
    expect(done.completedAt, isNotNull);
  });

  test(
    'a mechanic assigned mid-flow shows up with the stream update',
    () async {
      final provider = lacakUnitViewModelProvider(_args);
      await load(bookingWith(UnitStatus.terjadwal));
      expect(container.read(provider).mechanic, isNull);

      trackingRepository.emit(
        'bk',
        trackedUnit(
          '-B',
          UnitStatus.checkIn,
          motorId: 'm2',
          mechanicId: 'mech_001',
        ),
      );

      expect(container.read(provider).mechanic?.name, 'Mas Rudi');
    },
  );

  test(
    'the demo shortcut drives the same repository methods S26 uses',
    () async {
      final provider = lacakUnitViewModelProvider(_args);
      await load(bookingWith(UnitStatus.dikerjakan));
      final viewModel = container.read(provider.notifier);

      expect(await viewModel.advance(), isTrue);
      expect(await viewModel.reset(), isTrue);

      expect(trackingRepository.advanceCalls.single, (
        bookingId: 'bk',
        unitCode: '-B',
      ));
      expect(trackingRepository.resetCalls.single, (
        bookingId: 'bk',
        unitCode: '-B',
      ));
      expect(container.read(provider).isDemoBusy, isFalse);
    },
  );

  test(
    'a failing demo action reports false and unlocks the controls',
    () async {
      final provider = lacakUnitViewModelProvider(_args);
      await load(bookingWith(UnitStatus.dikerjakan));
      trackingRepository.advanceResult = Result.error(Exception('x'));

      final ok = await container.read(provider.notifier).advance();

      expect(ok, isFalse);
      expect(container.read(provider).isDemoBusy, isFalse);
    },
  );

  test('cancelled unit: no demo shortcut, cancelled flag set', () async {
    final state = await load(bookingWith(UnitStatus.dibatalkan));

    expect(state.isCancelled, isTrue);
    expect(state.showDemoShortcut, isFalse);
    expect(state.canAdvance, isFalse);
  });

  test('an unknown unit code is an error state', () async {
    bookingRepository.getBookingResult = Result.ok(
      bookingWith(UnitStatus.dikerjakan),
    );
    final provider = lacakUnitViewModelProvider((
      bookingId: 'bk',
      unitCode: '-Z',
    ));
    container.listen(provider, (_, _) {});
    await Future<void>.delayed(const Duration(milliseconds: 30));

    expect(container.read(provider).hasError, isTrue);
  });
}
