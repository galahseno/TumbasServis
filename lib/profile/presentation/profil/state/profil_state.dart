import 'package:freezed_annotation/freezed_annotation.dart';

part 'profil_state.freezed.dart';

@freezed
abstract class ProfilState with _$ProfilState {
  const factory ProfilState({
    @Default(true) bool isLoading,
    @Default('') String userName,
    @Default('') String maskedPhone,
    @Default(true) bool notificationsEnabled,
    @Default(false) bool isLoggingOut,
  }) = _ProfilState;

  const ProfilState._();

  String get avatarInitial => userName.isEmpty
      ? '?'
      : String.fromCharCode(userName.runes.first).toUpperCase();

  static const versionLabel = 'Versi 1.0.0 (1)';
}
