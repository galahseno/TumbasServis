import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/presentation/utils/plate_formatter.dart';

String _format(String typed) => const PlateNumberFormatter()
    .formatEditUpdate(TextEditingValue.empty, TextEditingValue(text: typed))
    .text;

void main() {
  test('uppercases and spaces a plate as typed', () {
    expect(_format('ab1234xy'), 'AB 1234 XY');
    expect(_format('ab1'), 'AB 1');
    expect(_format('ab 1234'), 'AB 1234');
  });

  test('strips characters that are not letters or digits', () {
    expect(_format('ab-12.34 xy'), 'AB 1234 XY');
  });

  test('caps the length at 11 characters', () {
    expect(_format('ab1234xyzzzz').length, lessThanOrEqualTo(11));
  });

  test('leaves shapeless partial input unspaced', () {
    expect(_format('a'), 'A');
    expect(_format('1'), '1');
  });
}
