import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/domain/service/scheduling/slot_capacity_service.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class SlotChip extends StatelessWidget {
  const SlotChip({
    required this.hour,
    required this.chipState,
    required this.remaining,
    required this.selected,
    this.onTap,
    this.onDisabledTap,
    super.key,
  });

  final int hour;
  final SlotChipState chipState;
  final int remaining;
  final bool selected;
  final VoidCallback? onTap;

  final VoidCallback? onDisabledTap;

  bool get _enabled =>
      onTap != null &&
      chipState != SlotChipState.lewat &&
      chipState != SlotChipState.full;

  String get _timeLabel => '${hour.toString().padLeft(2, '0')}.00';

  String? get _caption {
    switch (chipState) {
      case SlotChipState.limited:
      case SlotChipState.short:
        return 'Sisa $remaining motor';
      case SlotChipState.full:
        return 'Penuh';
      case SlotChipState.lewat:
        return 'Lewat';
      case SlotChipState.available:
        return null;
    }
  }

  IconData? get _icon {
    switch (chipState) {
      case SlotChipState.short:
        return Icons.error_outline_rounded;
      case SlotChipState.full:
        return Icons.block_rounded;
      case SlotChipState.lewat:
        return Icons.history_rounded;
      case SlotChipState.limited:
      case SlotChipState.available:
        return null;
    }
  }

  String get _semanticLabel {
    switch (chipState) {
      case SlotChipState.available:
        return selected ? '$_timeLabel, dipilih' : '$_timeLabel, tersedia';
      case SlotChipState.limited:
        return '$_timeLabel, sisa $remaining motor, terbatas';
      case SlotChipState.short:
        return '$_timeLabel, hanya muat $remaining motor';
      case SlotChipState.full:
        return '$_timeLabel, penuh';
      case SlotChipState.lewat:
        return '$_timeLabel, lewat';
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    final Color background;
    final Color foreground;
    final Color border;
    if (selected) {
      background = scheme.primaryContainer;
      foreground = scheme.onPrimaryContainer;
      border = ext.borderAccent;
    } else if (!_enabled) {
      background = Colors.transparent;
      foreground = ext.textFaint;
      border = ext.borderDefault;
    } else {
      background = Colors.transparent;
      foreground = ext.textBody;
      border = scheme.outline;
    }

    return Semantics(
      button: true,
      enabled: _enabled,
      selected: selected,
      label: _semanticLabel,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _enabled ? onTap : onDisabledTap,
          splashFactory: _enabled ? null : NoSplash.splashFactory,
          highlightColor: _enabled ? null : Colors.transparent,
          hoverColor: _enabled ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            constraints: const BoxConstraints(minHeight: 54),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: border, width: selected ? 2 : 1),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_icon != null) ...[
                        Icon(_icon, size: 14, color: foreground),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        _timeLabel,
                        style: textTheme.labelLarge?.copyWith(
                          color: foreground,
                        ),
                      ),
                      if (selected) ...[
                        const SizedBox(width: 4),
                        Icon(Icons.check_rounded, size: 14, color: foreground),
                      ],
                    ],
                  ),
                ),
                if (_caption != null)
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _caption!,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: textTheme.labelSmall?.copyWith(color: foreground),
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
