import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';

class OtpInput extends StatefulWidget {
  const OtpInput({
    required this.value,
    required this.onChanged,
    this.length = 6,
    this.isError = false,
    this.enabled = true,
    super.key,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final int length;
  final bool isError;
  final bool enabled;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  String _charAt(String s, int i) => i < s.length ? s[i] : '';

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (i) => TextEditingController(text: _charAt(widget.value, i)),
    );
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void didUpdateWidget(covariant OtpInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      for (var i = 0; i < widget.length; i++) {
        final ch = _charAt(widget.value, i);
        if (_controllers[i].text != ch) _controllers[i].text = ch;
      }
      if (widget.value.isEmpty && oldWidget.value.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _focusNodes[0].requestFocus();
        });
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _emit() => widget.onChanged(_controllers.map((c) => c.text).join());

  void _handleChanged(int index, String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 1) {
      var cursor = index;
      for (final d in digits.split('')) {
        if (cursor >= widget.length) break;
        _controllers[cursor].text = d;
        cursor++;
      }
      _emit();
      _focusNodes[cursor < widget.length ? cursor : widget.length - 1]
          .requestFocus();
      return;
    }
    _controllers[index].text = digits;
    _emit();
    if (digits.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _handleBackspace(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].text = '';
      _emit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) {
        final filled = _controllers[index].text.isNotEmpty;
        return SizedBox(
          width: 48,
          height: 56,
          child: Semantics(
            label: 'Digit ${index + 1} dari ${widget.length}',
            child: Focus(
              onKeyEvent: (node, event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.backspace) {
                  _handleBackspace(index);
                }
                return KeyEventResult.ignored;
              },
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                enabled: widget.enabled,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLengthEnforcement: MaxLengthEnforcement.none,
                onTap: () => _controllers[index].selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _controllers[index].text.length,
                ),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: scheme.onSurface),
                onChanged: (v) => _handleChanged(index, v),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: widget.enabled
                      ? scheme.surfaceContainer
                      : scheme.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: widget.isError
                          ? ext.danger
                          : filled
                          ? ext.borderStrong
                          : scheme.outline,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: widget.isError
                          ? ext.danger
                          : filled
                          ? ext.borderStrong
                          : scheme.outline,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: widget.isError ? ext.danger : ext.focusRing,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
