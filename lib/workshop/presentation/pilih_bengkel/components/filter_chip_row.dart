import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/ts_chip.dart';
import 'package:tumbas_servis/workshop/presentation/pilih_bengkel/state/pilih_bengkel_state.dart';

class FilterChipRow extends StatelessWidget {
  const FilterChipRow({
    required this.openNowOnly,
    required this.sortMode,
    required this.onOpenNowChanged,
    required this.onSortModeChanged,
    super.key,
  });

  final bool openNowOnly;
  final WorkshopSortMode sortMode;
  final ValueChanged<bool> onOpenNowChanged;
  final ValueChanged<WorkshopSortMode> onSortModeChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            TsChip(
              label: 'Buka sekarang',
              selected: openNowOnly,
              onSelected: onOpenNowChanged,
            ),
            const SizedBox(width: 8),
            TsChip(
              label: 'Terdekat',
              selected: sortMode == WorkshopSortMode.terdekat,
              onSelected: (_) => onSortModeChanged(WorkshopSortMode.terdekat),
            ),
            const SizedBox(width: 8),
            TsChip(
              label: 'Rating tertinggi',
              selected: sortMode == WorkshopSortMode.ratingTertinggi,
              onSelected: (_) =>
                  onSortModeChanged(WorkshopSortMode.ratingTertinggi),
            ),
          ],
        ),
      ),
    );
  }
}
