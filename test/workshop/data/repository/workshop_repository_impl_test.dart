import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/data/service/mock_json_loader.dart';
import 'package:tumbas_servis/core/data/service/slot_occupancy_calculator.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/workshop/mechanic.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/core/domain/service/scheduling/slot_capacity_service.dart';
import 'package:tumbas_servis/workshop/data/repository/workshop_repository_impl.dart';

import '../../../support/fake_clock.dart';
import '../../../support/fake_latency_simulator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late LocalStore localStore;
  late FakeClock clock;
  late WorkshopRepositoryImpl repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tempDir = Directory.systemTemp.createTempSync('workshop_repo_test');
    localStore = LocalStore(
      preferences: await SharedPreferences.getInstance(),
      resolveStorageDirectory: () async => tempDir.path,
    );
    clock = FakeClock(DateTime(2026, 9, 28, 10, 20));
    repository = WorkshopRepositoryImpl(
      mockJsonLoader: MockJsonLoader(),
      latencySimulator: FakeLatencySimulator(),
      clock: clock,
      localStore: localStore,
    );
  });

  tearDown(() async {
    await Hive.close();
    tempDir.deleteSync(recursive: true);
  });

  test('getMechanics loads the six mock mechanics', () async {
    final result = await repository.getMechanics();

    expect(result, isA<Ok<List<Mechanic>>>());
    final mechanics = (result as Ok<List<Mechanic>>).value;
    expect(mechanics, hasLength(6));
    final rudi = mechanics.firstWhere((m) => m.id == 'mech_001');
    expect(rudi.name, 'Mas Rudi');
    expect(rudi.avatarInitial, 'R');
    expect(rudi.rating, 4.8);
  });

  test('getWorkshops returns all 5 workshops sorted by distance', () async {
    final result = await repository.getWorkshops();
    expect(result, isA<Ok<List<Workshop>>>());
    final workshops = (result as Ok<List<Workshop>>).value;
    expect(workshops, hasLength(5));
    expect(workshops.first.id, 'ws_001');
    for (var i = 1; i < workshops.length; i++) {
      expect(
        workshops[i].distanceKm,
        greaterThanOrEqualTo(workshops[i - 1].distanceKm),
      );
    }
  });

  test(
    'getWorkshops(openNowOnly: true) excludes a workshop closed at this hour',
    () async {
      clock.setNow(DateTime(2026, 9, 28, 10, 0));
      final result = await repository.getWorkshops(openNowOnly: true);
      final workshops = (result as Ok<List<Workshop>>).value;
      expect(workshops.map((w) => w.id), contains('ws_001'));
      expect(workshops.map((w) => w.id), isNot(contains('ws_005')));
    },
  );

  test('getWorkshop returns the matching workshop', () async {
    final result = await repository.getWorkshop('ws_001');
    expect(result, isA<Ok<Workshop>>());
    expect((result as Ok<Workshop>).value.name, 'Bengkel Jaya Motor');
  });

  test('getWorkshop errors for an unknown id', () async {
    final result = await repository.getWorkshop('ws_999');
    expect(result, isA<Error<Workshop>>());
  });

  test(
    'getAvailableSlots returns the exact canonical table for ws_001 on 2026-09-29',
    () async {
      final result = await repository.getAvailableSlots(
        workshopId: 'ws_001',
        date: DateTime(2026, 9, 29),
      );
      expect(result, isA<Ok<List<TimeSlot>>>());
      final slots = (result as Ok<List<TimeSlot>>).value;
      const expectedBooked = [1, 1, 3, 4, 5, 2, 3, 1, 5];
      expect(slots, hasLength(9));
      for (var i = 0; i < slots.length; i++) {
        expect(slots[i].capacity, 5);
        expect(slots[i].booked, expectedBooked[i]);
      }
    },
  );

  test(
    'getAvailableSlots for a non-canonical workshop/date is stable across repeated calls',
    () async {
      final first =
          (await repository.getAvailableSlots(
                workshopId: 'ws_002',
                date: DateTime(2026, 10, 6),
              ))
              as Ok<List<TimeSlot>>;
      final second =
          (await repository.getAvailableSlots(
                workshopId: 'ws_002',
                date: DateTime(2026, 10, 6),
              ))
              as Ok<List<TimeSlot>>;
      expect(
        first.value.map((s) => s.booked).toList(),
        second.value.map((s) => s.booked).toList(),
      );
    },
  );

  test('getAvailableSlots errors for an unknown workshop', () async {
    final result = await repository.getAvailableSlots(
      workshopId: 'ws_999',
      date: DateTime(2026, 9, 29),
    );
    expect(result, isA<Error<List<TimeSlot>>>());
  });

  test(
    'a live confirmed booking increments booked count, cancelling decrements it back',
    () async {
      await localStore.put(SlotOccupancyCalculator.bookingsBox, 'bk_live', {
        'workshop_id': 'ws_001',
        'schedule_mode': 'shared',
        'shared_slot': {
          'date': '2026-09-29T00:00:00.000',
          'hour': 8,
          'capacity': 5,
          'booked': 1,
        },
        'units': [
          {'unit_code': '-A', 'status': 'terjadwal'},
          {'unit_code': '-B', 'status': 'terjadwal'},
        ],
      });

      final withBooking =
          ((await repository.getAvailableSlots(
                    workshopId: 'ws_001',
                    date: DateTime(2026, 9, 29),
                  ))
                  as Ok<List<TimeSlot>>)
              .value;
      expect(withBooking.firstWhere((s) => s.hour == 8).booked, 1 + 2);

      await localStore.put(SlotOccupancyCalculator.bookingsBox, 'bk_live', {
        'workshop_id': 'ws_001',
        'schedule_mode': 'shared',
        'shared_slot': {
          'date': '2026-09-29T00:00:00.000',
          'hour': 8,
          'capacity': 5,
          'booked': 1,
        },
        'units': [
          {'unit_code': '-A', 'status': 'dibatalkan'},
          {'unit_code': '-B', 'status': 'dibatalkan'},
        ],
      });

      final afterCancel =
          ((await repository.getAvailableSlots(
                    workshopId: 'ws_001',
                    date: DateTime(2026, 9, 29),
                  ))
                  as Ok<List<TimeSlot>>)
              .value;
      expect(afterCancel.firstWhere((s) => s.hour == 8).booked, 1);
    },
  );

  test('D+0 cutoff composes correctly from the returned slot', () async {
    clock.setNow(DateTime(2026, 9, 29, 10, 20));
    final result = await repository.getAvailableSlots(
      workshopId: 'ws_001',
      date: DateTime(2026, 9, 29),
    );
    final slots = (result as Ok<List<TimeSlot>>).value;
    const capacityService = SlotCapacityService();

    final slot0800 = slots.firstWhere((s) => s.hour == 8);
    expect(
      capacityService.isPastCutoff(slot: slot0800, now: clock.now()),
      isTrue,
    );

    final slot1500 = slots.firstWhere((s) => s.hour == 15);
    expect(
      capacityService.isPastCutoff(slot: slot1500, now: clock.now()),
      isFalse,
    );
  });
}
