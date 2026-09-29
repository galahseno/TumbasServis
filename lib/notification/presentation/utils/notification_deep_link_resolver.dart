// ignore_for_file: prefer_initializing_formals
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/booking/presentation/pilih_motor/pilih_motor_args.dart';
import 'package:tumbas_servis/core/data/service/demo_content_seeder.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/result.dart';
import 'package:tumbas_servis/core/domain/repository/booking/booking_repository.dart';

class NotificationTarget {
  const NotificationTarget({
    required this.location,
    this.extra,
    this.replaceStack = false,
    this.message,
  });

  final String location;
  final Object? extra;
  final bool replaceStack;
  final String? message;
}

class NotificationDeepLinkResolver {
  const NotificationDeepLinkResolver({
    required BookingRepository bookingRepository,
  }) : _bookingRepository = bookingRepository;

  final BookingRepository _bookingRepository;

  static const canonicalBookingAlias = 'bk_active_0417';

  static const _bookingSubRoutes = {
    'vehicles',
    'configure',
    'workshop',
    'schedule',
    'summary',
    'success',
    'select-motor',
  };

  Future<NotificationTarget?> resolve(String? deepLink) async {
    if (deepLink == null || deepLink.isEmpty) return null;
    final uri = Uri.tryParse(deepLink);
    if (uri == null) return null;
    final segments = uri.pathSegments;
    if (segments.isEmpty) return null;

    switch (segments.first) {
      case 'bookings':
        if (segments.length == 2) return _booking(segments[1], null);
        if (segments.length == 4 && segments[2] == 'unit') {
          return _booking(segments[1], segments[3]);
        }
      case 'tracking':
        if (segments.length == 3) return _booking(segments[1], segments[2]);
      case 'invoice':
        if (segments.length == 2) {
          return NotificationTarget(location: Routes.invoice(segments[1]));
        }
      case 'booking':
        if (segments.length != 2) break;
        if (segments[1] == 'select-motor' || segments[1] == 'vehicles') {
          return _vehicles(uri);
        }
        if (!_bookingSubRoutes.contains(segments[1])) {
          return _booking(segments[1], null);
        }
    }
    return null;
  }

  NotificationTarget _vehicles(Uri uri) {
    final motorId = uri.queryParameters['motorId'];
    final voucherId = uri.queryParameters['voucherId'];
    return NotificationTarget(
      location: Routes.bookingVehicles,
      extra: PilihMotorArgs(
        motorIds: motorId == null ? const [] : [motorId],
        voucherId: voucherId,
      ),
    );
  }

  Future<NotificationTarget> _booking(String id, String? unitCode) async {
    var bookingId = id;
    if (id == canonicalBookingAlias) {
      final resolved = await _canonicalBookingId();
      if (resolved == null) {
        return const NotificationTarget(
          location: Routes.bookings,
          replaceStack: true,
          message: 'Booking tidak ditemukan.',
        );
      }
      bookingId = resolved;
    }
    return NotificationTarget(
      location: unitCode == null
          ? Routes.bookingDetail(bookingId)
          : Routes.bookingUnitDetail(bookingId, unitCode),
    );
  }

  Future<String?> _canonicalBookingId() async {
    final result = await _bookingRepository.getBookings();
    if (result is! Ok<List<Booking>>) return null;
    for (final booking in result.value) {
      if (booking.code == DemoContentSeeder.canonicalBookingCode) {
        return booking.id;
      }
    }
    return null;
  }
}
