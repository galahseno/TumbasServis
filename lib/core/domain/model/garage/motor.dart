import 'package:freezed_annotation/freezed_annotation.dart';

part 'motor.freezed.dart';

@freezed
abstract class Motor with _$Motor {
  const Motor._();

  const factory Motor({
    required String id,
    required String ownerId,
    required String nickname,
    required String plateNumber,
    int? year,
    String? photoUrl,
    required String modelId,
  }) = _Motor;

  static const int nicknameMaxLength = 20;

  bool get isNicknameValid => nickname.length <= nicknameMaxLength;

  static String formatPlateNumber(String raw) {
    final cleaned = raw.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    final match = RegExp(
      r'^([A-Z]{1,2})(\d{1,4})([A-Z]{0,3})$',
    ).firstMatch(cleaned);
    if (match == null) return cleaned;
    final region = match.group(1) ?? '';
    final number = match.group(2) ?? '';
    final suffix = match.group(3) ?? '';
    return [region, number, if (suffix.isNotEmpty) suffix].join(' ');
  }
}
