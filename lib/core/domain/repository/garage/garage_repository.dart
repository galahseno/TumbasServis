import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor_model.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';

abstract class GarageRepository {
  Future<Result<List<Motor>>> getMotors();
  Future<Result<Motor>> addMotor(Motor motor);
  Future<Result<Motor>> updateMotor(Motor motor);
  Future<Result<void>> deleteMotor(String id);
  Future<Result<List<MotorModel>>> getMotorModels();
}
