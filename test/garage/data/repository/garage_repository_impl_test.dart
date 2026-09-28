import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/data/service/mock_json_loader.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/garage/data/repository/garage_repository_impl.dart';

import '../../../support/fake_latency_simulator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late GarageRepositoryImpl repository;
  var activeBookingMotorIds = <String>{};

  GarageRepositoryImpl buildRepository(LocalStore store) =>
      GarageRepositoryImpl(
        localStore: store,
        mockJsonLoader: MockJsonLoader(),
        latencySimulator: FakeLatencySimulator(),
        hasActiveBooking: (id) async => activeBookingMotorIds.contains(id),
      );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tempDir = Directory.systemTemp.createTempSync('garage_repo_test');
    activeBookingMotorIds = {};
    final store = LocalStore(
      preferences: await SharedPreferences.getInstance(),
      resolveStorageDirectory: () async => tempDir.path,
    );
    repository = buildRepository(store);
  });

  tearDown(() async {
    await Hive.close();
    tempDir.deleteSync(recursive: true);
  });

  test('getMotors seeds from garage_seed.json on first read', () async {
    final result = await repository.getMotors();
    expect(result, isA<Ok<List<Motor>>>());
    final motors = (result as Ok<List<Motor>>).value;
    expect(motors, hasLength(7));
    expect(motors.map((m) => m.id), contains('motor_001'));
  });

  test('addMotor persists a new motor', () async {
    await repository.getMotors();
    const newMotor = Motor(
      id: 'motor_new',
      ownerId: 'user_001',
      nickname: 'Aerox 155',
      plateNumber: 'AB 7777 NN',
      modelId: 'model_aerox155',
    );

    final result = await repository.addMotor(newMotor);
    expect(result, isA<Ok<Motor>>());

    final motors = (await repository.getMotors() as Ok<List<Motor>>).value;
    expect(motors, hasLength(8));
    expect(motors.map((m) => m.id), contains('motor_new'));
  });

  test('addMotor rejects a duplicate plate number', () async {
    await repository.getMotors();
    const duplicate = Motor(
      id: 'motor_new',
      ownerId: 'user_001',
      nickname: 'Aerox 155',
      plateNumber: 'ab 1234 xy',
      modelId: 'model_aerox155',
    );

    final result = await repository.addMotor(duplicate);
    expect(result, isA<Error<Motor>>());
  });

  test('updateMotor updates an existing motor in place', () async {
    await repository.getMotors();
    const updated = Motor(
      id: 'motor_001',
      ownerId: 'user_001',
      nickname: 'Vario 125 (updated)',
      plateNumber: 'AB 1234 XY',
      modelId: 'model_vario125',
    );

    final result = await repository.updateMotor(updated);
    expect(result, isA<Ok<Motor>>());

    final motors = (await repository.getMotors() as Ok<List<Motor>>).value;
    expect(motors, hasLength(7));
    expect(
      motors.firstWhere((m) => m.id == 'motor_001').nickname,
      'Vario 125 (updated)',
    );
  });

  test(
    'updateMotor rejects a plate number already used by another motor',
    () async {
      await repository.getMotors();
      const updated = Motor(
        id: 'motor_002',
        ownerId: 'user_001',
        nickname: 'Beat 110',
        plateNumber: 'AB 1234 XY',
        modelId: 'model_beat110',
      );

      final result = await repository.updateMotor(updated);
      expect(result, isA<Error<Motor>>());
    },
  );

  test(
    'deleteMotor removes the motor when there is no active booking',
    () async {
      await repository.getMotors();
      final result = await repository.deleteMotor('motor_001');
      expect(result, isA<Ok<void>>());

      final motors = (await repository.getMotors() as Ok<List<Motor>>).value;
      expect(motors.map((m) => m.id), isNot(contains('motor_001')));
    },
  );

  test(
    'deleteMotor is blocked while the motor has an active booking',
    () async {
      await repository.getMotors();
      activeBookingMotorIds = {'motor_001'};

      final result = await repository.deleteMotor('motor_001');
      expect(result, isA<Error<void>>());

      final motors = (await repository.getMotors() as Ok<List<Motor>>).value;
      expect(motors.map((m) => m.id), contains('motor_001'));
    },
  );

  test('getMotorModels returns the full catalog of models', () async {
    final result = await repository.getMotorModels();
    expect(result, isA<Ok<List<dynamic>>>());
    final models = (result as Ok).value;
    expect(models, hasLength(16));
  });
}
