import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/domain/model/workshop/mechanic.dart';

void main() {
  group('Mechanic', () {
    const mechanic = Mechanic(
      id: 'm1',
      name: 'Agus',
      avatarInitial: 'A',
      rating: 4.5,
    );

    test('copyWith overrides only given fields', () {
      final updated = mechanic.copyWith(rating: 5.0);

      expect(updated.rating, 5.0);
      expect(updated.name, 'Agus');
    });

    test('equality is based on id', () {
      const other = Mechanic(
        id: 'm1',
        name: 'Different',
        avatarInitial: 'D',
        rating: 1.0,
      );

      expect(mechanic, other);
      expect(mechanic.hashCode, other.hashCode);
    });
  });
}
