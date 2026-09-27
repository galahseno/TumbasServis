import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_notification.freezed.dart';

enum NotificationCategory { status, promo, reminder, unknown }

extension NotificationCategoryX on NotificationCategory {
  static NotificationCategory fromString(String? value) => switch (value) {
    'status' => NotificationCategory.status,
    'promo' => NotificationCategory.promo,
    'reminder' => NotificationCategory.reminder,
    _ => NotificationCategory.unknown,
  };
}

@freezed
abstract class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    required NotificationCategory category,
    required String title,
    required String body,
    required DateTime timestamp,
    required bool read,
    String? deepLink,
  }) = _AppNotification;
}
