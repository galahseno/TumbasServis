import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/presentation/components/sheet_header.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/core/presentation/utils/currency_formatter.dart';

import 'package:tumbas_servis/catalog/presentation/katalog/components/compat_row.dart';

class PartDetailCompatRowData {
  const PartDetailCompatRowData({
    required this.label,
    required this.compatible,
  });

  final String label;
  final bool compatible;
}

class PartDetailSheet extends StatelessWidget {
  const PartDetailSheet({
    required this.part,
    required this.ruleLine,
    required this.compatRows,
    required this.selectMode,
    super.key,
    this.selected = false,
    this.compatible = true,
    this.incompatibleReason,
    this.onToggle,
  });

  final Part part;
  final String ruleLine;
  final List<PartDetailCompatRowData> compatRows;
  final bool selectMode;
  final bool selected;
  final bool compatible;
  final String? incompatibleReason;
  final ValueChanged<bool>? onToggle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SheetHeader(
              title: part.name,
              onClose: () => Navigator.of(context).pop(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    '${part.brand} ${part.grade}',
                    style: textTheme.bodyMedium?.copyWith(color: ext.textMuted),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    CurrencyFormatter.format(part.price),
                    style: textTheme.titleLarge?.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (ruleLine.isNotEmpty)
                    Text(
                      'Cocok untuk $ruleLine',
                      style: textTheme.bodyMedium?.copyWith(
                        color: ext.textBody,
                      ),
                    ),
                  const SizedBox(height: 4),
                  for (final row in compatRows)
                    CompatRow(label: row.label, compatible: row.compatible),
                  if (selectMode) ...[
                    const SizedBox(height: 20),
                    if (!compatible && incompatibleReason != null) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 16,
                            color: ext.warning,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              incompatibleReason!,
                              style: textTheme.bodySmall?.copyWith(
                                color: ext.warningText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    TsButton(
                      label: selected
                          ? 'Hapus dari booking'
                          : 'Tambah ke booking',
                      type: selected
                          ? TsButtonType.dangerOutline
                          : TsButtonType.primary,
                      onPressed: (compatible && onToggle != null)
                          ? () => onToggle!(!selected)
                          : null,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
