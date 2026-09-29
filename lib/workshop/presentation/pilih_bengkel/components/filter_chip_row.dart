import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/components/ts_chip.dart';
import 'package:tumbas_servis/workshop/presentation/pilih_bengkel/state/pilih_bengkel_state.dart';

class FilterChipRow extends StatelessWidget {
  const FilterChipRow({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final WorkshopFilter selected;
  final ValueChanged<WorkshopFilter> onSelected;

  static const _labels = {
    WorkshopFilter.bukaSekarang: 'Buka sekarang',
    WorkshopFilter.terdekat: 'Terdekat',
    WorkshopFilter.ratingTertinggi: 'Rating tertinggi',
  };

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            for (final filter in WorkshopFilter.values) ...[
              if (filter != WorkshopFilter.values.first)
                const SizedBox(width: 8),
              TsChip(
                label: _labels[filter]!,
                selected: selected == filter,
                onSelected: (_) => onSelected(filter),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
