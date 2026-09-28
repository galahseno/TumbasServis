import 'package:flutter/material.dart';
import 'package:tumbas_servis/catalog/presentation/katalog/state/katalog_state.dart';
import 'package:tumbas_servis/core/presentation/components/ts_chip.dart';

class CategoryChipRow extends StatelessWidget {
  const CategoryChipRow({
    required this.selectedCategory,
    required this.onSelected,
    super.key,
  });

  final String selectedCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            for (final category in katalogCategories) ...[
              TsChip(
                label: category,
                selected: category == selectedCategory,
                onSelected: (_) => onSelected(category),
              ),
              const SizedBox(width: 8),
            ],
          ],
        ),
      ),
    );
  }
}
