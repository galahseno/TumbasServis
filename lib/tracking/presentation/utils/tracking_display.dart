import 'package:tumbas_servis/booking/presentation/utils/schedule_display.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_status.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/domain/model/booking/status_event.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';
import 'package:tumbas_servis/core/presentation/utils/date_formatter.dart';
import 'package:tumbas_servis/core/presentation/utils/time_formatter.dart';

extension BookingStatusLabelX on BookingStatus {
  String get label => switch (this) {
    BookingStatus.terjadwal || BookingStatus.unknown => 'Terjadwal',
    BookingStatus.berlangsung => 'Berlangsung',
    BookingStatus.selesai => 'Selesai',
    BookingStatus.dibatalkan => 'Dibatalkan',
  };
}

extension UnitStatusLabelX on UnitStatus {
  String get timelineLabel => switch (this) {
    UnitStatus.terjadwal || UnitStatus.unknown => 'Terjadwal',
    UnitStatus.checkIn => 'Check-in',
    UnitStatus.diperiksa => 'Diperiksa',
    UnitStatus.dikerjakan => 'Dikerjakan',
    UnitStatus.qc => 'QC',
    UnitStatus.selesai => 'Selesai',
    UnitStatus.dibatalkan => 'Dibatalkan',
  };
}

const timelineStages = <UnitStatus>[
  UnitStatus.terjadwal,
  UnitStatus.checkIn,
  UnitStatus.diperiksa,
  UnitStatus.dikerjakan,
  UnitStatus.qc,
  UnitStatus.selesai,
];

TimeSlot? bookingPrimarySlot(Booking booking) {
  if (booking.sharedSlot != null) return booking.sharedSlot;
  final slots = booking.unitSlots?.values.toList() ?? const <TimeSlot>[];
  if (slots.isEmpty) return null;
  return slots.reduce(
    (a, b) => slotDateTime(a).isBefore(slotDateTime(b)) ? a : b,
  );
}

TimeSlot? unitSlot(Booking booking, BookingUnit unit) =>
    booking.unitSlots?[unit.unitCode] ?? booking.sharedSlot;

DateTime bookingMoment(Booking booking) {
  final slot = bookingPrimarySlot(booking);
  return slot == null ? booking.createdAt : slotDateTime(slot);
}

String bookingScheduleLine(Booking booking) {
  final slot = bookingPrimarySlot(booking);
  if (slot == null) return DateFormatter.format(booking.createdAt);
  if (booking.scheduleMode == ScheduleMode.split) {
    return '${DateFormatter.format(slot.date)} · jam berbeda tiap motor';
  }
  return slotRecapLabel(slot);
}

String unitMetaLine(
  BookingUnit unit, {
  required Map<String, String> serviceNameById,
  required Map<String, String> partCategoryById,
}) {
  final names = <String>[
    for (final id in unit.serviceIds)
      if (serviceNameById[id] != null) serviceNameById[id]!,
  ];
  final categories = <String>[];
  for (final id in unit.partIds) {
    final category = partCategoryById[id];
    if (category != null && !categories.contains(category)) {
      categories.add(category);
    }
  }
  final summary = [...names, ...categories].join(' + ');
  return summary.isEmpty
      ? 'Unit ${unit.unitCode}'
      : 'Unit ${unit.unitCode} · $summary';
}

String unitServicesSummary(
  BookingUnit unit, {
  required Map<String, String> serviceNameById,
  required Map<String, String> partCategoryById,
}) {
  final meta = unitMetaLine(
    unit,
    serviceNameById: serviceNameById,
    partCategoryById: partCategoryById,
  );
  final index = meta.indexOf(' · ');
  return index == -1 ? '' : meta.substring(index + 3);
}

String unitLetter(String unitCode) =>
    unitCode.startsWith('-') ? unitCode.substring(1) : unitCode;

StatusEvent? eventFor(BookingUnit unit, UnitStatus status) {
  for (final event in unit.statusHistory) {
    if (event.status == status) return event;
  }
  return null;
}

StatusEvent? cancelEvent(BookingUnit unit) =>
    eventFor(unit, UnitStatus.dibatalkan);

String? cancelReason(StatusEvent? event) {
  final note = event?.note;
  if (note == null) return null;
  final index = note.indexOf(': ');
  return index == -1 ? null : note.substring(index + 2);
}

String timelineStamp(DateTime moment, {required DateTime reference}) {
  final sameDay =
      moment.year == reference.year &&
      moment.month == reference.month &&
      moment.day == reference.day;
  final time = TimeFormatter.format(moment);
  if (sameDay) return time;
  return '${_dayMonth(moment)} · $time';
}

String _dayMonth(DateTime date) {
  final short = DateFormatter.formatShort(date); // "Sel, 29 Sep"
  final index = short.indexOf(', ');
  return index == -1 ? short : short.substring(index + 2);
}

String fullStamp(DateTime moment) =>
    '${DateFormatter.format(moment)} · ${TimeFormatter.format(moment)}';

String timeOnly(DateTime moment) => TimeFormatter.format(moment);
