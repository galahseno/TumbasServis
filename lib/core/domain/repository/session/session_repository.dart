import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/user/user.dart';

abstract class SessionRepository {
  Future<Result<void>> login(String phone);
  Future<Result<User>> verifyOtp(String code);
  Future<Result<void>> logout();
  Future<Result<User?>> currentUser();
}
