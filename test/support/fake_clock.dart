import 'package:tumbas_servis/core/domain/service/clock.dart';

class FakeClock implements Clock {
  FakeClock(this._now);

  DateTime _now;

  @override
  DateTime now() => _now;

  void setNow(DateTime value) => _now = value;
}
