import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbas_servis/auth/data/repository/session_repository_impl.dart';
import 'package:tumbas_servis/core/data/service/demo_mode_controller.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/data/service/mock_json_loader.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/user/user.dart';

import '../../../support/fake_latency_simulator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const seededUser = User(
    id: 'user_001',
    name: 'Galah',
    phone: '+62 812-3456-7890',
  );

  late Directory tempDir;
  late LocalStore store;
  late DemoModeController demoModeController;
  late SessionRepositoryImpl repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tempDir = Directory.systemTemp.createTempSync('session_repo_test');
    store = LocalStore(
      preferences: await SharedPreferences.getInstance(),
      resolveStorageDirectory: () async => tempDir.path,
    );
    demoModeController = DemoModeController();
    repository = SessionRepositoryImpl(
      localStore: store,
      mockJsonLoader: MockJsonLoader(),
      latencySimulator: FakeLatencySimulator(),
      demoModeController: demoModeController,
    );
  });

  tearDown(() async {
    await Hive.close();
    tempDir.deleteSync(recursive: true);
  });

  test('login always succeeds', () async {
    final result = await repository.login('081234567890');
    expect(result, isA<Ok<void>>());
  });

  test('verifyOtp with correct code returns the seeded user', () async {
    final result = await repository.verifyOtp('123456');
    expect(result, isA<Ok<User>>());
    expect((result as Ok<User>).value, seededUser);
  });

  test(
    'verifyOtp with wrong code errors and does not persist a session',
    () async {
      final result = await repository.verifyOtp('000000');
      expect(result, isA<Error<User>>());

      final current = await repository.currentUser();
      expect(current, isA<Ok<User?>>());
      expect((current as Ok<User?>).value, isNull);
    },
  );

  test(
    'currentUser reflects the session after a successful verifyOtp',
    () async {
      await repository.verifyOtp('123456');

      final result = await repository.currentUser();
      expect(result, isA<Ok<User?>>());
      expect((result as Ok<User?>).value, seededUser);
    },
  );

  test('currentUser is null before any login', () async {
    final result = await repository.currentUser();
    expect(result, isA<Ok<User?>>());
    expect((result as Ok<User?>).value, isNull);
  });

  test('session survives a fresh LocalStore instance (restart)', () async {
    await repository.verifyOtp('123456');

    // Simulate an app restart: close Hive so a new LocalStore can reopen
    // the same on-disk box, and read the same in-memory SharedPreferences.
    await Hive.close();
    final restartedStore = LocalStore(
      preferences: await SharedPreferences.getInstance(),
      resolveStorageDirectory: () async => tempDir.path,
    );
    final restartedRepository = SessionRepositoryImpl(
      localStore: restartedStore,
      mockJsonLoader: MockJsonLoader(),
      latencySimulator: FakeLatencySimulator(),
      demoModeController: DemoModeController(),
    );

    final result = await restartedRepository.currentUser();
    expect(result, isA<Ok<User?>>());
    expect((result as Ok<User?>).value, seededUser);
  });

  test('logout clears the session flag and cached user', () async {
    await repository.verifyOtp('123456');

    final logoutResult = await repository.logout();
    expect(logoutResult, isA<Ok<void>>());

    final current = await repository.currentUser();
    expect((current as Ok<User?>).value, isNull);
    expect(await store.get('session', 'user'), isNull);
    expect(store.getSessionFlag(), isFalse);
  });

  test('logout while already logged out does not throw', () async {
    final result = await repository.logout();
    expect(result, isA<Ok<void>>());
  });

  test('login errors once when a network error is armed', () async {
    demoModeController.armNextWriteError();

    final armedResult = await repository.login('081234567890');
    expect(armedResult, isA<Error<void>>());

    final nextResult = await repository.login('081234567890');
    expect(nextResult, isA<Ok<void>>());
  });
}
