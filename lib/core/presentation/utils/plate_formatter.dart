import 'package:flutter/services.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor.dart';

class PlateNumberFormatter extends TextInputFormatter {
  const PlateNumberFormatter();

  static const int maxLength = 11;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final cleaned = newValue.text.toUpperCase().replaceAll(
      RegExp(r'[^A-Z0-9]'),
      '',
    );
    final formatted = Motor.formatPlateNumber(cleaned);
    final bounded = formatted.length > maxLength
        ? formatted.substring(0, maxLength)
        : formatted;
    return TextEditingValue(
      text: bounded,
      selection: TextSelection.collapsed(offset: bounded.length),
    );
  }
}
