import 'package:tumbas_servis/core/domain/model/notification/app_notification.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';

abstract class NotificationRepository {
  Future<Result<List<AppNotification>>> getNotifications();
  Future<Result<void>> markRead(String id);
  Future<Result<void>> markAllRead();
  Future<Result<void>> addNotification(AppNotification notification);
  Stream<int> watchUnreadCount();
}
