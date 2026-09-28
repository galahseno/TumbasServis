import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/ts_text_field.dart';
import 'package:tumbas_servis/core/presentation/utils/phone_formatter.dart';

class PhoneField extends StatefulWidget {
  const PhoneField({
    required this.digits,
    required this.onChanged,
    required this.onBlur,
    this.errorText,
    this.enabled = true,
    super.key,
  });

  final String digits;
  final ValueChanged<String> onChanged;
  final VoidCallback onBlur;
  final String? errorText;
  final bool enabled;

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: formatPhoneDisplay(widget.digits),
    );
    _focusNode = FocusNode()
      ..addListener(() {
        if (!_focusNode.hasFocus) widget.onBlur();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TsTextField(
      label: 'Nomor HP',
      controller: _controller,
      focusNode: _focusNode,
      prefixText: '+62 ',
      placeholder: '812-3456-7890',
      keyboardType: TextInputType.phone,
      enabled: widget.enabled,
      errorText: widget.errorText,
      inputFormatters: const [PhoneGroupingFormatter()],
      onChanged: (formatted) =>
          widget.onChanged(normalizePhoneDigits(formatted)),
      onSubmitted: (_) => widget.onBlur(),
    );
  }
}
