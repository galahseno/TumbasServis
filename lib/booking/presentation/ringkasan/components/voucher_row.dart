import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

enum VoucherRowVariant { empty, applied, loading }

class VoucherRow extends StatelessWidget {
  const VoucherRow({
    required this.variant,
    super.key,
    this.titleText,
    this.captionText,
    this.savingText,
    this.onTap,
    this.onHapus,
  });

  final VoucherRowVariant variant;
  final String? titleText;
  final String? captionText;
  final String? savingText;
  final VoidCallback? onTap;
  final VoidCallback? onHapus;

  @override
  Widget build(BuildContext context) {
    if (variant == VoucherRowVariant.loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: SkeletonBlock(height: 64),
      );
    }

    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isApplied = variant == VoucherRowVariant.applied;

    final semanticsLabel = isApplied
        ? '$titleText, $savingText'
        : '${titleText ?? 'Pilih voucher'}${captionText != null ? ', $captionText' : ''}';

    return Semantics(
      button: true,
      label: semanticsLabel,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: ext.borderDefault),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.confirmation_number_outlined,
                    size: 20,
                    color: ext.textBody,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ExcludeSemantics(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          titleText ?? 'Pilih voucher',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurface,
                          ),
                        ),
                        if (isApplied && savingText != null)
                          Text(
                            savingText!,
                            style: textTheme.bodySmall?.copyWith(
                              color: ext.successText,
                            ),
                          )
                        else if (captionText != null)
                          Text(
                            captionText!,
                            style: textTheme.bodySmall?.copyWith(
                              color: ext.textMuted,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (isApplied)
                  SizedBox(
                    height: 48,
                    child: Center(
                      child: Semantics(
                        button: true,
                        label: 'Hapus voucher',
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: onHapus,
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: ExcludeSemantics(
                                child: Text(
                                  'Hapus',
                                  style: textTheme.labelLarge?.copyWith(
                                    color: ext.textAccent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  Icon(Icons.chevron_right_rounded, color: ext.textMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
