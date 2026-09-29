import 'package:tumbas_servis/core/presentation/di/core_presentation_module.dart';

class FakeLogoutHandler implements LogoutHandler {
  int calls = 0;

  @override
  Future<void> call() async => calls++;
}
