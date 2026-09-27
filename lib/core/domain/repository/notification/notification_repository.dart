import 'package:tumbas_servis/core/domain/model/notification/app_notification.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';

abstract class NotificationRepository {
  Future<Result<List<AppNotification>>> getNotifications();
  Future<Result<void>> markRead(String id);
  Stream<int> watchUnreadCount();
}
