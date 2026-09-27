import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';

enum UnitConfigError { noServiceSelected, complaintRequired, complaintTooLong }

class UnitConfigValidationResult {
  const UnitConfigValidationResult({required this.errors});

  final List<UnitConfigError> errors;

  bool get isValid => errors.isEmpty;
}

class UnitConfigValidator {
  const UnitConfigValidator();

  UnitConfigValidationResult validate({
    required UnitConfig config,
    required List<ServiceType> selectedServiceTypes,
  }) {
    final errors = <UnitConfigError>[];

    if (config.serviceIds.isEmpty) {
      errors.add(UnitConfigError.noServiceSelected);
    }

    final requiresComplaint = selectedServiceTypes.any(
      (service) => service.requiresComplaint,
    );
    final note = config.complaintNote;
    if (requiresComplaint && (note == null || note.trim().isEmpty)) {
      errors.add(UnitConfigError.complaintRequired);
    }

    if (!config.isComplaintNoteValid) {
      errors.add(UnitConfigError.complaintTooLong);
    }

    return UnitConfigValidationResult(errors: errors);
  }
}
