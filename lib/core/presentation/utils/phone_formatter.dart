import 'package:flutter/services.dart';

List<String> groupPhoneDigits(String digits) {
  if (digits.isEmpty) return const [];
  final groups = <String>[];
  final firstLen = digits.length >= 3 ? 3 : digits.length;
  groups.add(digits.substring(0, firstLen));
  var i = firstLen;
  while (i < digits.length) {
    final len = (digits.length - i) >= 4 ? 4 : (digits.length - i);
    groups.add(digits.substring(i, i + len));
    i += len;
  }
  return groups;
}

String formatPhoneDisplay(String digits) => groupPhoneDigits(digits).join('-');

String maskPhoneDisplay(String digits) {
  final groups = groupPhoneDigits(digits);
  if (groups.length <= 2) return groups.join('-');
  for (var i = 1; i < groups.length - 1; i++) {
    groups[i] = '*' * groups[i].length;
  }
  return groups.join('-');
}

String normalizePhoneDigits(String raw) {
  var digits = raw.replaceAll(RegExp(r'\D'), '');
  if (digits.startsWith('0')) digits = digits.substring(1);
  if (digits.length > 12) digits = digits.substring(0, 12);
  return digits;
}

class PhoneGroupingFormatter extends TextInputFormatter {
  const PhoneGroupingFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = normalizePhoneDigits(newValue.text);
    final formatted = formatPhoneDisplay(digits);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
