import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';

part 'booking_draft.freezed.dart';

enum ScheduleMode { shared, split, unknown }

extension ScheduleModeX on ScheduleMode {
  static ScheduleMode fromString(String? value) => switch (value) {
    'shared' => ScheduleMode.shared,
    'split' => ScheduleMode.split,
    _ => ScheduleMode.unknown,
  };
}

@freezed
abstract class UnitConfig with _$UnitConfig {
  const UnitConfig._();

  const factory UnitConfig({
    required List<String> serviceIds,
    required List<String> partIds,
    String? complaintNote,
  }) = _UnitConfig;

  static const int complaintNoteMaxLength = 250;

  bool get isComplaintNoteValid =>
      complaintNote == null || complaintNote!.length <= complaintNoteMaxLength;
}

@freezed
abstract class BookingDraft with _$BookingDraft {
  const factory BookingDraft({
    required String id,
    required List<String> selectedMotorIds,
    required Map<String, UnitConfig> unitConfigs,
    String? workshopId,
    required ScheduleMode scheduleMode,
    TimeSlot? sharedSlot,
    required Map<String, TimeSlot> unitSlots,
    String? voucherId,
    required DateTime createdAt,
    required DateTime expiresAt,
  }) = _BookingDraft;
}
