import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/auth/data/di/auth_data_module.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/user/user.dart';
import 'package:tumbas_servis/core/domain/repository/settings/app_theme_mode.dart';
import 'package:tumbas_servis/core/presentation/di/core_presentation_module.dart';
import 'package:tumbas_servis/profile/data/di/profile_data_module.dart';
import 'package:tumbas_servis/profile/presentation/di/profile_presentation_module.dart';
import 'package:tumbas_servis/profile/presentation/profil/profil_view_model.dart';
import 'package:tumbas_servis/profile/presentation/profil/state/profil_state.dart';

import '../../../support/fake_logout_handler.dart';
import '../../../support/fake_session_repository.dart';
import '../../../support/fake_settings_repository.dart';

void main() {
  late FakeSessionRepository sessionRepository;
  late FakeSettingsRepository settingsRepository;
  late FakeLogoutHandler logoutHandler;
  late ProviderContainer container;

  final provider = profilViewModelProvider;

  setUp(() {
    sessionRepository = FakeSessionRepository()
      ..currentUserResult = const Result.ok(
        User(id: 'user_001', name: 'Galah', phone: '+62 812-3456-7890'),
      );
    settingsRepository = FakeSettingsRepository();
    logoutHandler = FakeLogoutHandler();
    container = ProviderContainer(
      overrides: [
        sessionRepositoryProvider.overrideWithValue(sessionRepository),
        settingsRepositoryProvider.overrideWithValue(settingsRepository),
        logoutHandlerProvider.overrideWithValue(logoutHandler),
      ],
    );
    addTearDown(container.dispose);
  });

  Future<ProfilState> settle() async {
    container.listen(provider, (_, _) {});
    for (var i = 0; i < 50; i++) {
      if (!container.read(provider).isLoading) break;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    return container.read(provider);
  }

  test('loads the user card: name, masked phone, initial', () async {
    final state = await settle();

    expect(state.userName, 'Galah');
    expect(state.maskedPhone, '+62 812-****-7890');
    expect(state.avatarInitial, 'G');
    expect(state.notificationsEnabled, isTrue);
  });

  test('no session -> empty card, no crash', () async {
    sessionRepository.currentUserResult = const Result.ok(null);

    final state = await settle();

    expect(state.userName, isEmpty);
    expect(state.maskedPhone, isEmpty);
    expect(state.avatarInitial, '?');
  });

  test('maskUserPhone masks the middle group only', () {
    expect(
      ProfilViewModel.maskUserPhone('+62 812-3456-7890'),
      '+62 812-****-7890',
    );
    expect(
      ProfilViewModel.maskUserPhone('+6281234567890'),
      '+62 812-****-7890',
    );
  });

  group('theme', () {
    test('persists and applies live via themeModeProvider', () async {
      await settle();
      container.listen(themeModeProvider, (_, _) {});
      await Future<void>.delayed(const Duration(milliseconds: 20));

      await container.read(provider.notifier).setThemeMode(AppThemeMode.dark);

      expect(container.read(themeModeProvider), AppThemeMode.dark);
      expect(settingsRepository.themeMode, AppThemeMode.dark);

      await container.read(provider.notifier).setThemeMode(AppThemeMode.light);
      expect(container.read(themeModeProvider), AppThemeMode.light);
      expect(settingsRepository.themeMode, AppThemeMode.light);
    });

    test('a previously stored mode is picked up on launch', () async {
      settingsRepository.themeMode = AppThemeMode.dark;

      container.listen(themeModeProvider, (_, _) {});
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(container.read(themeModeProvider), AppThemeMode.dark);
    });
  });

  group('notifications switch', () {
    test('reads the stored value and persists a change', () async {
      settingsRepository.notificationsEnabled = false;
      var state = await settle();
      expect(state.notificationsEnabled, isFalse);

      await container.read(provider.notifier).setNotificationsEnabled(true);

      state = container.read(provider);
      expect(state.notificationsEnabled, isTrue);
      expect(settingsRepository.notificationsEnabled, isTrue);
    });

    test('a failed write reverts the switch', () async {
      await settle();
      settingsRepository.failSetNotifications = true;

      await container.read(provider.notifier).setNotificationsEnabled(false);

      expect(container.read(provider).notificationsEnabled, isTrue);
      expect(settingsRepository.notificationsEnabled, isTrue);
    });
  });

  test('logout goes through the shared handler once', () async {
    await settle();

    await container.read(provider.notifier).logout();

    expect(logoutHandler.calls, 1);
    expect(container.read(provider).isLoggingOut, isFalse);
  });
}
