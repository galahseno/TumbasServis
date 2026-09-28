import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

enum ErrorStateLayout { inline, fullPage }

class ErrorState extends StatelessWidget {
  const ErrorState({
    required this.message,
    required this.onRetry,
    super.key,
    this.layout = ErrorStateLayout.inline,
    this.illustration,
  });

  final String message;
  final VoidCallback onRetry;
  final ErrorStateLayout layout;
  final Widget? illustration;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isFullPage = layout == ErrorStateLayout.fullPage;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        illustration ??
            Icon(
              Icons.error_outline_rounded,
              size: isFullPage ? 56 : 40,
              color: ext.danger,
            ),
        const SizedBox(height: 16),
        Text(
          message,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
        ),
        const SizedBox(height: 16),
        TsButton(
          label: 'Coba lagi',
          onPressed: onRetry,
          type: TsButtonType.outline,
          fullWidth: false,
          compact: true,
        ),
      ],
    );

    if (!isFullPage) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: scheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ext.borderDefault),
        ),
        child: content,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: content,
    );
  }
}
