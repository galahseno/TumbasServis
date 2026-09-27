// ignore_for_file: prefer_initializing_formals
import 'dart:async';

import 'package:tumbas_servis/core/data/service/demo_mode_controller.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';

typedef TrackingTimerFactory =
    Timer Function(Duration duration, void Function() callback);

Timer _defaultTimerFactory(Duration duration, void Function() callback) =>
    Timer(duration, callback);

class TrackingSimulator {
  TrackingSimulator({
    required DemoModeController demoModeController,
    TrackingTimerFactory timerFactory = _defaultTimerFactory,
  }) : _demoModeController = demoModeController,
       _timerFactory = timerFactory;

  final DemoModeController _demoModeController;
  final TrackingTimerFactory _timerFactory;

  final Map<String, StreamController<UnitStatus>> _controllers = {};
  final Map<String, UnitStatus> _currentStatus = {};
  final Map<String, Timer> _timers = {};

  static const List<UnitStatus> _forwardOrder = [
    UnitStatus.terjadwal,
    UnitStatus.checkIn,
    UnitStatus.diperiksa,
    UnitStatus.dikerjakan,
    UnitStatus.qc,
    UnitStatus.selesai,
  ];

  String _keyFor(String bookingId, String unitCode) => '$bookingId|$unitCode';

  Stream<UnitStatus> watch(String bookingId, String unitCode) {
    final key = _keyFor(bookingId, unitCode);
    return _controllers
        .putIfAbsent(
          key,
          () => StreamController<UnitStatus>.broadcast(sync: true),
        )
        .stream;
  }

  Duration? _intervalForCurrentSpeed() =>
      switch (_demoModeController.trackingSpeed) {
        TrackingSpeed.mati => null,
        TrackingSpeed.detik15 => const Duration(seconds: 15),
        TrackingSpeed.detik5 => const Duration(seconds: 5),
      };

  void checkIn(String bookingId, String unitCode) {
    final key = _keyFor(bookingId, unitCode);
    _currentStatus[key] = UnitStatus.checkIn;
    _emit(key);
    _scheduleNext(bookingId, unitCode);
  }

  void advance(String bookingId, String unitCode) =>
      _advanceInternal(bookingId, unitCode);

  void advanceAll() {
    for (final key in _currentStatus.keys.toList()) {
      final parts = key.split('|');
      _advanceInternal(parts[0], parts[1]);
    }
  }

  void reset(String bookingId, String unitCode) {
    final key = _keyFor(bookingId, unitCode);
    _timers.remove(key)?.cancel();
    _currentStatus[key] = UnitStatus.terjadwal;
    _emit(key);
  }

  void resetAll() {
    for (final key in _currentStatus.keys.toList()) {
      final parts = key.split('|');
      reset(parts[0], parts[1]);
    }
  }

  void _scheduleNext(String bookingId, String unitCode) {
    final key = _keyFor(bookingId, unitCode);
    _timers.remove(key)?.cancel();
    final interval = _intervalForCurrentSpeed();
    if (interval == null) return; // Mati: no auto-advance
    final current = _currentStatus[key] ?? UnitStatus.terjadwal;
    if (current.isTerminal) return;
    _timers[key] = _timerFactory(
      interval,
      () => _advanceInternal(bookingId, unitCode),
    );
  }

  void _advanceInternal(String bookingId, String unitCode) {
    final key = _keyFor(bookingId, unitCode);
    final current = _currentStatus[key] ?? UnitStatus.terjadwal;
    final currentIndex = _forwardOrder.indexOf(current);
    if (currentIndex == -1 || currentIndex + 1 >= _forwardOrder.length) {
      _timers.remove(key)?.cancel();
      return;
    }
    final next = _forwardOrder[currentIndex + 1];
    _currentStatus[key] = next;
    _timers.remove(key)?.cancel();
    _emit(key);
    if (!next.isTerminal) {
      _scheduleNext(bookingId, unitCode);
    }
  }

  void _emit(String key) {
    final status = _currentStatus[key];
    if (status != null) _controllers[key]?.add(status);
  }

  void dispose() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
    for (final controller in _controllers.values) {
      controller.close();
    }
    _controllers.clear();
  }
}
