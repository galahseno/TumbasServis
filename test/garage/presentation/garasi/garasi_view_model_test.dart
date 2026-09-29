import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/booking/data/di/booking_data_module.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/garage/data/di/garage_data_module.dart';
import 'package:tumbas_servis/garage/presentation/di/garage_presentation_module.dart';

import '../../../support/fake_booking_repository.dart';
import '../../../support/fake_garage_repository.dart';
import '../../../support/garage_fixtures.dart';

void main() {
  late FakeGarageRepository garageRepository;
  late FakeBookingRepository bookingRepository;
  late ProviderContainer container;

  setUp(() {
    garageRepository = FakeGarageRepository();
    bookingRepository = FakeBookingRepository();
    container = ProviderContainer(
      overrides: [
        garageRepositoryProvider.overrideWithValue(garageRepository),
        bookingRepositoryProvider.overrideWithValue(bookingRepository),
      ],
    );
    addTearDown(container.dispose);
  });

  Future<void> waitForLoad() async {
    container.listen(garasiViewModelProvider, (_, _) {});
    for (var i = 0; i < 100; i++) {
      if (!container.read(garasiViewModelProvider).isLoading) return;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    throw StateError('GarasiViewModel never finished loading');
  }

  test('empty garage is confirmed empty (header + hidden)', () async {
    await waitForLoad();
    final state = container.read(garasiViewModelProvider);

    expect(state.isConfirmedEmpty, isTrue);
    expect(state.motors, isEmpty);
  });

  test('populated garage is not empty', () async {
    garageRepository.motorsResult = Result.ok([
      motorFixture('m1'),
      motorFixture('m2', nickname: 'Vario'),
    ]);
    await waitForLoad();
    final state = container.read(garasiViewModelProvider);

    expect(state.isConfirmedEmpty, isFalse);
    expect(state.motors, hasLength(2));
  });

  test('only non-terminal booking units mark a motor in service', () async {
    garageRepository.motorsResult = Result.ok([
      motorFixture('m1'),
      motorFixture('m2'),
      motorFixture('m3'),
    ]);
    bookingRepository.bookingsResult = Result.ok([
      bookingFixture('bk_1', [
        unitFixture('-A', 'm1', UnitStatus.dikerjakan),
        unitFixture('-B', 'm2', UnitStatus.selesai),
        unitFixture('-C', 'm3', UnitStatus.dibatalkan),
      ]),
    ]);
    await waitForLoad();
    final state = container.read(garasiViewModelProvider);

    expect(state.motorInServiceStatus, {'m1': UnitStatus.dikerjakan});
  });

  test('a garage repository error surfaces as hasError', () async {
    garageRepository.motorsResult = Result.error(Exception('boom'));
    await waitForLoad();
    final state = container.read(garasiViewModelProvider);

    expect(state.hasError, isTrue);
    expect(state.isConfirmedEmpty, isFalse);
  });

  test('a booking repository error surfaces as hasError', () async {
    bookingRepository.bookingsResult = Result.error(Exception('boom'));
    await waitForLoad();

    expect(container.read(garasiViewModelProvider).hasError, isTrue);
  });

  test('refresh reloads and clears a previous error', () async {
    garageRepository.motorsResult = Result.error(Exception('boom'));
    await waitForLoad();
    expect(container.read(garasiViewModelProvider).hasError, isTrue);

    garageRepository.motorsResult = Result.ok([motorFixture('m1')]);
    await container.read(garasiViewModelProvider.notifier).refresh();
    final state = container.read(garasiViewModelProvider);

    expect(state.hasError, isFalse);
    expect(state.motors, hasLength(1));
  });
}
