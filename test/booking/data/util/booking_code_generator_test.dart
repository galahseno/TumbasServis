import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbas_servis/booking/data/util/booking_code_generator.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/data/service/mock_json_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late LocalStore localStore;
  late BookingCodeGenerator generator;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tempDir = Directory.systemTemp.createTempSync('booking_code_test');
    localStore = LocalStore(
      preferences: await SharedPreferences.getInstance(),
      resolveStorageDirectory: () async => tempDir.path,
    );
    generator = BookingCodeGenerator(
      localStore: localStore,
      mockJsonLoader: MockJsonLoader(),
    );
  });

  tearDown(() async {
    await Hive.close();
    tempDir.deleteSync(recursive: true);
  });

  test('first code on seeded date continues from seed hack', () async {
    final code = await generator.next(DateTime(2026, 9, 29));
    expect(code, 'TS-260929-0417');
  });

  test('subsequent codes increment', () async {
    await generator.next(DateTime(2026, 9, 29));
    expect(await generator.next(DateTime(2026, 9, 29)), 'TS-260929-0418');
  });

  test('fresh date starts at 0001', () async {
    final code = await generator.next(DateTime(2026, 10, 2));
    expect(code, 'TS-261002-0001');
  });

  test('single-digit month and day zero-padded', () async {
    final code = await generator.next(DateTime(2027, 1, 5));
    expect(code, startsWith('TS-270105-'));
  });
}
