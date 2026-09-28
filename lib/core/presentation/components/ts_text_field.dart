import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class TsTextField extends StatelessWidget {
  const TsTextField({
    required this.label,
    super.key,
    this.controller,
    this.onChanged,
    this.placeholder,
    this.prefixText,
    this.suffixIcon,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
  });

  final String label;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? placeholder;
  final String? prefixText;
  final IconData? suffixIcon;
  final String? helperText;
  final String? errorText;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final hasError = errorText != null;
    final radius = BorderRadius.circular(12);

    OutlineInputBorder border(Color color, {double width = 1}) =>
        OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: color, width: width),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelLarge?.copyWith(color: scheme.onSurface),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          enabled: enabled,
          maxLines: maxLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          style: textTheme.bodyLarge?.copyWith(
            color: enabled ? scheme.onSurface : ext.textFaint,
          ),
          cursorColor: ext.focusRing,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: textTheme.bodyLarge?.copyWith(color: ext.textMuted),
            prefixText: prefixText,
            prefixStyle: textTheme.bodyLarge?.copyWith(color: scheme.onSurface),
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, color: ext.textMuted)
                : null,
            filled: true,
            fillColor: enabled
                ? scheme.surfaceContainer
                : scheme.surfaceContainerLow,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: border(scheme.outline),
            enabledBorder: border(hasError ? ext.danger : scheme.outline),
            focusedBorder: border(
              hasError ? ext.danger : ext.focusRing,
              width: 2,
            ),
            disabledBorder: border(ext.borderDefault),
            errorBorder: border(ext.danger),
            focusedErrorBorder: border(ext.danger, width: 2),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.error_outline_rounded, size: 16, color: ext.danger),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  errorText!,
                  style: textTheme.bodySmall?.copyWith(color: ext.dangerText),
                ),
              ),
            ],
          ),
        ] else if (helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            helperText!,
            style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
          ),
        ],
      ],
    );
  }
}
