import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/domain/repository/settings/app_theme_mode.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late LocalStore store;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tempDir = Directory.systemTemp.createTempSync('local_store_test');
    store = LocalStore(
      preferences: await SharedPreferences.getInstance(),
      resolveStorageDirectory: () async => tempDir.path,
    );
  });

  tearDown(() async {
    await Hive.close();
    tempDir.deleteSync(recursive: true);
  });

  test('session flag round-trips, defaults to false', () async {
    expect(store.getSessionFlag(), isFalse);
    await store.setSessionFlag(true);
    expect(store.getSessionFlag(), isTrue);
  });

  test('theme mode round-trips, defaults to unknown', () async {
    expect(store.getThemeMode(), AppThemeMode.unknown);
    await store.setThemeMode(AppThemeMode.dark);
    expect(store.getThemeMode(), AppThemeMode.dark);
  });

  test('demo mode flag round-trips, defaults to false', () async {
    expect(store.getDemoModeEnabled(), isFalse);
    await store.setDemoModeEnabled(true);
    expect(store.getDemoModeEnabled(), isTrue);
  });

  test('structured store: put/get/getAll/delete/clear round-trip', () async {
    await store.put('garage', 'motor_1', {
      'id': 'motor_1',
      'nickname': 'Si Merah',
    });
    await store.put('garage', 'motor_2', {
      'id': 'motor_2',
      'nickname': 'Si Hitam',
    });

    expect(await store.get('garage', 'motor_1'), {
      'id': 'motor_1',
      'nickname': 'Si Merah',
    });
    expect((await store.getAll('garage')), hasLength(2));

    await store.delete('garage', 'motor_1');
    expect(await store.get('garage', 'motor_1'), isNull);
    expect((await store.getAll('garage')), hasLength(1));

    await store.clear('garage');
    expect((await store.getAll('garage')), isEmpty);
  });
}
