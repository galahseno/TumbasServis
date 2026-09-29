import 'package:tumbas_servis/core/domain/model/notification/app_notification.dart';

/// "Now" of the design: Tue 29 Sep 2026, 10.30.
final notificationsNow = DateTime(2026, 9, 29, 10, 30);

AppNotification notificationFixture(
  String id, {
  NotificationCategory category = NotificationCategory.status,
  String title = 'Judul',
  String body = 'Isi',
  DateTime? at,
  bool read = false,
  String? deepLink,
}) => AppNotification(
  id: id,
  category: category,
  title: title,
  body: body,
  timestamp: at ?? notificationsNow,
  read: read,
  deepLink: deepLink,
);

/// The nine S06 notifications (2 unread) from design step 18.
List<AppNotification> designNotifications() => [
  notificationFixture(
    'n1',
    title: 'PCX 160 sedang diperiksa',
    body: 'Montir mulai memeriksa unit -C di Bengkel Jaya Motor.',
    at: DateTime(2026, 9, 29, 10, 26),
    deepLink: '/bookings/bk_active_0417/unit/-C',
  ),
  notificationFixture(
    'n2',
    title: 'Beat 110 mulai dikerjakan',
    body: 'Unit -B dikerjakan oleh Mas Rudi.',
    at: DateTime(2026, 9, 29, 10, 18),
    deepLink: '/bookings/bk_active_0417/unit/-B',
  ),
  notificationFixture(
    'n3',
    title: 'Vario 125 mulai dikerjakan',
    body: 'Unit -A dikerjakan oleh Pak Anto.',
    at: DateTime(2026, 9, 29, 10, 5),
    read: true,
    deepLink: '/bookings/bk_active_0417/unit/-A',
  ),
  notificationFixture(
    'n4',
    title: 'Semua motor sudah check-in',
    body: '3 motor masuk antrean Bengkel Jaya Motor.',
    at: DateTime(2026, 9, 29, 9, 8),
    read: true,
    deepLink: '/bookings/bk_active_0417',
  ),
  notificationFixture(
    'n5',
    title: 'Booking berhasil',
    body: 'TS-260929-0417 · 3 motor · Sel, 29 Sep · 09.00',
    at: DateTime(2026, 9, 28, 15, 40),
    read: true,
    deepLink: '/bookings/bk_active_0417',
  ),
  notificationFixture(
    'n6',
    category: NotificationCategory.reminder,
    title: 'Waktunya ganti oli Supra X 125',
    body: 'Sudah 3 bulan sejak servis terakhir.',
    at: DateTime(2026, 9, 28, 9),
    read: true,
    deepLink: '/booking/vehicles?motorId=motor_004',
  ),
  notificationFixture(
    'n7',
    category: NotificationCategory.promo,
    title: 'Potongan Rp25.000 servis',
    body: 'HEMAT25, min. belanja Rp300.000, berlaku sampai 5 Okt.',
    at: DateTime(2026, 9, 26, 12),
    read: true,
    deepLink: '/booking/vehicles?voucherId=voucher_hemat25',
  ),
  notificationFixture(
    'n8',
    title: 'Servis selesai',
    body: 'Beat 110 · Invoice TS-260910-0091 tersedia, total Rp143.000.',
    at: DateTime(2026, 9, 10, 14),
    read: true,
    deepLink: '/invoice/bk_seed_001',
  ),
  notificationFixture(
    'n9',
    category: NotificationCategory.promo,
    title: 'Diskon 10% servis ≥2 motor',
    body: 'DISKON10, ajak motor kedua.',
    at: DateTime(2026, 9, 3, 10),
    read: true,
    deepLink: '/booking/vehicles?voucherId=voucher_diskon10',
  ),
];
