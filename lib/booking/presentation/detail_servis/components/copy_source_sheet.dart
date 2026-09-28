import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/sheet_header.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class CopySourceCandidate {
  const CopySourceCandidate({
    required this.motorId,
    required this.nickname,
    required this.plateNumber,
  });

  final String motorId;
  final String nickname;
  final String plateNumber;
}

Future<String?> showCopySourceSheet(
  BuildContext context, {
  required List<CopySourceCandidate> candidates,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _CopySourceSheet(candidates: candidates),
  );
}

class _CopySourceSheet extends StatelessWidget {
  const _CopySourceSheet({required this.candidates});

  final List<CopySourceCandidate> candidates;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SheetHeader(
            title: 'Salin dari motor mana?',
            onClose: () => Navigator.of(context).pop(),
          ),
          const SizedBox(height: 8),
          for (final candidate in candidates)
            _CopySourceRow(
              candidate: candidate,
              onTap: () => Navigator.of(context).pop(candidate.motorId),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: ext.textMuted,
                ),
                const SizedBox(width: 6),
                Text(
                  'Keluhan tidak ikut disalin',
                  style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CopySourceRow extends StatefulWidget {
  const _CopySourceRow({required this.candidate, required this.onTap});

  final CopySourceCandidate candidate;
  final VoidCallback onTap;

  @override
  State<_CopySourceRow> createState() => _CopySourceRowState();
}

class _CopySourceRowState extends State<_CopySourceRow> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Focus(
      onFocusChange: (value) => setState(() => _focused = value),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: _focused
                ? BoxDecoration(
                    border: Border.all(color: ext.focusRing, width: 2),
                  )
                : null,
            child: Row(
              children: [
                Icon(Icons.two_wheeler_rounded, size: 20, color: ext.textFaint),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.candidate.nickname,
                        style: textTheme.bodyLarge?.copyWith(
                          color: scheme.onSurface,
                        ),
                      ),
                      Text(
                        widget.candidate.plateNumber,
                        style: textTheme.bodySmall?.copyWith(
                          color: ext.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
