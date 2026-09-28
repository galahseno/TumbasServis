import 'package:url_launcher/url_launcher.dart';

Uri workshopMapsUri(String address) => Uri.parse(
  'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
);

Future<bool> openWorkshopInMaps(String address) =>
    launchUrl(workshopMapsUri(address), mode: LaunchMode.externalApplication);
