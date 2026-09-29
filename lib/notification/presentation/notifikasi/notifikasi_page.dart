import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/core/domain/model/notification/app_notification.dart';
import 'package:tumbas_servis/core/presentation/components/empty_state.dart';
import 'package:tumbas_servis/core/presentation/components/error_state.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/components/ts_app_bar.dart';
import 'package:tumbas_servis/core/presentation/components/ts_snackbar.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/notification/presentation/di/notification_presentation_module.dart';
import 'package:tumbas_servis/notification/presentation/notifikasi/components/notification_group_header.dart';
import 'package:tumbas_servis/notification/presentation/notifikasi/components/notification_tile.dart';
import 'package:tumbas_servis/notification/presentation/notifikasi/state/notifikasi_state.dart';
import 'package:tumbas_servis/notification/presentation/utils/notification_grouping.dart';

class NotifikasiPage extends ConsumerWidget {
  const NotifikasiPage({super.key});

  Future<void> _open(
    BuildContext context,
    WidgetRef ref,
    AppNotification notification,
  ) async {
    final target = await ref
        .read(notifikasiViewModelProvider.notifier)
        .open(notification);
    if (target == null || !context.mounted) return;
    if (target.replaceStack) {
      context.go(target.location, extra: target.extra);
    } else {
      await context.push(target.location, extra: target.extra);
    }
    if (target.message != null && context.mounted) {
      TsSnackbar.info(context, target.message!);
    }
  }

  Future<void> _markAll(BuildContext context, WidgetRef ref) async {
    final ok = await ref
        .read(notifikasiViewModelProvider.notifier)
        .markAllRead();
    if (!ok && context.mounted) {
      TsSnackbar.error(context, 'Gagal menandai dibaca. Coba lagi.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notifikasiViewModelProvider);
    final viewModel = ref.read(notifikasiViewModelProvider.notifier);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: TsAppBar.back(
        title: 'Notifikasi',
        onBack: () =>
            context.canPop() ? context.pop() : Navigator.of(context).maybePop(),
      ),
      body: SafeArea(
        top: false,
        child: state.hasError
            ? ErrorState(
                message: 'Gagal memuat notifikasi. Coba lagi.',
                onRetry: viewModel.retry,
                layout: ErrorStateLayout.fullPage,
              )
            : state.isLoading
            ? const _NotifikasiSkeleton()
            : state.isEmpty
            ? const EmptyState(
                title: 'Belum ada notifikasi',
                body:
                    'Status servis, promo, dan pengingat akan muncul di '
                    'sini.',
                icon: Icons.notifications_none_rounded,
              )
            : _NotifikasiList(
                state: state,
                onOpen: (n) => _open(context, ref, n),
                onMarkAll: () => _markAll(context, ref),
              ),
      ),
    );
  }
}

class _NotifikasiList extends StatelessWidget {
  const _NotifikasiList({
    required this.state,
    required this.onOpen,
    required this.onMarkAll,
  });

  final NotifikasiState state;
  final ValueChanged<AppNotification> onOpen;
  final VoidCallback onMarkAll;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final groups = state.groups;
    final now = state.now!;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var g = 0; g < groups.length; g++) ...[
                  if (g > 0) const SizedBox(height: 16),
                  NotificationGroupHeader(
                    title: groups[g].kind.label,
                    actionLabel: g == 0 ? 'Tandai semua dibaca' : null,
                    onAction: state.unreadCount == 0 || state.isMarkingAll
                        ? null
                        : onMarkAll,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        for (var i = 0; i < groups[g].items.length; i++) ...[
                          if (i > 0)
                            Divider(height: 1, color: ext.borderDefault),
                          NotificationTile(
                            notification: groups[g].items[i],
                            stamp: NotificationGrouping.stamp(
                              groups[g].items[i],
                              now,
                            ),
                            onTap: () => onOpen(groups[g].items[i]),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NotifikasiSkeleton extends StatelessWidget {
  const _NotifikasiSkeleton();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Memuat notifikasi',
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          const SkeletonLine(width: 96, height: 18),
          const SizedBox(height: 12),
          for (var i = 0; i < 5; i++) ...[
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonAvatar(),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLine(width: 180),
                      SizedBox(height: 8),
                      SkeletonLine(),
                      SizedBox(height: 8),
                      SkeletonLine(width: 80, height: 12),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }
}
