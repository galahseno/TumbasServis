// Self-check for assets/mock/*.json: valid JSON, right counts, right
// cross-references, right enum spellings. No Flutter/pub deps — run with
// `dart run tool/validate_mock_json.dart`.
import 'dart:convert';
import 'dart:io';

const mockDir = 'assets/mock';

const expectedCounts = {
  'motor_models.json': 16,
  'garage_seed.json': 4,
  'workshops.json': 5,
  'services.json': 3,
  'parts.json': 14,
  'vouchers.json': 4,
  'mechanics.json': 6,
  'notifications_seed.json': 9,
  'bookings_seed.json': 4,
};

const brandValues = {'Honda', 'Yamaha', 'Suzuki', 'Kawasaki'};
const categoryValues = {'matic', 'bebek', 'sport'};
const discountTypeValues = {'percent', 'flat'};
const unitStatusValues = {
  'terjadwal',
  'checkIn',
  'diperiksa',
  'dikerjakan',
  'qc',
  'selesai',
  'dibatalkan',
};
const bookingStatusValues = {
  'terjadwal',
  'berlangsung',
  'selesai',
  'dibatalkan',
};
const notificationCategoryValues = {'status', 'promo', 'reminder'};
const scheduleModeValues = {'shared', 'split'};

int errorCount = 0;

void fail(String message) {
  errorCount++;
  stderr.writeln('FAIL: $message');
}

dynamic loadJson(String fileName) {
  final file = File('$mockDir/$fileName');
  if (!file.existsSync()) {
    fail('$fileName does not exist');
    return null;
  }
  try {
    return jsonDecode(file.readAsStringSync());
  } on FormatException catch (e) {
    fail('$fileName is not valid JSON: $e');
    return null;
  }
}

void checkCount(String fileName, List list) {
  final expected = expectedCounts[fileName];
  if (expected != null && list.length != expected) {
    fail('$fileName has ${list.length} entries, expected $expected');
  }
}

void checkEnum(
  String fileName,
  String field,
  String value,
  Set<String> allowed,
) {
  if (!allowed.contains(value)) {
    fail('$fileName: $field="$value" is not one of $allowed');
  }
}

