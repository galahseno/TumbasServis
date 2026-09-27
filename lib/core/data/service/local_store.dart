// ignore_for_file: prefer_initializing_formals
import 'dart:convert';

import 'package:hive_ce/hive_ce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbas_servis/core/domain/repository/settings/app_theme_mode.dart';

typedef StorageDirectoryResolver = Future<String> Function();

class LocalStore {
  LocalStore({
    required SharedPreferences preferences,
    required StorageDirectoryResolver resolveStorageDirectory,
  }) : _preferences = preferences,
       _resolveStorageDirectory = resolveStorageDirectory;

  final SharedPreferences _preferences;
  final StorageDirectoryResolver _resolveStorageDirectory;

  bool _hiveInitialized = false;
  final Map<String, Box<String>> _openBoxes = {};

  static const _sessionActiveKey = 'local_store.session_active';
  static const _themeModeKey = 'local_store.theme_mode';
  static const _demoModeEnabledKey = 'local_store.demo_mode_enabled';

  // -- Simple flags (shared_preferences) --

  bool getSessionFlag() => _preferences.getBool(_sessionActiveKey) ?? false;

  Future<void> setSessionFlag(bool value) =>
      _preferences.setBool(_sessionActiveKey, value);

  AppThemeMode getThemeMode() =>
      AppThemeModeX.fromString(_preferences.getString(_themeModeKey));

  Future<void> setThemeMode(AppThemeMode mode) =>
      _preferences.setString(_themeModeKey, mode.name);

  bool getDemoModeEnabled() =>
      _preferences.getBool(_demoModeEnabledKey) ?? false;

  Future<void> setDemoModeEnabled(bool value) =>
      _preferences.setBool(_demoModeEnabledKey, value);

  // -- Structured store (hive_ce) --

  Future<Box<String>> _box(String boxName) async {
    final existing = _openBoxes[boxName];
    if (existing != null) return existing;
    if (!_hiveInitialized) {
      Hive.init(await _resolveStorageDirectory());
      _hiveInitialized = true;
    }
    final box = await Hive.openBox<String>(boxName);
    _openBoxes[boxName] = box;
    return box;
  }

  Future<Map<String, dynamic>?> get(String boxName, String key) async {
    final box = await _box(boxName);
    final raw = box.get(key);
    if (raw == null) return null;
    return json.decode(raw) as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getAll(String boxName) async {
    final box = await _box(boxName);
    return box.values
        .map((raw) => json.decode(raw) as Map<String, dynamic>)
        .toList();
  }

  Future<void> put(
    String boxName,
    String key,
    Map<String, dynamic> value,
  ) async {
    final box = await _box(boxName);
    await box.put(key, json.encode(value));
  }

  Future<void> delete(String boxName, String key) async {
    final box = await _box(boxName);
    await box.delete(key);
  }

  Future<void> clear(String boxName) async {
    final box = await _box(boxName);
    await box.clear();
  }
}
