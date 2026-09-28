// ignore_for_file: prefer_initializing_formals
import 'package:tumbas_servis/core/data/service/latency_simulator.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/data/service/mock_json_loader.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/user/user.dart';
import 'package:tumbas_servis/core/domain/repository/session/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  SessionRepositoryImpl({
    required LocalStore localStore,
    required MockJsonLoader mockJsonLoader,
    required LatencySimulator latencySimulator,
  }) : _localStore = localStore,
       _mockJsonLoader = mockJsonLoader,
       _latencySimulator = latencySimulator;

  final LocalStore _localStore;
  final MockJsonLoader _mockJsonLoader;
  final LatencySimulator _latencySimulator;

  static const _sessionBox = 'session';
  static const _userKey = 'user';
  static const _correctOtp = '123456';

  @override
  Future<Result<void>> login(String phone) async {
    try {
      await _latencySimulator.simulate();
      return const Result.ok(null);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<User>> verifyOtp(String code) async {
    try {
      await _latencySimulator.simulate();
      if (code != _correctOtp) {
        return Result.error(Exception('Invalid OTP code.'));
      }
      final json =
          await _mockJsonLoader.load('user.json') as Map<String, dynamic>;
      final user = _userFromJson(json);
      await _localStore.setSessionFlag(true);
      await _localStore.put(_sessionBox, _userKey, _userToJson(user));
      return Result.ok(user);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _localStore.setSessionFlag(false);
      await _localStore.delete(_sessionBox, _userKey);
      return const Result.ok(null);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<User?>> currentUser() async {
    try {
      if (!_localStore.getSessionFlag()) return const Result.ok(null);
      final json = await _localStore.get(_sessionBox, _userKey);
      if (json == null) return const Result.ok(null);
      return Result.ok(_userFromJson(json));
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  Map<String, dynamic> _userToJson(User user) => {
    'id': user.id,
    'name': user.name,
    'phone': user.phone,
    'avatarUrl': user.avatarUrl,
  };

  User _userFromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String,
    name: json['name'] as String,
    phone: json['phone'] as String,
    avatarUrl: json['avatarUrl'] as String?,
  );
}
