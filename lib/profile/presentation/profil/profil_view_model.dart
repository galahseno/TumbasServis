import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/auth/data/di/auth_data_module.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/user/user.dart';
import 'package:tumbas_servis/core/domain/repository/settings/app_theme_mode.dart';
import 'package:tumbas_servis/core/presentation/di/core_presentation_module.dart';
import 'package:tumbas_servis/core/presentation/utils/phone_formatter.dart';
import 'package:tumbas_servis/profile/data/di/profile_data_module.dart';
import 'package:tumbas_servis/profile/presentation/profil/state/profil_state.dart';

class ProfilViewModel extends Notifier<ProfilState> {
  @override
  ProfilState build() {
    _load();
    return const ProfilState();
  }

  Future<void> _load() async {
    final userResult = await ref.read(sessionRepositoryProvider).currentUser();
    final notificationsResult = await ref
        .read(settingsRepositoryProvider)
        .isNotificationsEnabled();
    if (!ref.mounted) return;
    final user = userResult is Ok<User?> ? userResult.value : null;
    state = state.copyWith(
      isLoading: false,
      userName: user?.name ?? '',
      maskedPhone: user == null ? '' : maskUserPhone(user.phone),
      notificationsEnabled: notificationsResult is Ok<bool>
          ? notificationsResult.value
          : true,
    );
  }

  static String maskUserPhone(String phone) {
    final national = normalizePhoneDigits(
      phone.replaceFirst(RegExp(r'^\s*\+?62'), ''),
    );
    return '+62 ${maskPhoneDisplay(national)}';
  }

  Future<void> setThemeMode(AppThemeMode mode) =>
      ref.read(themeModeProvider.notifier).setThemeMode(mode);

  Future<void> setNotificationsEnabled(bool enabled) async {
    final previous = state.notificationsEnabled;
    state = state.copyWith(notificationsEnabled: enabled);
    final result = await ref
        .read(settingsRepositoryProvider)
        .setNotificationsEnabled(enabled);
    if (!ref.mounted) return;
    if (result is! Ok<void>) {
      state = state.copyWith(notificationsEnabled: previous);
    }
  }

  Future<void> logout() async {
    if (state.isLoggingOut) return;
    state = state.copyWith(isLoggingOut: true);
    await ref.read(logoutHandlerProvider).call();
    if (ref.mounted) state = state.copyWith(isLoggingOut: false);
  }
}
