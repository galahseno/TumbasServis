import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';

void main() {
  group('UnitStatusX.fromString', () {
    test('parses every known value', () {
      expect(UnitStatusX.fromString('terjadwal'), UnitStatus.terjadwal);
      expect(UnitStatusX.fromString('checkIn'), UnitStatus.checkIn);
      expect(UnitStatusX.fromString('diperiksa'), UnitStatus.diperiksa);
      expect(UnitStatusX.fromString('dikerjakan'), UnitStatus.dikerjakan);
      expect(UnitStatusX.fromString('qc'), UnitStatus.qc);
      expect(UnitStatusX.fromString('selesai'), UnitStatus.selesai);
      expect(UnitStatusX.fromString('dibatalkan'), UnitStatus.dibatalkan);
    });

    test('falls back to unknown instead of throwing', () {
      expect(UnitStatusX.fromString('bogus'), UnitStatus.unknown);
      expect(UnitStatusX.fromString(null), UnitStatus.unknown);
    });
  });

  group('UnitStatus.canTransitionTo', () {
    test('allows the next forward step only', () {
      expect(UnitStatus.terjadwal.canTransitionTo(UnitStatus.checkIn), isTrue);
      expect(
        UnitStatus.terjadwal.canTransitionTo(UnitStatus.diperiksa),
        isFalse,
      );
      expect(UnitStatus.qc.canTransitionTo(UnitStatus.selesai), isTrue);
    });

    test('allows cancel from any non-terminal state', () {
      expect(
        UnitStatus.terjadwal.canTransitionTo(UnitStatus.dibatalkan),
        isTrue,
      );
      expect(
        UnitStatus.dikerjakan.canTransitionTo(UnitStatus.dibatalkan),
        isTrue,
      );
    });

    test('disallows cancel once terminal', () {
      expect(
        UnitStatus.selesai.canTransitionTo(UnitStatus.dibatalkan),
        isFalse,
      );
      expect(
        UnitStatus.dibatalkan.canTransitionTo(UnitStatus.dibatalkan),
        isFalse,
      );
    });

    test('isTerminal is true only for selesai and dibatalkan', () {
      expect(UnitStatus.selesai.isTerminal, isTrue);
      expect(UnitStatus.dibatalkan.isTerminal, isTrue);
      expect(UnitStatus.qc.isTerminal, isFalse);
    });
  });
}
