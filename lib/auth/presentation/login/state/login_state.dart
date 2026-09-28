import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    @Default('') String phoneDigits,
    String? errorText,
    @Default(false) bool isLoading,
    String? snackbarMessage,
  }) = _LoginState;
}
