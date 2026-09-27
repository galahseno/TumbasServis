import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor_model.dart';

void main() {
  group('MotorBrandX.fromString', () {
    test('parses every known value', () {
      expect(MotorBrandX.fromString('Honda'), MotorBrand.honda);
      expect(MotorBrandX.fromString('Yamaha'), MotorBrand.yamaha);
      expect(MotorBrandX.fromString('Suzuki'), MotorBrand.suzuki);
      expect(MotorBrandX.fromString('Kawasaki'), MotorBrand.kawasaki);
    });

    test('falls back to unknown instead of throwing', () {
      expect(MotorBrandX.fromString('Ducati'), MotorBrand.unknown);
      expect(MotorBrandX.fromString(null), MotorBrand.unknown);
    });
  });

  group('MotorCategoryX.fromString', () {
    test('parses every known value', () {
      expect(MotorCategoryX.fromString('matic'), MotorCategory.matic);
      expect(MotorCategoryX.fromString('bebek'), MotorCategory.bebek);
      expect(MotorCategoryX.fromString('sport'), MotorCategory.sport);
    });

    test('falls back to unknown instead of throwing', () {
      expect(MotorCategoryX.fromString('bogus'), MotorCategory.unknown);
      expect(MotorCategoryX.fromString(null), MotorCategory.unknown);
    });
  });

  group('MotorModel', () {
    const model = MotorModel(
      id: 'mm1',
      brand: MotorBrand.honda,
      name: 'Beat',
      category: MotorCategory.matic,
      cc: 110,
    );

    test('copyWith overrides only given fields', () {
      final updated = model.copyWith(name: 'Vario');

      expect(updated.name, 'Vario');
      expect(updated.brand, MotorBrand.honda);
    });

    test('equality is based on id', () {
      const other = MotorModel(
        id: 'mm1',
        brand: MotorBrand.yamaha,
        name: 'Different',
        category: MotorCategory.sport,
        cc: 150,
      );

      expect(model, other);
      expect(model.hashCode, other.hashCode);
    });
  });
}
