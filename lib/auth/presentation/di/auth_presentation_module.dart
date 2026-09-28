import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/auth/presentation/login/login_view_model.dart';
import 'package:tumbas_servis/auth/presentation/login/state/login_state.dart';
import 'package:tumbas_servis/auth/presentation/onboarding/onboarding_view_model.dart';
import 'package:tumbas_servis/auth/presentation/onboarding/state/onboarding_state.dart';
import 'package:tumbas_servis/auth/presentation/otp/otp_view_model.dart';
import 'package:tumbas_servis/auth/presentation/otp/state/otp_state.dart';
import 'package:tumbas_servis/auth/presentation/splash/splash_view_model.dart';
import 'package:tumbas_servis/auth/presentation/splash/state/splash_state.dart';

final splashViewModelProvider =
    NotifierProvider.autoDispose<SplashViewModel, SplashState>(
      SplashViewModel.new,
    );

final onboardingViewModelProvider =
    NotifierProvider<OnboardingViewModel, OnboardingState>(
      OnboardingViewModel.new,
    );

final loginViewModelProvider = NotifierProvider<LoginViewModel, LoginState>(
  LoginViewModel.new,
);

final otpViewModelProvider = NotifierProvider<OtpViewModel, OtpState>(
  OtpViewModel.new,
);
