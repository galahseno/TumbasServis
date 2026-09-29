import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/catalog/data/di/catalog_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor_model.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';
import 'package:tumbas_servis/garage/presentation/di/garage_presentation_module.dart';

import '../../../support/fake_booking_repository.dart';
import '../../../support/fake_catalog_repository.dart';
import '../../../support/fake_garage_repository.dart';
import '../../../support/garage_fixtures.dart';

const _beatModel = MotorModel(
  id: 'model_beat',
  brand: MotorBrand.honda,
  name: 'Beat 110',
  category: MotorCategory.matic,
  cc: 110,
);

const _berkala = ServiceType(
  id: 'svc_berkala',
  name: 'Servis Berkala',
  price: 85000,
  durationMin: 60,
  requiresComplaint: false,
);
const _oli = ServiceType(
  id: 'svc_oli',
  name: 'Oli',
  price: 58000,
  durationMin: 15,
  requiresComplaint: false,
);

void main() {
  late FakeGarageRepository garageRepository;
  late FakeBookingRepository bookingRepository;
  late FakeCatalogRepository catalogRepository;
  late ProviderContainer container;

  setUp(() {
    garageRepository = FakeGarageRepository()
      ..motorsResult = Result.ok([motorFixture('m1')])
      ..motorModelsResult = const Result.ok([_beatModel]);
    bookingRepository = FakeBookingRepository();
    catalogRepository = FakeCatalogRepository()
      ..serviceTypesResult = const Result.ok([_berkala, _oli]);
    container = ProviderContainer(
      overrides: [
        garageRepositoryProvider.overrideWithValue(garageRepository),
        bookingRepositoryProvider.overrideWithValue(bookingRepository),
        catalogRepositoryProvider.overrideWithValue(catalogRepository),
      ],
    );
    addTearDown(container.dispose);
  });

  Future<void> load([String id = 'm1']) async {
    container.listen(motorDetailViewModelProvider, (_, _) {});
    await container.read(motorDetailViewModelProvider.notifier).initialize(id);
  }

  test('free motor: no active booking, empty history', () async {
    await load();
    final state = container.read(motorDetailViewModelProvider);

    expect(state.isLoading, isFalse);
    expect(state.motor?.id, 'm1');
    expect(state.model, _beatModel);
    expect(state.hasActiveBooking, isFalse);
    expect(state.pastHistory, isEmpty);
    expect(state.showSeeAllHistory, isFalse);
  });

  test(
    'non-terminal unit marks motor in service and is not in history',
    () async {
      bookingRepository.bookingsResult = Result.ok([
        bookingFixture('bk_1', [
          unitFixture('-B', 'm1', UnitStatus.dikerjakan),
        ]),
      ]);
      await load();
      final state = container.read(motorDetailViewModelProvider);

      expect(state.hasActiveBooking, isTrue);
      expect(state.inServiceStatus, UnitStatus.dikerjakan);
      expect(state.activeEntry?.bookingId, 'bk_1');
      expect(state.activeEntry?.unitCode, '-B');
      expect(state.pastHistory, isEmpty);
    },
  );

  test('units of other motors are ignored', () async {
    bookingRepository.bookingsResult = Result.ok([
      bookingFixture('bk_1', [unitFixture('-A', 'm2', UnitStatus.dikerjakan)]),
    ]);
    await load();

    expect(
      container.read(motorDetailViewModelProvider).hasActiveBooking,
      isFalse,
    );
  });

  test(
    'past history is latest-first, capped at 3 rows, see-all offered',
    () async {
      bookingRepository.bookingsResult = Result.ok([
        for (var i = 1; i <= 4; i++)
          bookingFixture(
            'bk_$i',
            [unitFixture('-$i', 'm1', UnitStatus.selesai)],
            createdAt: DateTime(2026, i),
            completedAt: DateTime(2026, i, 5),
          ),
      ]);
      await load();
      final state = container.read(motorDetailViewModelProvider);

      expect(state.pastHistory.map((e) => e.bookingId), [
        'bk_4',
        'bk_3',
        'bk_2',
        'bk_1',
      ]);
      expect(state.latestPastHistory, hasLength(3));
      expect(state.showSeeAllHistory, isTrue);
    },
  );

  test('services summary joins known service names with " + "', () async {
    bookingRepository.bookingsResult = Result.ok([
      bookingFixture('bk_1', [
        unitFixture(
          '-A',
          'm1',
          UnitStatus.selesai,
          serviceIds: const ['svc_berkala', 'svc_unknown', 'svc_oli'],
        ),
      ]),
    ]);
    await load();

    expect(
      container
          .read(motorDetailViewModelProvider)
          .pastHistory
          .single
          .servicesSummary,
      'Servis Berkala + Oli',
    );
  });

  test('unknown motor id surfaces as hasError', () async {
    await load('missing');

    expect(container.read(motorDetailViewModelProvider).hasError, isTrue);
  });

  test('any source repository error surfaces as hasError', () async {
    catalogRepository.serviceTypesResult = Result.error(Exception('boom'));
    await load();

    expect(container.read(motorDetailViewModelProvider).hasError, isTrue);
  });

  test('deleteMotor returns true when the repository deletes', () async {
    await load();
    final deleted = await container
        .read(motorDetailViewModelProvider.notifier)
        .deleteMotor();

    expect(deleted, isTrue);
    expect(garageRepository.lastDeletedMotorId, 'm1');
  });

  test('deleteMotor returns false when the repository refuses', () async {
    garageRepository.deleteMotorResult = Result.error(Exception('active'));
    await load();
    final deleted = await container
        .read(motorDetailViewModelProvider.notifier)
        .deleteMotor();

    expect(deleted, isFalse);
    expect(container.read(motorDetailViewModelProvider).isDeleting, isFalse);
  });
}
