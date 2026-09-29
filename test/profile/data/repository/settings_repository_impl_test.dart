import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/repository/settings/app_theme_mode.dart';
import 'package:tumbas_servis/profile/data/repository/settings_repository_impl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late SettingsRepositoryImpl repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tempDir = Directory.systemTemp.createTempSync('settings_repo_test');
    final store = LocalStore(
      preferences: await SharedPreferences.getInstance(),
      resolveStorageDirectory: () async => tempDir.path,
    );
    repository = SettingsRepositoryImpl(localStore: store);
  });

  tearDown(() async {
    await Hive.close();
    tempDir.deleteSync(recursive: true);
  });

  test('getThemeMode defaults to unknown', () async {
    final result = await repository.getThemeMode();
    expect(result, isA<Ok<AppThemeMode>>());
    expect((result as Ok<AppThemeMode>).value, AppThemeMode.unknown);
  });

  test('theme mode round-trips', () async {
    await repository.setThemeMode(AppThemeMode.dark);
    final result = await repository.getThemeMode();
    expect((result as Ok<AppThemeMode>).value, AppThemeMode.dark);
  });

  test('isDemoModeEnabled defaults to false', () async {
    final result = await repository.isDemoModeEnabled();
    expect(result, isA<Ok<bool>>());
    expect((result as Ok<bool>).value, isFalse);
  });

  test('demo mode flag round-trips', () async {
    await repository.setDemoMode(true);
    final enabled = await repository.isDemoModeEnabled();
    expect((enabled as Ok<bool>).value, isTrue);

    await repository.setDemoMode(false);
    final disabled = await repository.isDemoModeEnabled();
    expect((disabled as Ok<bool>).value, isFalse);
  });

  test('notifications default to enabled and the flag round-trips', () async {
    final initial = await repository.isNotificationsEnabled();
    expect((initial as Ok<bool>).value, isTrue);

    await repository.setNotificationsEnabled(false);
    final off = await repository.isNotificationsEnabled();
    expect((off as Ok<bool>).value, isFalse);

    await repository.setNotificationsEnabled(true);
    final on = await repository.isNotificationsEnabled();
    expect((on as Ok<bool>).value, isTrue);
  });
}
