import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_state.freezed.dart';

@freezed
abstract class OtpState with _$OtpState {
  const factory OtpState({
    @Default('') String phoneDigits,
    @Default('') String code,
    @Default(false) bool isError,
    @Default(false) bool isLoading,
    @Default(30) int secondsRemaining,
  }) = _OtpState;
}
