import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/domain/model/user/user.dart';

void main() {
  group('User', () {
    const user = User(id: 'u1', name: 'Budi', phone: '0812');

    test('copyWith overrides only given fields', () {
      final updated = user.copyWith(name: 'Siti');

      expect(updated.name, 'Siti');
      expect(updated.id, 'u1');
      expect(updated.phone, '0812');
    });

    test('equality is based on id', () {
      const other = User(id: 'u1', name: 'Different name', phone: '0899');

      expect(user, other);
      expect(user.hashCode, other.hashCode);
    });

    test('different id is not equal', () {
      const other = User(id: 'u2', name: 'Budi', phone: '0812');

      expect(user, isNot(other));
    });
  });
}
