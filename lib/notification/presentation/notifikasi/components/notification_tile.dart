import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/domain/model/notification/app_notification.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class NotificationTile extends StatefulWidget {
  const NotificationTile({
    required this.notification,
    required this.stamp,
    required this.onTap,
    super.key,
  });

  final AppNotification notification;
  final String stamp;
  final VoidCallback onTap;

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  bool _focused = false;

  static String _categoryLabel(NotificationCategory category) =>
      switch (category) {
        NotificationCategory.status || NotificationCategory.unknown => 'Status',
        NotificationCategory.promo => 'Promo',
        NotificationCategory.reminder => 'Pengingat',
      };

  static IconData _categoryIcon(NotificationCategory category) =>
      switch (category) {
        NotificationCategory.status ||
        NotificationCategory.unknown => Icons.build_circle_outlined,
        NotificationCategory.promo => Icons.local_offer_outlined,
        NotificationCategory.reminder => Icons.notifications_active_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final notification = widget.notification;
    final unread = !notification.read;
    final isStatus =
        notification.category == NotificationCategory.status ||
        notification.category == NotificationCategory.unknown;
    final label = _categoryLabel(notification.category);

    return Semantics(
      button: true,
      label:
          '${unread ? 'Belum dibaca. ' : ''}${notification.title}. '
          '${widget.stamp}',
      excludeSemantics: true,
      onTap: widget.onTap,
      child: Focus(
        onFocusChange: (value) => setState(() => _focused = value),
        child: InkWell(
          onTap: widget.onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 72),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: _focused
                  ? Border.all(color: ext.focusRing, width: 2)
                  : null,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isStatus
                        ? scheme.primaryContainer
                        : scheme.surfaceContainerLow,
                    border: isStatus
                        ? null
                        : Border.all(color: ext.borderDefault),
                  ),
                  child: Icon(
                    _categoryIcon(notification.category),
                    size: 20,
                    color: isStatus ? scheme.onPrimaryContainer : ext.textBody,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: textTheme.titleSmall?.copyWith(
                          color: scheme.onSurface,
                          fontWeight: unread
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        notification.body,
                        style: textTheme.bodyMedium?.copyWith(
                          color: ext.textBody,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$label · ${widget.stamp}',
                        style: textTheme.bodySmall?.copyWith(
                          color: ext.textMuted,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
                if (unread) ...[
                  const SizedBox(width: 12),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ext.accent,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
