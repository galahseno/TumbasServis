import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';

class SalinDariCopyResult {
  const SalinDariCopyResult({
    required this.serviceIds,
    required this.partIds,
    required this.droppedIncompatiblePartCount,
  });

  final List<String> serviceIds;
  final List<String> partIds;
  final int droppedIncompatiblePartCount;
}

class SalinDariCompatibilityFilter {
  const SalinDariCompatibilityFilter();

  SalinDariCopyResult copyTo({
    required UnitConfig source,
    required String targetModelId,
    required List<Part> catalogParts,
  }) {
    final partsById = {for (final part in catalogParts) part.id: part};
    final compatiblePartIds = <String>[];
    var droppedCount = 0;

    for (final partId in source.partIds) {
      final part = partsById[partId];
      if (part != null && part.compatibleModelIds.contains(targetModelId)) {
        compatiblePartIds.add(partId);
      } else {
        droppedCount++;
      }
    }

    return SalinDariCopyResult(
      serviceIds: List<String>.of(source.serviceIds),
      partIds: compatiblePartIds,
      droppedIncompatiblePartCount: droppedCount,
    );
  }
}
