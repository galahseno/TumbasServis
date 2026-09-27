import 'dart:async';

enum TrackingSpeed { mati, detik15, detik5 }

class DemoModeController {
  bool _armedError = false;
  TrackingSpeed _trackingSpeed = TrackingSpeed.detik15;
  final StreamController<void> _resetController =
      StreamController<void>.broadcast();

  Stream<void> get resetRequests => _resetController.stream;

  void armNextWriteError() => _armedError = true;

  bool consumeArmedError() {
    if (!_armedError) return false;
    _armedError = false;
    return true;
  }

  TrackingSpeed get trackingSpeed => _trackingSpeed;

  void setTrackingSpeed(TrackingSpeed speed) => _trackingSpeed = speed;

  void requestReset() => _resetController.add(null);

  void dispose() => _resetController.close();
}
