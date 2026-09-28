import 'package:tumbas_servis/core/domain/model/garage/motor.dart';

extension MotorSelectDisplayX on Motor {
  String? disabledReason({
    required bool hasActiveBooking,
    required bool isMaxReached,
  }) {
    if (hasActiveBooking) return 'Sedang dalam servis';
    if (isMaxReached) return 'Maks. 5 motor';
    return null;
  }

  String semanticLabel({
    required bool selected,
    required bool hasActiveBooking,
    required bool isMaxReached,
  }) {
    final base = '$nickname, $plateNumber';
    if (selected) return '$base, dipilih';
    if (hasActiveBooking) {
      return '$base, tidak bisa dipilih: sedang dalam servis';
    }
    if (isMaxReached) {
      return '$base, tidak bisa dipilih: batas 5 motor tercapai';
    }
    return base;
  }
}
