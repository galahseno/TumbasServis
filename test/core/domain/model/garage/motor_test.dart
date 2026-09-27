import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';

void main() {
  group('Motor.formatPlateNumber', () {
    test('formats an already-clean plate', () {
      expect(Motor.formatPlateNumber('AB1234XY'), 'AB 1234 XY');
    });

    test('formats lowercase and missing spaces', () {
      expect(Motor.formatPlateNumber('ab 1234 xy'), 'AB 1234 XY');
    });

    test('formats a short numeric suffix without letters', () {
      expect(Motor.formatPlateNumber('B123'), 'B 123');
    });

    test('formats a single-letter region with no suffix', () {
      expect(Motor.formatPlateNumber('D 4567'), 'D 4567');
    });

    test('falls back to cleaned input when the shape is invalid', () {
      expect(Motor.formatPlateNumber('12345'), '12345');
      expect(Motor.formatPlateNumber(''), '');
    });
  });

  group('Motor.isNicknameValid', () {
    test('accepts nickname at or under the 20-char cap', () {
      const motor = Motor(
        id: 'mo1',
        ownerId: 'u1',
        nickname: 'Si Merah',
        plateNumber: 'AB 1234 XY',
        modelId: 'mm1',
      );

      expect(motor.isNicknameValid, isTrue);
    });

    test('rejects nickname over the 20-char cap', () {
      const motor = Motor(
        id: 'mo1',
        ownerId: 'u1',
        nickname: 'Nama Panggilan Yang Kepanjangan',
        plateNumber: 'AB 1234 XY',
        modelId: 'mm1',
      );

      expect(motor.isNicknameValid, isFalse);
    });

    test('accepts nickname exactly at the boundary', () {
      final motor = Motor(
        id: 'mo1',
        ownerId: 'u1',
        nickname: 'x' * Motor.nicknameMaxLength,
        plateNumber: 'AB 1234 XY',
        modelId: 'mm1',
      );

      expect(motor.isNicknameValid, isTrue);
    });
  });
}
