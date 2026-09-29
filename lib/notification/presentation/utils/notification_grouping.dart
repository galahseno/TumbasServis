import 'package:intl/intl.dart';
import 'package:tumbas_servis/core/domain/model/notification/app_notification.dart';
import 'package:tumbas_servis/core/presentation/utils/time_formatter.dart';

enum NotificationGroupKind { hariIni, mingguIni, lebihLama }

extension NotificationGroupKindX on NotificationGroupKind {
  String get label => switch (this) {
    NotificationGroupKind.hariIni => 'Hari ini',
    NotificationGroupKind.mingguIni => 'Minggu ini',
    NotificationGroupKind.lebihLama => 'Lebih lama',
  };
}

class NotificationGroup {
  const NotificationGroup({required this.kind, required this.items});

  final NotificationGroupKind kind;
  final List<AppNotification> items;
}

abstract final class NotificationGrouping {
  static final _weekdayFormat = DateFormat('EEE d MMM', 'id_ID');
  static final _dayFormat = DateFormat('d MMM', 'id_ID');

  static NotificationGroupKind kindFor(DateTime timestamp, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(timestamp.year, timestamp.month, timestamp.day);
    final daysAgo = today.difference(day).inDays;
    if (daysAgo <= 0) return NotificationGroupKind.hariIni;
    if (daysAgo <= 7) return NotificationGroupKind.mingguIni;
    return NotificationGroupKind.lebihLama;
  }

  static List<NotificationGroup> group(
    List<AppNotification> notifications,
    DateTime now,
  ) {
    final byKind = {
      for (final kind in NotificationGroupKind.values)
        kind: <AppNotification>[],
    };
    for (final notification in notifications) {
      byKind[kindFor(notification.timestamp, now)]!.add(notification);
    }
    return [
      for (final kind in NotificationGroupKind.values)
        if (byKind[kind]!.isNotEmpty)
          NotificationGroup(kind: kind, items: byKind[kind]!),
    ];
  }

  static String stamp(AppNotification notification, DateTime now) =>
      switch (kindFor(notification.timestamp, now)) {
        NotificationGroupKind.hariIni => TimeFormatter.format(
          notification.timestamp,
        ),
        NotificationGroupKind.mingguIni => _weekdayFormat.format(
          notification.timestamp,
        ),
        NotificationGroupKind.lebihLama => _dayFormat.format(
          notification.timestamp,
        ),
      };
}
