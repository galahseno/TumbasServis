// ignore_for_file: prefer_initializing_formals
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/data/service/mock_json_loader.dart';

class BookingCodeGenerator {
  BookingCodeGenerator({
    required LocalStore localStore,
    required MockJsonLoader mockJsonLoader,
  }) : _localStore = localStore,
       _mockJsonLoader = mockJsonLoader;

  final LocalStore _localStore;
  final MockJsonLoader _mockJsonLoader;

  static const _counterBox = 'booking_code_counters';

  Future<String> next(DateTime referenceDate) async {
    await _ensureCountersSeeded();
    final yymmdd = _formatYyMmDd(referenceDate);
    final row = await _localStore.get(_counterBox, yymmdd);
    final next = ((row?['last'] as int?) ?? 0) + 1;
    await _localStore.put(_counterBox, yymmdd, {'last': next});
    return 'TS-$yymmdd-${next.toString().padLeft(4, '0')}';
  }

  Future<void> _ensureCountersSeeded() async {
    final existing = await _localStore.getAll(_counterBox);
    if (existing.isNotEmpty) return;
    final json =
        await _mockJsonLoader.load('bookings_seed.json') as List<dynamic>;
    final counters = <String, int>{};
    for (final row in json.cast<Map<String, dynamic>>()) {
      final code = row['code'] as String;
      final parts = code.split('-');
      final yymmdd = parts[1];
      final n = int.parse(parts[2]);
      final current = counters[yymmdd];
      if (current == null || n > current) counters[yymmdd] = n;
    }
    counters['260929'] = 416;
    for (final entry in counters.entries) {
      await _localStore.put(_counterBox, entry.key, {'last': entry.value});
    }
  }

  String _formatYyMmDd(DateTime date) {
    final yy = (date.year % 100).toString().padLeft(2, '0');
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    return '$yy$mm$dd';
  }
}
