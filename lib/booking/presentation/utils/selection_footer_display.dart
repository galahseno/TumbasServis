import 'package:tumbas_servis/booking/presentation/booking_draft/booking_draft_view_model.dart';

String? selectionReasonLine({
  required bool isLoading,
  required int selectedCount,
}) {
  if (isLoading) return 'Memuat daftar motor…';
  if (selectedCount == 0) return 'Pilih minimal 1 motor';
  if (selectedCount >= bookingDraftMaxMotors) {
    return 'Lepas satu untuk memilih motor lain';
  }
  return null;
}
