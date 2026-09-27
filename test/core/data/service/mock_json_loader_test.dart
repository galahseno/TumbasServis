import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/data/service/mock_json_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const mockFiles = [
    'user.json',
    'motor_models.json',
    'garage_seed.json',
    'workshops.json',
    'services.json',
    'parts.json',
    'vouchers.json',
    'promos.json',
    'mechanics.json',
    'notifications_seed.json',
    'bookings_seed.json',
  ];

  test('loads and parses each of the 11 mock files without error', () async {
    final loader = MockJsonLoader();
    for (final file in mockFiles) {
      final decoded = await loader.load(file);
      expect(decoded, isNotNull, reason: '$file failed to parse');
    }
  });

  test('a second load for the same file returns the cached instance', () async {
    final loader = MockJsonLoader();
    final first = await loader.load('user.json');
    final second = await loader.load('user.json');
    expect(identical(first, second), isTrue);
  });
}
