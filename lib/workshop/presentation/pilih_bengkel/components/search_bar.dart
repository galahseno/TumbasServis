import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class WorkshopSearchBar extends StatelessWidget {
  const WorkshopSearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: textTheme.bodyLarge?.copyWith(color: scheme.onSurface),
      cursorColor: ext.focusRing,
      decoration: InputDecoration(
        hintText: 'Cari nama bengkel atau area',
        hintStyle: textTheme.bodyLarge?.copyWith(color: ext.textMuted),
        prefixIcon: Icon(Icons.search_rounded, color: ext.textMuted),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close_rounded),
                color: ext.textMuted,
                tooltip: 'Hapus pencarian',
                onPressed: onClear,
              )
            : null,
        filled: true,
        fillColor: scheme.surfaceContainer,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ext.focusRing, width: 2),
        ),
      ),
    );
  }
}
