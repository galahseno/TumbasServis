import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class AuthLink extends StatelessWidget {
  const AuthLink({
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;

  bool get _enabled => onPressed != null;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final color = _enabled ? ext.textAccent : ext.textFaint;

    return Semantics(
      button: true,
      enabled: _enabled,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leadingIcon != null) ...[
                  Icon(leadingIcon, size: 16, color: color),
                  const SizedBox(width: 4),
                ],
                Flexible(
                  child: Text(
                    label,
                    style: textTheme.labelLarge?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                      decoration: _enabled ? TextDecoration.underline : null,
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
