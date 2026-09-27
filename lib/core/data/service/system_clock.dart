import 'package:tumbas_servis/core/domain/service/clock.dart';

class SystemClock implements Clock {
  @override
  DateTime now() => DateTime.now();
}
