import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/user/user.dart';
import 'package:tumbas_servis/core/domain/repository/session/session_repository.dart';

class FakeSessionRepository implements SessionRepository {
  Result<User?> currentUserResult = const Result.ok(null);
  Result<void> loginResult = const Result.ok(null);
  Result<User> Function(String code)? verifyOtpResult;
  String? lastLoginPhone;
  String? lastVerifiedCode;
  int logoutCalls = 0;

  @override
  Future<Result<User?>> currentUser() async => currentUserResult;

  @override
  Future<Result<void>> login(String phone) async {
    lastLoginPhone = phone;
    return loginResult;
  }

  @override
  Future<Result<User>> verifyOtp(String code) async {
    lastVerifiedCode = code;
    final resolver = verifyOtpResult;
    if (resolver == null) throw UnimplementedError();
    return resolver(code);
  }

  @override
  Future<Result<void>> logout() async {
    logoutCalls++;
    return const Result.ok(null);
  }
}
