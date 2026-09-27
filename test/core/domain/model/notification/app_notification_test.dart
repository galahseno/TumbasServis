import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/domain/model/notification/app_notification.dart';

void main() {
  group('NotificationCategoryX.fromString', () {
    test('parses every known value', () {
      expect(
        NotificationCategoryX.fromString('status'),
        NotificationCategory.status,
      );
      expect(
        NotificationCategoryX.fromString('promo'),
        NotificationCategory.promo,
      );
      expect(
        NotificationCategoryX.fromString('reminder'),
        NotificationCategory.reminder,
      );
    });

    test('falls back to unknown instead of throwing', () {
      expect(
        NotificationCategoryX.fromString('bogus'),
        NotificationCategory.unknown,
      );
      expect(
        NotificationCategoryX.fromString(null),
        NotificationCategory.unknown,
      );
    });
  });
}
