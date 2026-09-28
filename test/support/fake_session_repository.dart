import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/user/user.dart';
import 'package:tumbas_servis/core/domain/repository/session/session_repository.dart';

class FakeSessionRepository implements SessionRepository {
  Result<User?> currentUserResult = const Result.ok(null);

  @override
  Future<Result<User?>> currentUser() async => currentUserResult;

  @override
  Future<Result<void>> login(String phone) async => const Result.ok(null);

  @override
  Future<Result<User>> verifyOtp(String code) async =>
      throw UnimplementedError();

  @override
  Future<Result<void>> logout() async => const Result.ok(null);
}
