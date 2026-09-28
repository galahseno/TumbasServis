import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/home/presentation/home/state/home_state.dart';

const _stepLabels = ['Motor', 'Servis', 'Jadwal', 'Ringkasan'];

extension HomeDraftDisplayX on BookingDraft {
  HomeDraftDisplay toHomeDraftDisplay(List<Motor> motors, DateTime now) {
    final step = currentStep;
    final stepLabel = _stepLabels[step - 1];
    final motorLabelText = motorLabel(motors);
    final remaining = expiresAt.difference(now);
    final hoursLeft = remaining.inHours < 0 ? 0 : remaining.inHours;

    return (
      draft: this,
      summaryLine: '$motorLabelText · Langkah $step dari 4 · $stepLabel',
      expiryLabel: 'Kedaluwarsa dalam $hoursLeft jam',
      expiringSoon: remaining.inHours < 3,
    );
  }

  int get currentStep {
    if (selectedMotorIds.isEmpty) return 1;
    if (workshopId == null) return 2;
    if (voucherId == null) return 3;
    return 4;
  }

  String motorLabel(List<Motor> motors) {
    if (selectedMotorIds.length == 1) {
      final id = selectedMotorIds.first;
      for (final motor in motors) {
        if (motor.id == id) return motor.nickname;
      }
      return '1 motor';
    }
    return '${selectedMotorIds.length} motor';
  }
}
