import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/data/service/tracking_status_writer.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';

import '../../../support/fake_clock.dart';
import '../../../support/tracking_store_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const writer = TrackingStatusWriter();
  late Directory tempDir;
  late LocalStore store;
  late FakeClock clock;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tempDir = Directory.systemTemp.createTempSync('tracking_writer_test');
    store = LocalStore(
      preferences: await SharedPreferences.getInstance(),
      resolveStorageDirectory: () async => tempDir.path,
    );
    clock = FakeClock(DateTime(2026, 9, 29, 9, 30));
    await store.put(
      'bookings',
      'bk',
      rawBooking('bk', [
        rawUnit('-A', 'terjadwal'),
        rawUnit('-B', 'terjadwal'),
        rawUnit('-C', 'terjadwal', motorId: 'motor_003'),
      ]),
    );
  });

  tearDown(() async {
    await Hive.close();
    tempDir.deleteSync(recursive: true);
  });

  Future<Map<String, dynamic>> unit(String code) async {
    final row = await store.get('bookings', 'bk');
    final units = (row!['units'] as List<dynamic>).cast<Map<String, dynamic>>();
    return units.firstWhere((u) => u['unit_code'] == code);
  }

  Future<void> advance(String code, UnitStatus status) => writer.writeAdvance(
    localStore: store,
    clock: clock,
    bookingId: 'bk',
    unitCode: code,
    status: status,
  );

  test('persists status + history and re-derives the booking status', () async {
    await advance('-A', UnitStatus.checkIn);

    final a = await unit('-A');
    expect(a['status'], 'checkIn');
    expect(a['status_history'], hasLength(2));
    expect((await store.get('bookings', 'bk'))!['status'], 'berlangsung');
  });

  test('assigns a mechanic once when a unit first leaves Terjadwal '
      '(A/C → mech_002, B → mech_001)', () async {
    await advance('-A', UnitStatus.checkIn);
    await advance('-B', UnitStatus.checkIn);
    await advance('-C', UnitStatus.checkIn);

    expect((await unit('-A'))['mechanic_id'], 'mech_002');
    expect((await unit('-B'))['mechanic_id'], 'mech_001');
    expect((await unit('-C'))['mechanic_id'], 'mech_002');
  });

  test('never overwrites an existing mechanic', () async {
    await store.put(
      'bookings',
      'bk',
      rawBooking('bk', [rawUnit('-A', 'terjadwal', mechanicId: 'mech_005')]),
    );
    await advance('-A', UnitStatus.checkIn);
    expect((await unit('-A'))['mechanic_id'], 'mech_005');
  });

  test('is idempotent: repeating a status adds no history row', () async {
    await advance('-A', UnitStatus.checkIn);
    await advance('-A', UnitStatus.checkIn);

    expect((await unit('-A'))['status_history'], hasLength(2));
  });

  test('ignores writes once the stored unit is terminal', () async {
    await advance('-A', UnitStatus.selesai);
    await advance('-A', UnitStatus.qc);

    expect((await unit('-A'))['status'], 'selesai');
  });

  test('reset restores Terjadwal with one history row and keeps the '
      'mechanic; a second reset is a no-op', () async {
    await advance('-A', UnitStatus.checkIn);
    await writer.writeReset(
      localStore: store,
      clock: clock,
      bookingId: 'bk',
      unitCode: '-A',
    );

    final a = await unit('-A');
    expect(a['status'], 'terjadwal');
    expect(a['status_history'], hasLength(1));
    expect(a['mechanic_id'], 'mech_002');

    clock.setNow(DateTime(2026, 9, 29, 11));
    await writer.writeReset(
      localStore: store,
      clock: clock,
      bookingId: 'bk',
      unitCode: '-A',
    );
    final again = await unit('-A');
    expect(
      (again['status_history'] as List).single['timestamp'],
      DateTime(2026, 9, 29, 9, 30).toIso8601String(),
    );
  });

  test('concurrent writes for different units all land (serialized '
      'read-modify-write)', () async {
    await Future.wait([
      advance('-A', UnitStatus.checkIn),
      advance('-B', UnitStatus.checkIn),
      advance('-C', UnitStatus.checkIn),
    ]);

    expect((await unit('-A'))['status'], 'checkIn');
    expect((await unit('-B'))['status'], 'checkIn');
    expect((await unit('-C'))['status'], 'checkIn');
  });
}
