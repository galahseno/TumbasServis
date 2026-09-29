import 'package:flutter_riverpod/flutter_riverpod.dart';

class SummaryEditReturnViewModel extends Notifier<bool> {
  @override
  bool build() => false;

  void begin() => state = true;

  void end() => state = false;
}
