import 'package:flutter_test/flutter_test.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/domain/service/unit_config/unit_config_validator.dart';

const _servisBerkala = ServiceType(
  id: 'svc-servis-berkala',
  name: 'Servis Berkala',
  price: 85000,
  durationMin: 60,
  requiresComplaint: false,
);

const _keluhanKhusus = ServiceType(
  id: 'svc-keluhan-khusus',
  name: 'Perbaikan Sesuai Keluhan',
  price: 0,
  durationMin: 30,
  requiresComplaint: true,
);

void main() {
  const validator = UnitConfigValidator();

  test('0 services selected is invalid', () {
    const config = UnitConfig(serviceIds: [], partIds: []);

    final result = validator.validate(
      config: config,
      selectedServiceTypes: const [],
    );

    expect(result.isValid, isFalse);
    expect(result.errors, contains(UnitConfigError.noServiceSelected));
  });

  test('requiresComplaint service with empty note is invalid', () {
    const config = UnitConfig(
      serviceIds: ['svc-keluhan-khusus'],
      partIds: [],
      complaintNote: '',
    );

    final result = validator.validate(
      config: config,
      selectedServiceTypes: [_keluhanKhusus],
    );

    expect(result.isValid, isFalse);
    expect(result.errors, contains(UnitConfigError.complaintRequired));
  });

  test('251-char complaint note is invalid', () {
    final config = UnitConfig(
      serviceIds: const ['svc-keluhan-khusus'],
      partIds: const [],
      complaintNote: 'a' * 251,
    );

    final result = validator.validate(
      config: config,
      selectedServiceTypes: [_keluhanKhusus],
    );

    expect(result.isValid, isFalse);
    expect(result.errors, contains(UnitConfigError.complaintTooLong));
  });

  test('valid config has no errors', () {
    const config = UnitConfig(serviceIds: ['svc-servis-berkala'], partIds: []);

    final result = validator.validate(
      config: config,
      selectedServiceTypes: [_servisBerkala],
    );

    expect(result.isValid, isTrue);
    expect(result.errors, isEmpty);
  });
}
