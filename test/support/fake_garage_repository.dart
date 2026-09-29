import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor_model.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/repository/garage/garage_repository.dart';

class FakeGarageRepository implements GarageRepository {
  Result<List<Motor>> motorsResult = const Result.ok([]);
  Result<List<MotorModel>> motorModelsResult = const Result.ok([]);

  Result<Motor>? addMotorResult;
  Result<Motor>? updateMotorResult;
  Result<void> deleteMotorResult = const Result.ok(null);

  Motor? lastAddedMotor;
  Motor? lastUpdatedMotor;
  String? lastDeletedMotorId;

  @override
  Future<Result<List<Motor>>> getMotors() async => motorsResult;

  @override
  Future<Result<Motor>> addMotor(Motor motor) async {
    lastAddedMotor = motor;
    return addMotorResult ?? Result.ok(motor);
  }

  @override
  Future<Result<Motor>> updateMotor(Motor motor) async {
    lastUpdatedMotor = motor;
    return updateMotorResult ?? Result.ok(motor);
  }

  @override
  Future<Result<void>> deleteMotor(String id) async {
    lastDeletedMotorId = id;
    return deleteMotorResult;
  }

  @override
  Future<Result<List<MotorModel>>> getMotorModels() async => motorModelsResult;
}
