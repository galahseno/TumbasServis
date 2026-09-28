import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';
import 'package:tumbas_servis/home/presentation/utils/home_draft_display.dart';

Motor _motor(String id, String nickname) => Motor(
  id: id,
  ownerId: 'user_001',
  nickname: nickname,
  plateNumber: 'AB 0000 XY',
  modelId: 'model_x',
);

BookingDraft _draft({
  List<String> motorIds = const [],
  String? workshopId,
  String? voucherId,
  required DateTime expiresAt,
}) => BookingDraft(
  id: 'draft_1',
  selectedMotorIds: motorIds,
  unitConfigs: const {},
  workshopId: workshopId,
  scheduleMode: ScheduleMode.shared,
  unitSlots: const {},
  voucherId: voucherId,
  createdAt: DateTime(2026, 9, 28, 8),
  expiresAt: expiresAt,
);

void main() {
  group('currentStep', () {
    test('empty motor ids → 1', () {
      expect(_draft(expiresAt: DateTime(2026, 9, 29)).currentStep, 1);
    });

    test('motors picked, no workshop → 2', () {
      expect(
        _draft(
          motorIds: ['motor_a'],
          expiresAt: DateTime(2026, 9, 29),
        ).currentStep,
        2,
      );
    });

    test('workshop picked, no voucher → 3', () {
      expect(
        _draft(
          motorIds: ['motor_a'],
          workshopId: 'ws_001',
          expiresAt: DateTime(2026, 9, 29),
        ).currentStep,
        3,
      );
    });

    test('voucher picked → 4', () {
      expect(
        _draft(
          motorIds: ['motor_a'],
          workshopId: 'ws_001',
          voucherId: 'vc_001',
          expiresAt: DateTime(2026, 9, 29),
        ).currentStep,
        4,
      );
    });
  });

  group('motorLabel', () {
    test('single known motor → nickname', () {
      final draft = _draft(
        motorIds: ['motor_a'],
        expiresAt: DateTime(2026, 9, 29),
      );
      expect(draft.motorLabel([_motor('motor_a', 'Vario')]), 'Vario');
    });

    test('single unknown motor → fallback', () {
      final draft = _draft(
        motorIds: ['motor_x'],
        expiresAt: DateTime(2026, 9, 29),
      );
      expect(draft.motorLabel([_motor('motor_a', 'Vario')]), '1 motor');
    });

    test('multiple motors → count', () {
      final draft = _draft(
        motorIds: ['motor_a', 'motor_b'],
        expiresAt: DateTime(2026, 9, 29),
      );
      expect(draft.motorLabel([]), '2 motor');
    });
  });

  group('toHomeDraftDisplay', () {
    test('summary line uses step and label', () {
      final draft = _draft(
        motorIds: ['motor_a'],
        workshopId: 'ws_001',
        expiresAt: DateTime(2026, 9, 29),
      );
      final display = draft.toHomeDraftDisplay(
        [_motor('motor_a', 'Vario')],
        DateTime(2026, 9, 28, 12),
      );
      expect(display.summaryLine, 'Vario · Langkah 3 dari 4 · Jadwal');
      expect(display.expiringSoon, isFalse);
    });

    test('negative remaining hours clamp to 0 in label', () {
      final draft = _draft(expiresAt: DateTime(2026, 9, 28, 10));
      final display = draft.toHomeDraftDisplay(
        [],
        DateTime(2026, 9, 28, 12),
      );
      expect(display.expiryLabel, 'Kedaluwarsa dalam 0 jam');
      expect(display.expiringSoon, isTrue);
    });

    test('expiringSoon boundary at <3h', () {
      final now = DateTime(2026, 9, 28, 12);
      final twoHours = _draft(expiresAt: now.add(const Duration(hours: 2)));
      final threeHours = _draft(expiresAt: now.add(const Duration(hours: 3)));
      expect(twoHours.toHomeDraftDisplay([], now).expiringSoon, isTrue);
      expect(threeHours.toHomeDraftDisplay([], now).expiringSoon, isFalse);
    });
  });
}
