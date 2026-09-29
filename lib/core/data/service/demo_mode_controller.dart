import 'dart:async';

enum TrackingSpeed { mati, detik15, detik5 }

class DemoModeController {
  bool _armedError = false;
  TrackingSpeed _trackingSpeed = TrackingSpeed.detik15;
  final StreamController<bool> _armedController =
      StreamController<bool>.broadcast(sync: true);
  final StreamController<TrackingSpeed> _speedController =
      StreamController<TrackingSpeed>.broadcast(sync: true);

  int _seedingDepth = 0;

  bool get isSeeding => _seedingDepth > 0;

  void beginSeeding() => _seedingDepth++;

  void endSeeding() {
    if (_seedingDepth > 0) _seedingDepth--;
  }

  bool get isErrorArmed => _armedError;

  Stream<bool> get armedChanges => _armedController.stream;

  Stream<TrackingSpeed> get speedChanges => _speedController.stream;

  void armNextWriteError() {
    _armedError = true;
    _armedController.add(true);
  }

  void disarmError() {
    if (!_armedError) return;
    _armedError = false;
    _armedController.add(false);
  }

  bool consumeArmedError() {
    if (!_armedError) return false;
    _armedError = false;
    _armedController.add(false);
    return true;
  }

  TrackingSpeed get trackingSpeed => _trackingSpeed;

  void setTrackingSpeed(TrackingSpeed speed) {
    if (_trackingSpeed == speed) return;
    _trackingSpeed = speed;
    _speedController.add(speed);
  }

  void dispose() {
    _armedController.close();
    _speedController.close();
  }
}
