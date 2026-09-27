import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';

void main() {
  group('Result', () {
    test('Result.ok wraps the value', () {
      const result = Result<int>.ok(42);

      expect(result, isA<Ok<int>>());
      expect((result as Ok<int>).value, 42);
    });

    test('Result.error wraps the exception', () {
      final exception = Exception('boom');
      final result = Result<int>.error(exception);

      expect(result, isA<Error<int>>());
      expect((result as Error<int>).error, exception);
    });

    test('switch matches the ok branch exhaustively', () {
      const result = Result<String>.ok('hello');

      final matched = switch (result) {
        Ok(value: final value) => value,
        Error() => null,
      };

      expect(matched, 'hello');
    });

    test('switch matches the error branch exhaustively', () {
      final exception = Exception('boom');
      final result = Result<String>.error(exception);

      final matched = switch (result) {
        Ok() => null,
        Error(error: final error) => error,
      };

      expect(matched, exception);
    });
  });
}
