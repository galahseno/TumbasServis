enum BookingStatus { terjadwal, berlangsung, selesai, dibatalkan, unknown }

extension BookingStatusX on BookingStatus {
  static BookingStatus fromString(String? value) => switch (value) {
    'terjadwal' => BookingStatus.terjadwal,
    'berlangsung' => BookingStatus.berlangsung,
    'selesai' => BookingStatus.selesai,
    'dibatalkan' => BookingStatus.dibatalkan,
    _ => BookingStatus.unknown,
  };
}
