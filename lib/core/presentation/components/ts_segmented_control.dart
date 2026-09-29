import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class TsSegment<T> {
  const TsSegment({required this.value, required this.label, this.icon});

  final T value;
  final String label;
  final IconData? icon;
}

class TsSegmentedControl<T> extends StatelessWidget {
  const TsSegmentedControl({
    required this.segments,
    required this.selected,
    required this.onChanged,
    super.key,
    this.semanticLabel,
  });

  final List<TsSegment<T>> segments;
  final T selected;
  final ValueChanged<T>? onChanged;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);

    return Semantics(
      label: semanticLabel,
      container: true,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ext.borderDefault),
        ),
        child: Row(
          children: [
            for (final segment in segments)
              Expanded(
                child: _Segment<T>(
                  segment: segment,
                  isSelected: segment.value == selected,
                  onTap: onChanged == null
                      ? null
                      : () => onChanged!(segment.value),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Segment<T> extends StatefulWidget {
  const _Segment({
    required this.segment,
    required this.isSelected,
    required this.onTap,
  });

  final TsSegment<T> segment;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  State<_Segment<T>> createState() => _SegmentState<T>();
}

class _SegmentState<T> extends State<_Segment<T>> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final selected = widget.isSelected;
    final foreground = selected ? scheme.onPrimary : ext.textBody;
    final duration = MediaQuery.of(context).disableAnimations
        ? Duration.zero
        : const Duration(milliseconds: 150);

    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      button: true,
      enabled: widget.onTap != null,
      label: widget.segment.label,
      excludeSemantics: true,
      onTap: widget.onTap,
      child: Focus(
        onFocusChange: (value) => setState(() => _focused = value),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: duration,
            constraints: const BoxConstraints(minHeight: 48),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? ext.accent : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: _focused
                  ? Border.all(color: ext.focusRing, width: 2)
                  : null,
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.segment.icon != null) ...[
                  Icon(widget.segment.icon, size: 18, color: foreground),
                  const SizedBox(width: 6),
                ],
                Flexible(
                  child: Text(
                    widget.segment.label,
                    textAlign: TextAlign.center,
                    style: textTheme.labelLarge?.copyWith(
                      color: foreground,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
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
