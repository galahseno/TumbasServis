import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';

class BookingStatusDerivation {
  const BookingStatusDerivation();

  static const List<UnitStatus> _midFlowOrDone = [
    UnitStatus.checkIn,
    UnitStatus.diperiksa,
    UnitStatus.dikerjakan,
    UnitStatus.qc,
    UnitStatus.selesai,
  ];

  BookingStatus deriveStatus(List<UnitStatus> unitStatuses) {
    if (unitStatuses.every((status) => status == UnitStatus.dibatalkan)) {
      return BookingStatus.dibatalkan;
    }

    final allTerminal = unitStatuses.every((status) => status.isTerminal);
    final anySelesai = unitStatuses.any(
      (status) => status == UnitStatus.selesai,
    );
    if (allTerminal && anySelesai) {
      return BookingStatus.selesai;
    }

    if (unitStatuses.any(_midFlowOrDone.contains)) {
      return BookingStatus.berlangsung;
    }

    return BookingStatus.terjadwal;
  }
}
