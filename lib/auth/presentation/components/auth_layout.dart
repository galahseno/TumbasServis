import 'package:flutter/material.dart';
import 'package:tumbas_servis/auth/presentation/components/auth_hero.dart';
import 'package:tumbas_servis/core/presentation/components/ts_app_bar.dart';
import 'package:tumbas_servis/core/presentation/components/ts_icon_button.dart';
import 'package:tumbas_servis/core/presentation/components/ts_logo.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/core/presentation/utils/window_size_class.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({
    required this.form,
    this.footer,
    this.showBack = false,
    this.showLogo = false,
    super.key,
  });

  final Widget form;
  final Widget? footer;
  final bool showBack;
  final bool showLogo;

  static const _formMaxWidth = 480.0;

  @override
  Widget build(BuildContext context) {
    final sizeClass = context.windowSizeClass;
    if (sizeClass.isAtLeast(WindowSizeClass.expanded)) {
      return _buildSplit(context);
    }
    if (sizeClass == WindowSizeClass.medium) return _buildCard(context);
    return _buildCompact(context);
  }

  Widget _buildCompact(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: showBack ? TsAppBar.back(title: '') : null,
      body: SafeArea(
        top: !showBack,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24, showBack ? 8 : 24, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showLogo) ...[
                      const TsLogo(markOnly: false, size: 40),
                      const SizedBox(height: 32),
                    ],
                    form,
                  ],
                ),
              ),
            ),
            if (footer != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: footer,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: showBack ? TsAppBar.back(title: '') : null,
      body: SafeArea(
        top: !showBack,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _formMaxWidth),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: ext.borderDefault),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showLogo) ...[
                      const TsLogo(markOnly: false, size: 40),
                      const SizedBox(height: 32),
                    ],
                    form,
                    if (footer != null) ...[
                      const SizedBox(height: 24),
                      footer!,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSplit(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      body: Row(
        children: [
          Expanded(
            child: SafeArea(
              child: Stack(
                children: [
                  Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        40,
                        showBack ? 72 : 24,
                        40,
                        24,
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: _formMaxWidth,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            form,
                            if (footer != null) ...[
                              const SizedBox(height: 24),
                              footer!,
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (showBack)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: TsIconButton(
                        icon: Icons.arrow_back_rounded,
                        semanticLabel: 'Kembali',
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const Expanded(child: AuthHero()),
        ],
      ),
    );
  }
}
