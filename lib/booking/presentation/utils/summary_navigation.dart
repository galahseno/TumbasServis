import 'package:flutter/widgets.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';

void returnToSummary(BuildContext context) => Navigator.of(context).popUntil(
  (route) => route.settings.name == Routes.bookingSummary || route.isFirst,
);
