import 'package:tumbas_servis/core/domain/model/notification/app_notification.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/repository/notification/notification_repository.dart';

class FakeNotificationRepository implements NotificationRepository {
  int unreadCount = 0;

  @override
  Future<Result<List<AppNotification>>> getNotifications() async =>
      const Result.ok([]);

  @override
  Future<Result<void>> markRead(String id) async => const Result.ok(null);

  @override
  Future<Result<void>> addNotification(AppNotification notification) async =>
      const Result.ok(null);

  @override
  Stream<int> watchUnreadCount() => Stream.value(unreadCount);
}
