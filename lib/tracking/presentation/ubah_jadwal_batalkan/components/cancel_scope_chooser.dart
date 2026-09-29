import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class CancelScopeOption {
  const CancelScopeOption({required this.label, this.unitCode});

  final String label;

  final String? unitCode;
}

class CancelScopeChooser extends StatelessWidget {
  const CancelScopeChooser({
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
    super.key,
  });

  final List<CancelScopeOption> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      container: true,
      label: 'Cakupan pembatalan',
      child: Column(
        children: [
          for (var i = 0; i < options.length; i++)
            Semantics(
              inMutuallyExclusiveGroup: true,
              checked: i == selectedIndex,
              label: options[i].label,
              excludeSemantics: true,
              child: InkWell(
                onTap: () => onChanged(i),
                borderRadius: BorderRadius.circular(8),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 48),
                  child: Row(
                    children: [
                      Icon(
                        i == selectedIndex
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: i == selectedIndex
                            ? scheme.primary
                            : ext.textMuted,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          options[i].label,
                          style: textTheme.bodyLarge?.copyWith(
                            color: scheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
