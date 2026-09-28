import 'package:flutter/material.dart';
import 'package:tumbas_servis/booking/presentation/utils/unit_config_display.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class VehicleTabChip extends StatefulWidget {
  const VehicleTabChip({
    required this.label,
    required this.status,
    required this.active,
    required this.semanticLabel,
    super.key,
    this.onTap,
  });

  final String label;
  final UnitChipStatus status;
  final bool active;
  final String semanticLabel;
  final VoidCallback? onTap;

  @override
  State<VehicleTabChip> createState() => _VehicleTabChipState();
}

class _VehicleTabChipState extends State<VehicleTabChip> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    final Color glyphColor;
    final IconData glyphIcon;
    switch (widget.status) {
      case UnitChipStatus.complete:
        glyphColor = ext.success;
        glyphIcon = Icons.check_circle_rounded;
      case UnitChipStatus.error:
        glyphColor = ext.danger;
        glyphIcon = Icons.error_rounded;
      case UnitChipStatus.incomplete:
        glyphColor = ext.textFaint;
        glyphIcon = Icons.radio_button_unchecked_rounded;
    }

    final background = widget.active
        ? scheme.primaryContainer
        : Colors.transparent;
    final foreground = widget.active ? scheme.onPrimaryContainer : ext.textBody;
    final border = widget.status == UnitChipStatus.error
        ? ext.danger
        : (widget.active ? ext.borderAccent : ext.borderDefault);

    return Semantics(
      button: true,
      selected: widget.active,
      label: widget.semanticLabel,
      child: SizedBox(
        height: 48,
        child: Focus(
          onFocusChange: (value) => setState(() => _focused = value),
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: widget.onTap,
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: _focused ? ext.focusRing : border,
                      width: _focused || widget.active ? 2 : 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(glyphIcon, size: 16, color: glyphColor),
                      const SizedBox(width: 6),
                      Text(
                        widget.label,
                        style: textTheme.labelLarge?.copyWith(
                          color: foreground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
