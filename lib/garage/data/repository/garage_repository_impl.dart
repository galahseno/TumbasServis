// ignore_for_file: prefer_initializing_formals
import 'package:tumbas_servis/core/data/service/latency_simulator.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/data/service/mock_json_loader.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor_model.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/repository/garage/garage_repository.dart';

class GarageRepositoryImpl implements GarageRepository {
  GarageRepositoryImpl({
    required LocalStore localStore,
    required MockJsonLoader mockJsonLoader,
    required LatencySimulator latencySimulator,
    required Future<bool> Function(String motorId) hasActiveBooking,
  }) : _localStore = localStore,
       _mockJsonLoader = mockJsonLoader,
       _latencySimulator = latencySimulator,
       _hasActiveBooking = hasActiveBooking;

  final LocalStore _localStore;
  final MockJsonLoader _mockJsonLoader;
  final LatencySimulator _latencySimulator;
  final Future<bool> Function(String motorId) _hasActiveBooking;

  static const _garageBox = 'garage';

  @override
  Future<Result<List<Motor>>> getMotors() async {
    try {
      await _latencySimulator.simulate();
      await _ensureSeeded();
      final rows = await _localStore.getAll(_garageBox);
      return Result.ok(rows.map(_motorFromJson).toList());
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<Motor>> addMotor(Motor motor) async {
    try {
      await _latencySimulator.simulate();
      await _ensureSeeded();
      if (await _hasDuplicatePlate(motor)) {
        return Result.error(
          Exception('A motor with this plate number already exists.'),
        );
      }
      await _localStore.put(_garageBox, motor.id, _motorToJson(motor));
      return Result.ok(motor);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<Motor>> updateMotor(Motor motor) async {
    try {
      await _latencySimulator.simulate();
      await _ensureSeeded();
      if (await _hasDuplicatePlate(motor)) {
        return Result.error(
          Exception('A motor with this plate number already exists.'),
        );
      }
      await _localStore.put(_garageBox, motor.id, _motorToJson(motor));
      return Result.ok(motor);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteMotor(String id) async {
    try {
      await _latencySimulator.simulate();
      if (await _hasActiveBooking(id)) {
        return Result.error(
          Exception('This motor has an active booking and cannot be deleted.'),
        );
      }
      await _localStore.delete(_garageBox, id);
      return const Result.ok(null);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<MotorModel>>> getMotorModels() async {
    try {
      await _latencySimulator.simulate();
      final json =
          await _mockJsonLoader.load('motor_models.json') as List<dynamic>;
      final models = json
          .cast<Map<String, dynamic>>()
          .map(_motorModelFromJson)
          .toList();
      return Result.ok(models);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  Future<bool> _hasDuplicatePlate(Motor motor) async {
    final rows = await _localStore.getAll(_garageBox);
    final normalized = motor.plateNumber.toUpperCase();
    return rows.any(
      (row) =>
          row['id'] != motor.id &&
          (row['plate_number'] as String).toUpperCase() == normalized,
    );
  }

  Future<void>? _seeding;

  Future<void> _ensureSeeded() =>
      _seeding ??= _seedIfEmpty().whenComplete(() => _seeding = null);

  Future<void> _seedIfEmpty() async {
    final existing = await _localStore.getAll(_garageBox);
    if (existing.isNotEmpty) return;
    final json =
        await _mockJsonLoader.load('garage_seed.json') as List<dynamic>;
    for (final row in json.cast<Map<String, dynamic>>()) {
      await _localStore.put(_garageBox, row['id'] as String, row);
    }
  }

  Motor _motorFromJson(Map<String, dynamic> json) => Motor(
    id: json['id'] as String,
    ownerId: json['owner_id'] as String,
    nickname: json['nickname'] as String,
    plateNumber: json['plate_number'] as String,
    year: json['year'] as int?,
    photoUrl: json['photo_url'] as String?,
    modelId: json['model_id'] as String,
  );

  Map<String, dynamic> _motorToJson(Motor motor) => {
    'id': motor.id,
    'owner_id': motor.ownerId,
    'nickname': motor.nickname,
    'plate_number': motor.plateNumber,
    'year': motor.year,
    'photo_url': motor.photoUrl,
    'model_id': motor.modelId,
  };

  MotorModel _motorModelFromJson(Map<String, dynamic> json) => MotorModel(
    id: json['id'] as String,
    brand: MotorBrandX.fromString(json['brand'] as String?),
    name: json['name'] as String,
    category: MotorCategoryX.fromString(json['category'] as String?),
    cc: json['cc'] as int,
  );
}
