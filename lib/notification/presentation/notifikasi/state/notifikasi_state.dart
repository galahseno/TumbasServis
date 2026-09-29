import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tumbas_servis/core/domain/model/notification/app_notification.dart';
import 'package:tumbas_servis/notification/presentation/utils/notification_grouping.dart';

part 'notifikasi_state.freezed.dart';

@freezed
abstract class NotifikasiState with _$NotifikasiState {
  const factory NotifikasiState({
    @Default(true) bool isLoading,
    @Default(false) bool hasError,
    @Default([]) List<AppNotification> notifications,
    @Default(false) bool isMarkingAll,
    DateTime? now,
  }) = _NotifikasiState;

  const NotifikasiState._();

  int get unreadCount => notifications.where((n) => !n.read).length;

  bool get isEmpty => !isLoading && !hasError && notifications.isEmpty;

  bool get isReady => !isLoading && !hasError && notifications.isNotEmpty;

  List<NotificationGroup> get groups =>
      now == null ? const [] : NotificationGrouping.group(notifications, now!);
}
