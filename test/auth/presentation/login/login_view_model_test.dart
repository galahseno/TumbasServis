import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/app/app.dart';
import 'package:tumbas_servis/app/navigation/router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/auth/data/di/auth_data_module.dart';
import 'package:tumbas_servis/auth/presentation/di/auth_presentation_module.dart';
import 'package:tumbas_servis/auth/presentation/login/login_view_model.dart';
import 'package:tumbas_servis/auth/presentation/otp/otp_view_model.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/user/user.dart';
import 'package:tumbas_servis/profile/data/di/profile_data_module.dart';

import '../../../support/fake_session_repository.dart';
import '../../../support/fake_settings_repository.dart';
import '../../../support/manual_timer_factory.dart';

void main() {
  late FakeSessionRepository fakeSessionRepository;
  late ProviderContainer container;
  late GoRouter router;

  Future<void> pumpAtLogin(WidgetTester tester) async {
    fakeSessionRepository = FakeSessionRepository()
      ..currentUserResult = Result.ok(
        User(id: 'u1', name: 'Budi', phone: '0812'),
      );
    container = ProviderContainer(
      overrides: [
        sessionRepositoryProvider.overrideWithValue(fakeSessionRepository),
        settingsRepositoryProvider.overrideWithValue(FakeSettingsRepository()),
        otpViewModelProvider.overrideWith(
          () => OtpViewModel(timerFactory: ManualTimerFactory().call),
        ),
      ],
    );
    addTearDown(container.dispose);
    router = container.read(routerProvider);
    router.go(Routes.login);

    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    await tester.pumpAndSettle();
  }

  String currentPath() => router.routeInformationProvider.value.uri.path;

  testWidgets('invalid phone shows the exact error copy on submit', (
    tester,
  ) async {
    await pumpAtLogin(tester);

    await tester.enterText(find.byType(TextField), '812345');
    await tester.tap(find.text('Kirim kode OTP'));
    await tester.pumpAndSettle();

    expect(find.text(invalidPhoneError), findsOneWidget);
    expect(currentPath(), Routes.login);
  });

  testWidgets('valid phone navigates to otp with the phone digits', (
    tester,
  ) async {
    await pumpAtLogin(tester);

    await tester.enterText(find.byType(TextField), '812-3456-7890');
    await tester.tap(find.text('Kirim kode OTP'));
    await tester.pumpAndSettle();

    expect(find.text('Masukkan kode OTP'), findsOneWidget);
    expect(fakeSessionRepository.lastLoginPhone, '+6281234567890');
  });

  testWidgets('armed network error shows the snackbar and stays put', (
    tester,
  ) async {
    await pumpAtLogin(tester);
    fakeSessionRepository.loginResult = Result.error(Exception('offline'));

    await tester.enterText(find.byType(TextField), '812-3456-7890');
    await tester.tap(find.text('Kirim kode OTP'));
    await tester.pumpAndSettle();

    expect(find.text(loginNetworkErrorMessage), findsOneWidget);
    expect(currentPath(), Routes.login);
  });
}
