import 'package:tumbas_servis/booking/presentation/utils/schedule_display.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/catalog/service_type.dart';
import 'package:tumbas_servis/core/presentation/utils/date_formatter.dart';
import 'package:tumbas_servis/core/presentation/utils/time_formatter.dart';

class TicketUnitLine {
  const TicketUnitLine({
    required this.unitCode,
    required this.motorName,
    required this.summary,
    required this.status,
    this.slotLine,
  });

  final String unitCode;
  final String motorName;

  final String summary;
  final UnitStatus status;

  final String? slotLine;
}

List<TicketUnitLine> buildTicketUnitLines({
  required Booking booking,
  required Map<String, ServiceType> serviceById,
}) {
  final isSplit = booking.scheduleMode == ScheduleMode.split;
  return booking.units.map((unit) {
    final services = unit.serviceIds
        .map((id) => serviceById[id]?.name)
        .whereType<String>()
        .join(' + ');
    final parts = unit.partIds.isEmpty
        ? ''
        : ' + ${unit.partIds.length} suku cadang';
    final slot = booking.unitSlots?[unit.unitCode];
    return TicketUnitLine(
      unitCode: unit.unitCode,
      motorName: unit.motorSnapshot.nickname,
      summary: 'Unit ${unit.unitCode} · $services$parts',
      status: unit.status,
      slotLine: isSplit && slot != null
          ? '${DateFormatter.formatShort(slot.date)} · '
                '${TimeFormatter.format(slotDateTime(slot))}'
          : null,
    );
  }).toList();
}

String ticketScheduleLine(Booking booking) {
  if (booking.scheduleMode == ScheduleMode.split) {
    final slots = booking.unitSlots?.values.toList() ?? const [];
    if (slots.isEmpty) return 'Jam berbeda tiap motor';
    final earliest = slots
        .map((s) => s.date)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    return '${DateFormatter.format(earliest)} · jam berbeda tiap motor';
  }
  final slot = booking.sharedSlot;
  return slot == null ? '' : slotRecapLabel(slot);
}

String ticketSemanticsLabel({
  required Booking booking,
  required String workshopName,
}) {
  final unitCount = booking.units.length;
  final schedule = ticketScheduleLine(booking);
  return 'Tiket booking ${booking.code}, $unitCount motor, $workshopName, '
      '$schedule';
}
