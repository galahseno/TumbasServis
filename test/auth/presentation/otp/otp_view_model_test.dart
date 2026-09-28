import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/app/app.dart';
import 'package:tumbas_servis/app/navigation/router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/auth/data/di/auth_data_module.dart';
import 'package:tumbas_servis/auth/presentation/di/auth_presentation_module.dart';
import 'package:tumbas_servis/auth/presentation/otp/otp_view_model.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/model/user/user.dart';
import 'package:tumbas_servis/profile/data/di/profile_data_module.dart';

import '../../../support/fake_session_repository.dart';
import '../../../support/fake_settings_repository.dart';
import '../../../support/home_screen_fake_overrides.dart';
import '../../../support/manual_timer_factory.dart';

void main() {
  late FakeSessionRepository fakeSessionRepository;
  late ManualTimerFactory timerFactory;
  late ProviderContainer container;
  late GoRouter router;

  Future<void> pumpAtOtp(WidgetTester tester) async {
    fakeSessionRepository = FakeSessionRepository()
      ..currentUserResult = Result.ok(
        User(id: 'u1', name: 'Budi', phone: '0812'),
      )
      ..verifyOtpResult = (code) => code == '123456'
          ? Result.ok(User(id: 'u1', name: 'Budi', phone: '0812'))
          : Result.error(Exception('Invalid OTP code.'));
    timerFactory = ManualTimerFactory();
    container = ProviderContainer(
      overrides: [
        sessionRepositoryProvider.overrideWithValue(fakeSessionRepository),
        settingsRepositoryProvider.overrideWithValue(FakeSettingsRepository()),
        otpViewModelProvider.overrideWith(
          () => OtpViewModel(timerFactory: timerFactory.call),
        ),
        ...homeScreenFakeOverrides(),
      ],
    );
    addTearDown(container.dispose);
    router = container.read(routerProvider);
    router.go(Routes.login);
    router.push(Routes.otp, extra: '81234567890');

    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    await tester.pumpAndSettle();
  }

  Future<void> enterCode(WidgetTester tester, String digits) async {
    final fields = find.byType(TextField);
    for (var i = 0; i < digits.length; i++) {
      await tester.enterText(fields.at(i), digits[i]);
      await tester.pump();
    }
  }

  testWidgets('Verifikasi is disabled with a reason line under 6 digits', (
    tester,
  ) async {
    await pumpAtOtp(tester);

    expect(find.text('Masukkan 6 digit kode'), findsOneWidget);

    await enterCode(tester, '12345');
    await tester.tap(find.text('Verifikasi'));
    await tester.pumpAndSettle();

    // Disabled: tapping does not call the repository or navigate away.
    expect(fakeSessionRepository.lastVerifiedCode, isNull);
    expect(find.text('Masukkan kode OTP'), findsOneWidget);
  });

  testWidgets('123456 always succeeds and navigates home', (tester) async {
    await pumpAtOtp(tester);

    await enterCode(tester, '123456');
    await tester.tap(find.text('Verifikasi'));
    await tester.pumpAndSettle();

    expect(find.text('Masukkan kode OTP'), findsNothing);
    expect(fakeSessionRepository.lastVerifiedCode, '123456');
  });

  testWidgets('any other 6-digit code errors and clears the cells', (
    tester,
  ) async {
    await pumpAtOtp(tester);

    await enterCode(tester, '000000');
    await tester.tap(find.text('Verifikasi'));
    await tester.pumpAndSettle();

    expect(find.text(wrongOtpError), findsOneWidget);
    for (final field in find.byType(TextField).evaluate()) {
      expect((field.widget as TextField).controller?.text ?? '', isEmpty);
    }
  });

  testWidgets('30s countdown ticks down and re-enables resend', (tester) async {
    await pumpAtOtp(tester);

    expect(find.text('Kirim ulang kode dalam 0:30'), findsOneWidget);

    for (var i = 0; i < otpResendSeconds; i++) {
      timerFactory.fire();
      await tester.pump();
    }

    expect(find.text('Kirim ulang kode'), findsOneWidget);
    expect(find.textContaining('Kirim ulang kode dalam'), findsNothing);
  });
}
