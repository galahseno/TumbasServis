import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/data/service/slot_occupancy_calculator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const calculator = SlotOccupancyCalculator();
  late Directory tempDir;
  late LocalStore localStore;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tempDir = Directory.systemTemp.createTempSync('slot_occupancy_test');
    localStore = LocalStore(
      preferences: await SharedPreferences.getInstance(),
      resolveStorageDirectory: () async => tempDir.path,
    );
  });

  tearDown(() async {
    await Hive.close();
    tempDir.deleteSync(recursive: true);
  });

  group('baselineBooked', () {
    test('returns the exact canonical table for ws_001 on 2026-09-29', () {
      const expected = {
        8: 1,
        9: 1,
        10: 3,
        11: 4,
        12: 5,
        13: 2,
        14: 3,
        15: 1,
        16: 5,
      };
      for (final entry in expected.entries) {
        expect(
          calculator.baselineBooked(
            workshopId: 'ws_001',
            date: DateTime(2026, 9, 29),
            hour: entry.key,
          ),
          entry.value,
        );
      }
    });

    test('is deterministic and within [0, capacity] for other dates', () {
      final first = calculator.baselineBooked(
        workshopId: 'ws_002',
        date: DateTime(2026, 10, 6),
        hour: 10,
      );
      final second = calculator.baselineBooked(
        workshopId: 'ws_002',
        date: DateTime(2026, 10, 6),
        hour: 10,
      );
      expect(first, second);
      expect(first, inInclusiveRange(0, 5));
    });

    test(
      'same workshop on the canonical date but a different hour differs from the table default',
      () {
        final value = calculator.baselineBooked(
          workshopId: 'ws_002',
          date: DateTime(2026, 9, 29),
          hour: 8,
        );
        expect(value, inInclusiveRange(0, 5));
      },
    );
  });

  group('overlayBooked', () {
    test('counts active shared-mode units at the matching slot', () async {
      await localStore.put(SlotOccupancyCalculator.bookingsBox, 'bk_1', {
        'workshop_id': 'ws_001',
        'schedule_mode': 'shared',
        'shared_slot': {
          'date': '2026-09-29T00:00:00.000',
          'hour': 9,
          'capacity': 5,
          'booked': 1,
        },
        'units': [
          {'unit_code': '-A', 'status': 'terjadwal'},
          {'unit_code': '-B', 'status': 'terjadwal'},
        ],
      });

      final count = await calculator.overlayBooked(
        localStore: localStore,
        workshopId: 'ws_001',
        date: DateTime(2026, 9, 29),
        hour: 9,
      );

      expect(count, 2);
    });

    test('excludes dibatalkan units', () async {
      await localStore.put(SlotOccupancyCalculator.bookingsBox, 'bk_1', {
        'workshop_id': 'ws_001',
        'schedule_mode': 'shared',
        'shared_slot': {
          'date': '2026-09-29T00:00:00.000',
          'hour': 9,
          'capacity': 5,
          'booked': 1,
        },
        'units': [
          {'unit_code': '-A', 'status': 'dibatalkan'},
          {'unit_code': '-B', 'status': 'terjadwal'},
        ],
      });

      final count = await calculator.overlayBooked(
        localStore: localStore,
        workshopId: 'ws_001',
        date: DateTime(2026, 9, 29),
        hour: 9,
      );

      expect(count, 1);
    });

    test('counts split-mode units by their own unit_slots entry', () async {
      await localStore.put(SlotOccupancyCalculator.bookingsBox, 'bk_1', {
        'workshop_id': 'ws_001',
        'schedule_mode': 'split',
        'unit_slots': {
          '-A': {
            'date': '2026-09-29T00:00:00.000',
            'hour': 9,
            'capacity': 5,
            'booked': 1,
          },
          '-B': {
            'date': '2026-09-29T00:00:00.000',
            'hour': 10,
            'capacity': 5,
            'booked': 3,
          },
        },
        'units': [
          {'unit_code': '-A', 'status': 'terjadwal'},
          {'unit_code': '-B', 'status': 'terjadwal'},
        ],
      });

      final countAt9 = await calculator.overlayBooked(
        localStore: localStore,
        workshopId: 'ws_001',
        date: DateTime(2026, 9, 29),
        hour: 9,
      );
      final countAt10 = await calculator.overlayBooked(
        localStore: localStore,
        workshopId: 'ws_001',
        date: DateTime(2026, 9, 29),
        hour: 10,
      );

      expect(countAt9, 1);
      expect(countAt10, 1);
    });

    test('ignores bookings for a different workshop', () async {
      await localStore.put(SlotOccupancyCalculator.bookingsBox, 'bk_1', {
        'workshop_id': 'ws_002',
        'schedule_mode': 'shared',
        'shared_slot': {
          'date': '2026-09-29T00:00:00.000',
          'hour': 9,
          'capacity': 5,
          'booked': 1,
        },
        'units': [
          {'unit_code': '-A', 'status': 'terjadwal'},
        ],
      });

      final count = await calculator.overlayBooked(
        localStore: localStore,
        workshopId: 'ws_001',
        date: DateTime(2026, 9, 29),
        hour: 9,
      );

      expect(count, 0);
    });
  });

  group('bookedCount', () {
    test('sums the canonical baseline with the live overlay', () async {
      await localStore.put(SlotOccupancyCalculator.bookingsBox, 'bk_1', {
        'workshop_id': 'ws_001',
        'schedule_mode': 'shared',
        'shared_slot': {
          'date': '2026-09-29T00:00:00.000',
          'hour': 9,
          'capacity': 5,
          'booked': 1,
        },
        'units': [
          {'unit_code': '-A', 'status': 'terjadwal'},
          {'unit_code': '-B', 'status': 'terjadwal'},
          {'unit_code': '-C', 'status': 'terjadwal'},
        ],
      });

      final count = await calculator.bookedCount(
        localStore: localStore,
        workshopId: 'ws_001',
        date: DateTime(2026, 9, 29),
        hour: 9,
      );

      expect(count, 1 + 3);
    });
  });
}