void main() {
  final user = loadJson('user.json');
  final motorModels = loadJson('motor_models.json') as List?;
  final garageSeed = loadJson('garage_seed.json') as List?;
  final workshops = loadJson('workshops.json') as List?;
  final services = loadJson('services.json') as List?;
  final parts = loadJson('parts.json') as List?;
  final vouchers = loadJson('vouchers.json') as List?;
  final promos = loadJson('promos.json') as List?;
  final mechanics = loadJson('mechanics.json') as List?;
  final notifications = loadJson('notifications_seed.json') as List?;
  final bookings = loadJson('bookings_seed.json') as List?;

  if (user == null ||
      motorModels == null ||
      garageSeed == null ||
      workshops == null ||
      services == null ||
      parts == null ||
      vouchers == null ||
      promos == null ||
      mechanics == null ||
      notifications == null ||
      bookings == null) {
    stderr.writeln(
      'One or more files failed to load; aborting further checks.',
    );
    exit(1);
  }

  checkCount('motor_models.json', motorModels);
  checkCount('garage_seed.json', garageSeed);
  checkCount('workshops.json', workshops);
  checkCount('services.json', services);
  checkCount('parts.json', parts);
  checkCount('vouchers.json', vouchers);
  checkCount('mechanics.json', mechanics);
  checkCount('notifications_seed.json', notifications);
  checkCount('bookings_seed.json', bookings);

  final unreadCount = notifications.where((n) => n['read'] == false).length;
  if (unreadCount != 2) {
    fail('notifications_seed.json has $unreadCount unread, expected 2');
  }

  final modelIds = motorModels.map((m) => m['id'] as String).toSet();
  final motorIds = garageSeed.map((m) => m['id'] as String).toSet();
  final workshopIds = workshops.map((w) => w['id'] as String).toSet();
  final serviceIds = services.map((s) => s['id'] as String).toSet();
  final partIds = parts.map((p) => p['id'] as String).toSet();
  final voucherIds = vouchers.map((v) => v['id'] as String).toSet();
  final mechanicIds = mechanics.map((m) => m['id'] as String).toSet();

  for (final m in motorModels) {
    checkEnum('motor_models.json', 'brand', m['brand'], brandValues);
    checkEnum('motor_models.json', 'category', m['category'], categoryValues);
  }

  for (final m in garageSeed) {
    if (!modelIds.contains(m['model_id'])) {
      fail(
        'garage_seed.json: model_id "${m['model_id']}" not found in motor_models.json',
      );
    }
  }

  for (final w in workshops) {
    for (final sid in (w['service_ids'] as List)) {
      if (!serviceIds.contains(sid)) {
        fail(
          'workshops.json (${w['id']}): service_id "$sid" not found in services.json',
        );
      }
    }
  }

  for (final p in parts) {
    for (final mid in (p['compatible_model_ids'] as List)) {
      if (!modelIds.contains(mid)) {
        fail(
          'parts.json (${p['id']}): compatible model_id "$mid" not found in motor_models.json',
        );
      }
    }
  }

  for (final v in vouchers) {
    checkEnum(
      'vouchers.json',
      'discount_type',
      v['discount_type'],
      discountTypeValues,
    );
  }

  for (final n in notifications) {
    checkEnum(
      'notifications_seed.json',
      'category',
      n['category'],
      notificationCategoryValues,
    );
    final deepLink = n['deep_link'] as String?;
    if (deepLink != null && deepLink.contains('voucherId=')) {
      final vid = deepLink.split('voucherId=').last.split('&').first;
      if (!voucherIds.contains(vid)) {
        fail(
          'notifications_seed.json (${n['id']}): deep_link references unknown voucherId "$vid"',
        );
      }
    }
    if (deepLink != null && deepLink.contains('motorId=')) {
      final mid = deepLink.split('motorId=').last.split('&').first;
      if (!motorIds.contains(mid)) {
        fail(
          'notifications_seed.json (${n['id']}): deep_link references unknown motorId "$mid"',
        );
      }
    }
  }

  for (final b in bookings) {
    if (!workshopIds.contains(b['workshop_id'])) {
      fail(
        'bookings_seed.json (${b['id']}): workshop_id "${b['workshop_id']}" not found in workshops.json',
      );
    }
    checkEnum('bookings_seed.json', 'status', b['status'], bookingStatusValues);
    checkEnum(
      'bookings_seed.json',
      'schedule_mode',
      b['schedule_mode'],
      scheduleModeValues,
    );
    for (final u in (b['units'] as List)) {
      if (!motorIds.contains(u['motor_id'])) {
        fail(
          'bookings_seed.json (${b['id']} ${u['unit_code']}): motor_id "${u['motor_id']}" not found in garage_seed.json',
        );
      }
      for (final sid in (u['service_ids'] as List? ?? const [])) {
        if (!serviceIds.contains(sid)) {
          fail(
            'bookings_seed.json (${b['id']} ${u['unit_code']}): service_id "$sid" not found in services.json',
          );
        }
      }
      for (final pid in (u['part_ids'] as List? ?? const [])) {
        if (!partIds.contains(pid)) {
          fail(
            'bookings_seed.json (${b['id']} ${u['unit_code']}): part_id "$pid" not found in parts.json',
          );
        }
      }
      final mechId = u['mechanic_id'] as String?;
      if (mechId != null && !mechanicIds.contains(mechId)) {
        fail(
          'bookings_seed.json (${b['id']} ${u['unit_code']}): mechanic_id "$mechId" not found in mechanics.json',
        );
      }
      checkEnum(
        'bookings_seed.json',
        'unit status',
        u['status'],
        unitStatusValues,
      );
      for (final ev in (u['status_history'] as List)) {
        checkEnum(
          'bookings_seed.json',
          'status_history status',
          ev['status'],
          unitStatusValues,
        );
      }
    }
  }

  if (errorCount == 0) {
    stdout.writeln(
      'OK: all ${expectedCounts.length + 2} mock files valid, counts and cross-references correct.',
    );
  } else {
    stderr.writeln('$errorCount error(s) found.');
    exit(1);
  }
}
