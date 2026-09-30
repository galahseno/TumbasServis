import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/core/presentation/components/adaptive_sheet.dart';
import 'package:tumbas_servis/core/presentation/components/sheet_header.dart';
import 'package:tumbas_servis/core/presentation/components/ts_app_bar.dart';
import 'package:tumbas_servis/core/presentation/components/ts_dialog.dart';
import 'package:tumbas_servis/core/presentation/components/ts_logo.dart';
import 'package:tumbas_servis/core/presentation/di/core_presentation_module.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/core/presentation/utils/window_size_class.dart';
import 'package:tumbas_servis/profile/presentation/di/profile_presentation_module.dart';
import 'package:tumbas_servis/profile/presentation/profil/components/settings_row.dart';
import 'package:tumbas_servis/profile/presentation/profil/components/theme_preview.dart';
import 'package:tumbas_servis/profile/presentation/profil/components/theme_setting.dart';
import 'package:tumbas_servis/profile/presentation/profil/components/user_card.dart';
import 'package:tumbas_servis/profile/presentation/profil/state/profil_state.dart';

class ProfilPage extends ConsumerWidget {
  const ProfilPage({super.key});

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await TsDialog.confirmSave(
      context,
      title: 'Keluar dari akun?',
      message: 'Data motor dan booking tetap tersimpan di perangkat ini.',
      confirmLabel: 'Keluar',
      cancelLabel: 'Batal',
    );
    if (confirmed != true || !context.mounted) return;
    await ref.read(profilViewModelProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profilViewModelProvider);
    final viewModel = ref.read(profilViewModelProvider.notifier);
    final themeMode = ref.watch(themeModeProvider);
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);

    Widget group(List<Widget> rows) => Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) Divider(height: 1, color: ext.borderDefault),
            rows[i],
          ],
        ],
      ),
    );

    final isWide = context.windowSizeClass.isAtLeast(WindowSizeClass.expanded);
    final menu = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        UserCard(
          name: state.userName,
          maskedPhone: state.maskedPhone,
          initial: state.avatarInitial,
        ),
        const SizedBox(height: 16),
        group([
          ThemeSetting(mode: themeMode, onChanged: viewModel.setThemeMode),
          SettingsRow(
            icon: Icons.notifications_outlined,
            title: 'Notifikasi',
            subtitle: 'Status servis, promo, dan pengingat',
            switchValue: state.notificationsEnabled,
            onSwitchChanged: viewModel.setNotificationsEnabled,
          ),
        ]),
        const SizedBox(height: 16),
        group([
          SettingsRow(
            icon: Icons.bolt_rounded,
            title: 'Mode Demo',
            tag: 'Demo',
            showChevron: true,
            onTap: () => context.push(Routes.profileDemoMode),
          ),
          SettingsRow(
            icon: Icons.info_outline_rounded,
            title: 'Tentang aplikasi',
            subtitle: 'Versi 1.0.0',
            showChevron: true,
            onTap: () => _showAbout(context),
          ),
        ]),
        const SizedBox(height: 16),
        group([
          SettingsRow(
            icon: Icons.logout_rounded,
            title: 'Keluar',
            onTap: state.isLoggingOut
                ? null
                : () => _confirmLogout(context, ref),
          ),
        ]),
      ],
    );

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: TsAppBar.large('Profil'),
      body: SafeArea(
        top: false,
        child: isWide
            ? SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 992),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 480, child: menu),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 488,
                          child: ThemePreview(mode: themeMode),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: menu,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  static Future<void> _showAbout(BuildContext context) {
    return showAdaptiveSheet<void>(
      context,
      builder: (context) => const _AboutSheet(),
    );
  }
}

class _AboutSheet extends StatelessWidget {
  const _AboutSheet();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SheetHeader(
              title: 'Tentang aplikasi',
              onClose: () => Navigator.of(context).pop(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                children: [
                  const TsLogo(size: 56),
                  const SizedBox(height: 12),
                  Text(
                    'TumbasServis',
                    style: textTheme.titleLarge?.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ProfilState.versionLabel,
                    style: textTheme.bodyMedium?.copyWith(color: ext.textMuted),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aplikasi demo. Bengkel, harga, dan pembayaran hanya '
                    'simulasi.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(color: ext.textBody),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dibuat oleh Galah',
                    style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
