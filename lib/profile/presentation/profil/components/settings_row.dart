import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/ts_switch.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class SettingsRow extends StatefulWidget {
  const SettingsRow({
    required this.icon,
    required this.title,
    super.key,
    this.subtitle,
    this.onTap,
    this.showChevron = false,
    this.tag,
    this.switchValue,
    this.onSwitchChanged,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool showChevron;

  final String? tag;

  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged;

  @override
  State<SettingsRow> createState() => _SettingsRowState();
}

class _SettingsRowState extends State<SettingsRow> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isSwitch = widget.switchValue != null;
    final onTap = isSwitch
        ? () => widget.onSwitchChanged?.call(!widget.switchValue!)
        : widget.onTap;

    return Semantics(
      button: !isSwitch,
      toggled: isSwitch ? widget.switchValue : null,
      label: [
        widget.title,
        if (widget.tag != null) widget.tag!,
        if (widget.subtitle != null) widget.subtitle!,
      ].join('. '),
      excludeSemantics: true,
      onTap: onTap,
      child: Focus(
        onFocusChange: (value) => setState(() => _focused = value),
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 64),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: _focused
                  ? Border.all(color: ext.focusRing, width: 2)
                  : null,
            ),
            child: Row(
              children: [
                Icon(widget.icon, size: 24, color: ext.textBody),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        children: [
                          Text(
                            widget.title,
                            style: textTheme.titleSmall?.copyWith(
                              color: scheme.onSurface,
                            ),
                          ),
                          if (widget.tag != null) _Tag(label: widget.tag!),
                        ],
                      ),
                      if (widget.subtitle != null)
                        Text(
                          widget.subtitle!,
                          style: textTheme.bodySmall?.copyWith(
                            color: ext.textMuted,
                          ),
                        ),
                    ],
                  ),
                ),
                if (isSwitch)
                  ExcludeSemantics(
                    child: TsSwitch(
                      value: widget.switchValue!,
                      onChanged: widget.onSwitchChanged,
                    ),
                  )
                else if (widget.showChevron)
                  Icon(Icons.chevron_right_rounded, color: ext.textMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: ext.borderDefault),
      ),
      child: Text(
        label,
        style: textTheme.labelSmall?.copyWith(color: ext.textMuted),
      ),
    );
  }
}
