import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/app/navigation/router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/auth/data/di/auth_data_module.dart';
import 'package:tumbas_servis/auth/presentation/login/state/login_state.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';

const invalidPhoneError = 'Nomor tidak valid. Contoh: 812-3456-7890';
const loginNetworkErrorMessage =
    'Gagal mengirim kode. Cek koneksi, lalu coba lagi.';

class LoginViewModel extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  bool _isValid(String digits) => digits.length >= 9 && digits.length <= 12;

  void updatePhone(String digits) =>
      state = state.copyWith(phoneDigits: digits, errorText: null);

  void validateOnBlur() {
    if (state.phoneDigits.isEmpty) return;
    if (!_isValid(state.phoneDigits)) {
      state = state.copyWith(errorText: invalidPhoneError);
    }
  }

  Future<void> submit() async {
    if (!_isValid(state.phoneDigits)) {
      state = state.copyWith(errorText: invalidPhoneError);
      return;
    }
    state = state.copyWith(isLoading: true, errorText: null);
    final result = await ref
        .read(sessionRepositoryProvider)
        .login('+62${state.phoneDigits}');
    switch (result) {
      case Ok():
        state = state.copyWith(isLoading: false);
        ref.read(routerProvider).push(Routes.otp, extra: state.phoneDigits);
      case Error():
        state = state.copyWith(
          isLoading: false,
          snackbarMessage: loginNetworkErrorMessage,
        );
    }
  }

  void clearSnackbar() => state = state.copyWith(snackbarMessage: null);
}
