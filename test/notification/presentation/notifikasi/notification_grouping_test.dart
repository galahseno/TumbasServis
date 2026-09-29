import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbas_servis/notification/presentation/utils/notification_grouping.dart';

import '../../../support/notification_fixtures.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  test('groups the design notifications 4 / 3 / 2 in newest-first order', () {
    final groups = NotificationGrouping.group(
      designNotifications(),
      notificationsNow,
    );

    expect(groups.map((g) => g.kind), NotificationGroupKind.values);
    expect(groups.map((g) => g.items.length), [4, 3, 2]);
    expect(groups.map((g) => g.kind.label), [
      'Hari ini',
      'Minggu ini',
      'Lebih lama',
    ]);
  });

  test('empty groups are dropped', () {
    final groups = NotificationGrouping.group([
      notificationFixture('a'),
    ], notificationsNow);

    expect(groups.map((g) => g.kind), [NotificationGroupKind.hariIni]);
  });

  test('bucket boundaries are calendar days: 7 days back is still this week, '
      '8 is older, a future stamp is today', () {
    NotificationGroupKind kind(DateTime at) =>
        NotificationGrouping.kindFor(at, notificationsNow);

    expect(kind(DateTime(2026, 9, 29, 0, 1)), NotificationGroupKind.hariIni);
    expect(
      kind(DateTime(2026, 9, 28, 23, 59)),
      NotificationGroupKind.mingguIni,
    );
    expect(kind(DateTime(2026, 9, 22, 8)), NotificationGroupKind.mingguIni);
    expect(kind(DateTime(2026, 9, 21, 23)), NotificationGroupKind.lebihLama);
    expect(kind(DateTime(2026, 9, 30, 8)), NotificationGroupKind.hariIni);
  });

  test('stamps: 10.26 today, Sen 28 Sep this week, 10 Sep older', () {
    final byId = {for (final n in designNotifications()) n.id: n};
    String stamp(String id) =>
        NotificationGrouping.stamp(byId[id]!, notificationsNow);

    expect(stamp('n1'), '10.26');
    expect(stamp('n5'), 'Sen 28 Sep');
    expect(stamp('n8'), '10 Sep');
  });
}
