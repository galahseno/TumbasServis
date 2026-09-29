// ignore_for_file: prefer_initializing_formals
import 'dart:async';

import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/core/data/service/demo_mode_controller.dart';
import 'package:tumbas_servis/core/data/service/local_store.dart';
import 'package:tumbas_servis/core/data/service/slot_occupancy_calculator.dart';
import 'package:tumbas_servis/core/data/service/tracking_simulator.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/notification/app_notification.dart';
import 'package:tumbas_servis/core/domain/repository/notification/notification_repository.dart';
import 'package:tumbas_servis/core/domain/service/clock.dart';

Timer _defaultTimerFactory(Duration duration, void Function() callback) =>
    Timer(duration, callback);

class StatusNotificationCoordinator {
  StatusNotificationCoordinator({
    required TrackingSimulator trackingSimulator,
    required LocalStore localStore,
    required NotificationRepository notificationRepository,
    required Clock clock,
    DemoModeController? demoModeController,
    Duration discoveryInterval = const Duration(seconds: 2),
    TrackingTimerFactory timerFactory = _defaultTimerFactory,
  }) : _demoModeController = demoModeController,
       _trackingSimulator = trackingSimulator,
       _localStore = localStore,
       _notificationRepository = notificationRepository,
       _clock = clock,
       _discoveryInterval = discoveryInterval,
       _timerFactory = timerFactory;

  final DemoModeController? _demoModeController;
  final TrackingSimulator _trackingSimulator;
  final LocalStore _localStore;
  final NotificationRepository _notificationRepository;
  final Clock _clock;
  final Duration _discoveryInterval;
  final TrackingTimerFactory _timerFactory;

  static const _bookingsBox = SlotOccupancyCalculator.bookingsBox;

  final Set<String> _watchedKeys = {};
  final Map<String, StreamSubscription<UnitStatus>> _subscriptions = {};
  Timer? _pollTimer;
  var _notificationSeq = 0;

  void start() {
    unawaited(_discoverAndWatch());
    _schedulePoll();
  }

  void _schedulePoll() {
    _pollTimer?.cancel();
    _pollTimer = _timerFactory(_discoveryInterval, () {
      unawaited(_discoverAndWatch());
      _schedulePoll();
    });
  }

  Future<void> _discoverAndWatch() async {
    final rows = await _localStore.getAll(_bookingsBox);
    for (final row in rows) {
      final bookingId = row['id'] as String?;
      final units = (row['units'] as List<dynamic>?)
          ?.cast<Map<String, dynamic>>();
      if (bookingId == null || units == null) continue;

      for (final unit in units) {
        final unitCode = unit['unit_code'] as String?;
        if (unitCode == null) continue;
        final status = UnitStatusX.fromString(unit['status'] as String?);
        if (status.isTerminal) continue;

        final key = '$bookingId|$unitCode';
        if (_watchedKeys.contains(key)) continue;
        _watchedKeys.add(key);

        final motorSnapshot = unit['motor_snapshot'] as Map<String, dynamic>?;
        final motorNickname = motorSnapshot?['nickname'] as String? ?? unitCode;

        _subscriptions[key] = _trackingSimulator
            .watch(bookingId, unitCode)
            .listen((newStatus) {
              unawaited(
                _onStatusChanged(bookingId, unitCode, motorNickname, newStatus),
              );
              if (newStatus.isTerminal) {
                _subscriptions.remove(key)?.cancel();
              }
            });
      }
    }
  }

  Future<void> _onStatusChanged(
    String bookingId,
    String unitCode,
    String motorNickname,
    UnitStatus status,
  ) async {
    if (_demoModeController?.isSeeding ?? false) return;
    final phrase = _phraseFor(status);
    if (phrase == null) return;

    _notificationSeq++;
    final notification = AppNotification(
      id:
          'notif_status_${bookingId}_${unitCode}_${status.name}_'
          '$_notificationSeq',
      category: NotificationCategory.status,
      title: '$motorNickname $phrase',
      body: 'Unit $unitCode $motorNickname $phrase.',
      timestamp: _clock.now(),
      read: false,
      deepLink: Routes.bookingUnitDetail(bookingId, unitCode),
    );
    await _notificationRepository.addNotification(notification);
  }

  String? _phraseFor(UnitStatus status) => switch (status) {
    UnitStatus.checkIn => 'sudah check-in',
    UnitStatus.diperiksa => 'sedang diperiksa',
    UnitStatus.dikerjakan => 'sedang dikerjakan',
    UnitStatus.qc => 'sedang QC',
    UnitStatus.selesai => 'selesai diservis',
    UnitStatus.terjadwal || UnitStatus.dibatalkan || UnitStatus.unknown => null,
  };

  void dispose() {
    _pollTimer?.cancel();
    for (final subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }
}
