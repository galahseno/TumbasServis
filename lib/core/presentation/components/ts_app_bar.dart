import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/ts_icon_button.dart';
import 'package:tumbas_servis/core/presentation/components/ts_logo.dart';

enum TsAppBarLeading { none, back, close }

class TsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TsAppBar({
    required this.title,
    super.key,
    this.showBack = false,
    this.onBack,
    this.leading = TsAppBarLeading.none,
    this.onLeadingPressed,
    this.leadingSemanticLabel,
    this.large = false,
    this.bellUnreadCount,
    this.onBellPressed,
    this.actions = const [],
    this.titleWidget,
  });

  factory TsAppBar.home({int? bellUnreadCount, VoidCallback? onBellPressed}) =>
      TsAppBar(
        title: 'TumbasServis',
        titleWidget: const TsLogo(markOnly: false, size: 28),
        bellUnreadCount: bellUnreadCount,
        onBellPressed: onBellPressed,
      );

  factory TsAppBar.back({
    required String title,
    VoidCallback? onBack,
    List<Widget> actions = const [],
  }) =>
      TsAppBar(title: title, showBack: true, onBack: onBack, actions: actions);

  factory TsAppBar.close({
    required String title,
    required VoidCallback onClose,
    String semanticLabel = 'Tutup',
    List<Widget> actions = const [],
  }) => TsAppBar(
    title: title,
    leading: TsAppBarLeading.close,
    onLeadingPressed: onClose,
    leadingSemanticLabel: semanticLabel,
    actions: actions,
  );

  factory TsAppBar.title(String title) => TsAppBar(title: title);

  factory TsAppBar.large(String title) => TsAppBar(title: title, large: true);

  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final TsAppBarLeading leading;
  final VoidCallback? onLeadingPressed;
  final String? leadingSemanticLabel;
  final bool large;
  final int? bellUnreadCount;
  final VoidCallback? onBellPressed;
  final List<Widget> actions;
  final Widget? titleWidget;

  @override
  Size get preferredSize => Size.fromHeight(large ? 96 : 64);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final hasBack = showBack || leading == TsAppBarLeading.back;
    final hasClose = leading == TsAppBarLeading.close;
    final leadingWidget = hasClose
        ? TsIconButton(
            icon: Icons.close_rounded,
            onPressed: onLeadingPressed,
            semanticLabel: leadingSemanticLabel ?? 'Tutup',
          )
        : hasBack
        ? TsIconButton(
            icon: Icons.arrow_back_rounded,
            onPressed:
                onLeadingPressed ??
                onBack ??
                () => Navigator.of(context).maybePop(),
            semanticLabel: leadingSemanticLabel ?? 'Kembali',
          )
        : null;

    return AppBar(
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: preferredSize.height,
      centerTitle: false,
      leading: leadingWidget,
      leadingWidth: leadingWidget != null ? 56 : null,
      title:
          titleWidget ??
          Text(
            title,
            style: (large ? textTheme.headlineSmall : textTheme.titleLarge)
                ?.copyWith(color: scheme.onSurface),
          ),
      actions: [
        ...actions,
        if (bellUnreadCount != null)
          TsIconButton(
            icon: Icons.notifications_outlined,
            onPressed: onBellPressed,
            badgeCount: bellUnreadCount,
            semanticLabel: 'Notifikasi',
          ),
        const SizedBox(width: 4),
      ],
    );
  }
}
