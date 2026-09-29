import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    required this.workshopName,
    required this.jadwalLine,
    required this.onUbahBengkel,
    required this.onUbahJadwal,
    super.key,
    this.jadwalInvalid = false,
  });

  final String workshopName;
  final String jadwalLine;
  final VoidCallback onUbahBengkel;
  final VoidCallback onUbahJadwal;
  final bool jadwalInvalid;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: jadwalInvalid ? ext.warning : ext.borderDefault,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _SummaryRow(
            label: 'Bengkel',
            value: workshopName,
            ubahLabel: 'Ubah bengkel',
            onUbah: onUbahBengkel,
          ),
          Divider(
            height: 1,
            color: ext.borderDefault,
            indent: 16,
            endIndent: 16,
          ),
          _SummaryRow(
            label: 'Jadwal',
            value: jadwalInvalid ? 'Jam tidak tersedia' : jadwalLine,
            ubahLabel: 'Ubah jadwal',
            onUbah: onUbahJadwal,
            warning: jadwalInvalid,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.ubahLabel,
    required this.onUbah,
    this.warning = false,
  });

  final String label;
  final String value;
  final String ubahLabel;
  final VoidCallback onUbah;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final valueColor = warning ? ext.warningText : scheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: textTheme.labelSmall?.copyWith(color: ext.textMuted),
                ),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (warning) ...[
                      Icon(
                        Icons.error_outline_rounded,
                        size: 16,
                        color: ext.warningText,
                      ),
                      const SizedBox(width: 4),
                    ],
                    Expanded(
                      child: Text(
                        value,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(
                          color: valueColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 48,
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onUbah,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      ubahLabel,
                      style: textTheme.labelLarge?.copyWith(
                        color: ext.textAccent,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
