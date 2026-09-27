import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';

class StatusEvent {
  const StatusEvent({required this.status, required this.timestamp, this.note});

  final UnitStatus status;
  final DateTime timestamp;
  final String? note;

  StatusEvent copyWith({
    UnitStatus? status,
    DateTime? timestamp,
    String? note,
  }) {
    return StatusEvent(
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      note: note ?? this.note,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StatusEvent &&
          other.status == status &&
          other.timestamp == timestamp &&
          other.note == note);

  @override
  int get hashCode => Object.hash(status, timestamp, note);
}
