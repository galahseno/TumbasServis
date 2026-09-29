import 'package:flutter/material.dart';
import 'package:tumbas_servis/booking/presentation/ringkasan/components/payment_note.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class ConfirmPane extends StatelessWidget {
  const ConfirmPane({
    required this.voucherRow,
    required this.estimate,
    required this.ctaLabel,
    required this.enabled,
    required this.isLoading,
    required this.onConfirm,
    this.loadingLabel,
    this.reasonLine,
    super.key,
  });

  final Widget voucherRow;
  final Widget estimate;
  final String ctaLabel;
  final String? loadingLabel;
  final bool enabled;
  final bool isLoading;
  final VoidCallback onConfirm;
  final String? reasonLine;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ext.borderDefault),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [voucherRow, estimate, const PaymentNote()],
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: ext.borderDefault)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (reasonLine != null) ...[
                      Semantics(
                        liveRegion: true,
                        child: Text(
                          reasonLine!,
                          textAlign: TextAlign.center,
                          style: textTheme.bodySmall?.copyWith(
                            color: ext.textMuted,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    TsButton(
                      label: ctaLabel,
                      loadingLabel: loadingLabel,
                      isLoading: isLoading,
                      onPressed: (enabled && !isLoading) ? onConfirm : null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
