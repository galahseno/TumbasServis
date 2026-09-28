import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/app/navigation/router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/auth/data/di/auth_data_module.dart';
import 'package:tumbas_servis/auth/presentation/otp/state/otp_state.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';

const wrongOtpError = 'Kode salah. Cek lagi 6 digitnya atau kirim ulang kode.';
const otpDigitCount = 6;
const otpResendSeconds = 30;

typedef OtpTimerFactory = Timer Function(Duration duration, void Function());

Timer _defaultOtpTimerFactory(Duration duration, void Function() callback) =>
    Timer(duration, callback);

class OtpViewModel extends Notifier<OtpState> {
  OtpViewModel({this._timerFactory = _defaultOtpTimerFactory});

  final OtpTimerFactory _timerFactory;
  Timer? _countdownTimer;

  @override
  OtpState build() {
    ref.onDispose(() => _countdownTimer?.cancel());
    _scheduleTick();
    return const OtpState();
  }

  void setPhone(String phoneDigits) =>
      state = state.copyWith(phoneDigits: phoneDigits);

  void updateCode(String code) =>
      state = state.copyWith(code: code, isError: false);

  void _startCountdown() {
    _countdownTimer?.cancel();
    state = state.copyWith(secondsRemaining: otpResendSeconds);
    _scheduleTick();
  }

  void _scheduleTick() {
    _countdownTimer = _timerFactory(const Duration(seconds: 1), () {
      if (!ref.mounted) return;
      if (state.secondsRemaining <= 1) {
        state = state.copyWith(secondsRemaining: 0);
        return;
      }
      state = state.copyWith(secondsRemaining: state.secondsRemaining - 1);
      _scheduleTick();
    });
  }

  Future<void> verify() async {
    if (state.code.length < otpDigitCount || state.isLoading) return;
    state = state.copyWith(isLoading: true, isError: false);
    final result = await ref
        .read(sessionRepositoryProvider)
        .verifyOtp(state.code);
    switch (result) {
      case Ok():
        state = state.copyWith(isLoading: false);
        ref.read(routerProvider).go(Routes.home);
      case Error():
        state = state.copyWith(isLoading: false, isError: true, code: '');
    }
  }

  Future<void> resend() async {
    if (state.secondsRemaining > 0) return;
    await ref.read(sessionRepositoryProvider).login(state.phoneDigits);
    _startCountdown();
  }
}
