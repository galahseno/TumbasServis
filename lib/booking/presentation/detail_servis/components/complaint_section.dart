import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/presentation/components/ts_chip.dart';
import 'package:tumbas_servis/core/presentation/components/ts_icon_button.dart';
import 'package:tumbas_servis/core/presentation/components/ts_text_field.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

const complaintPresets = [
  'Rem bunyi',
  'Getar',
  'Mesin brebet',
  'Susah hidup',
  'Oli merembes',
  'Lampu mati',
];

class ComplaintSection extends StatefulWidget {
  const ComplaintSection({
    required this.expanded,
    required this.required,
    required this.initialNote,
    required this.onExpand,
    required this.onChanged,
    super.key,
    this.errorText,
  });

  final bool expanded;
  final bool required;
  final String? initialNote;
  final String? errorText;
  final VoidCallback onExpand;
  final ValueChanged<String> onChanged;

  @override
  State<ComplaintSection> createState() => _ComplaintSectionState();
}

class _ComplaintSectionState extends State<ComplaintSection> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialNote,
  );
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _applyPreset(String preset) {
    _controller.text = preset;
    widget.onChanged(preset);
  }

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    if (!widget.expanded) {
      return InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: widget.onExpand,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(Icons.add_rounded, size: 18, color: ext.textAccent),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  '+ Tambah keluhan (opsional)',
                  style: textTheme.labelLarge?.copyWith(color: ext.textAccent),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Keluhan',
                    style: textTheme.labelLarge?.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                  if (!widget.required) ...[
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '(opsional)',
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          color: ext.textMuted,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (!widget.required)
              TsIconButton(
                icon: Icons.expand_less_rounded,
                onPressed: widget.onExpand,
                semanticLabel: 'Sembunyikan keluhan',
              ),
          ],
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final preset in complaintPresets)
              TsChip(
                label: preset,
                selected: _controller.text.trim() == preset,
                onSelected: (_) => setState(() => _applyPreset(preset)),
              ),
            TsChip(
              label: 'Lainnya',
              selected: false,
              onSelected: (_) => _focusNode.requestFocus(),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TsTextField(
          label: 'Detail keluhan',
          controller: _controller,
          focusNode: _focusNode,
          maxLines: 3,
          maxLength: UnitConfig.complaintNoteMaxLength,
          errorText: widget.errorText,
          placeholder: 'Ceritakan keluhan motor',
          onChanged: (value) {
            setState(() {});
            widget.onChanged(value);
          },
        ),
      ],
    );
  }
}
