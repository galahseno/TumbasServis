import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor_model.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/repository/garage/garage_repository.dart';

class FakeGarageRepository implements GarageRepository {
  Result<List<Motor>> motorsResult = const Result.ok([]);

  @override
  Future<Result<List<Motor>>> getMotors() async => motorsResult;

  @override
  Future<Result<Motor>> addMotor(Motor motor) async => Result.ok(motor);

  @override
  Future<Result<Motor>> updateMotor(Motor motor) async => Result.ok(motor);

  @override
  Future<Result<void>> deleteMotor(String id) async => const Result.ok(null);

  @override
  Future<Result<List<MotorModel>>> getMotorModels() async =>
      const Result.ok([]);
}
