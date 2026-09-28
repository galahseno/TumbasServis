import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';

bool isWorkshopOpenNow(Workshop workshop, DateTime now) =>
    now.hour >= workshop.openTime && now.hour < workshop.closeTime;

String workshopHourLabel(int hour) => '${hour.toString().padLeft(2, '0')}.00';

String workshopStatusLine(Workshop workshop, DateTime now) {
  final open = isWorkshopOpenNow(workshop, now);
  return open
      ? 'Buka · tutup ${workshopHourLabel(workshop.closeTime)}'
      : 'Tutup · buka ${workshopHourLabel(workshop.openTime)}';
}

String workshopHoursLine(Workshop workshop) =>
    'Setiap hari ${workshopHourLabel(workshop.openTime)}–'
    '${workshopHourLabel(workshop.closeTime)}';

String workshopRatingLabel(double rating) =>
    rating.toStringAsFixed(1).replaceAll('.', ',');

String workshopDistanceLabel(double distanceKm) =>
    '${distanceKm.toStringAsFixed(1).replaceAll('.', ',')} km';
