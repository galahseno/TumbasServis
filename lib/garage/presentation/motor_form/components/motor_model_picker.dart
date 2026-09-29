import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/domain/model/garage/motor_model.dart';
import 'package:tumbas_servis/core/presentation/components/empty_state.dart';
import 'package:tumbas_servis/core/presentation/components/sheet_header.dart';
import 'package:tumbas_servis/core/presentation/components/ts_icon_button.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/garage/presentation/utils/motor_display.dart';

Future<MotorModel?> showMotorModelPicker(
  BuildContext context, {
  required List<MotorModel> models,
  required String? selectedModelId,
}) {
  final size = MediaQuery.sizeOf(context);
  if (size.width < 600) {
    return showModalBottomSheet<MotorModel>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => SizedBox(
        height: size.height * 0.85,
        child: _MotorModelPickerContent(
          models: models,
          selectedModelId: selectedModelId,
          isSheet: true,
        ),
      ),
    );
  }
  return showDialog<MotorModel>(
    context: context,
    builder: (ctx) => Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: (size.width - 560) / 2,
        vertical: 24,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 640),
        child: _MotorModelPickerContent(
          models: models,
          selectedModelId: selectedModelId,
          isSheet: false,
        ),
      ),
    ),
  );
}

class _MotorModelPickerContent extends StatefulWidget {
  const _MotorModelPickerContent({
    required this.models,
    required this.selectedModelId,
    required this.isSheet,
  });

  final List<MotorModel> models;
  final String? selectedModelId;
  final bool isSheet;

  @override
  State<_MotorModelPickerContent> createState() =>
      _MotorModelPickerContentState();
}

class _MotorModelPickerContentState extends State<_MotorModelPickerContent> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _searchFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  List<MotorModel> get _filtered {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return widget.models;
    return widget.models
        .where(
          (m) =>
              m.name.toLowerCase().contains(query) ||
              motorBrandLabel(m.brand).toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final filtered = _filtered;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.isSheet)
          SheetHeader(
            title: 'Pilih model',
            onClose: () => Navigator.of(context).pop(),
          )
        else
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Pilih model',
                    style: textTheme.titleLarge?.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                ),
                TsIconButton(
                  icon: Icons.close_rounded,
                  semanticLabel: 'Tutup',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocus,
            onChanged: (value) => setState(() => _query = value),
            textInputAction: TextInputAction.search,
            style: textTheme.bodyLarge?.copyWith(color: scheme.onSurface),
            cursorColor: ext.focusRing,
            decoration: InputDecoration(
              hintText: 'Cari model motor',
              hintStyle: textTheme.bodyLarge?.copyWith(color: ext.textMuted),
              prefixIcon: Icon(Icons.search_rounded, color: ext.textMuted),
              filled: true,
              fillColor: scheme.surfaceContainer,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: scheme.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: scheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: ext.focusRing, width: 2),
              ),
            ),
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? const EmptyState(
                  icon: Icons.search_off_rounded,
                  title: 'Model tidak ditemukan',
                  body: 'Coba kata kunci lain, misalnya "Beat" atau "Honda".',
                )
              : CustomScrollView(
                  slivers: [
                    for (final brand in pickerBrands)
                      ..._brandSection(context, brand, filtered),
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  ],
                ),
        ),
      ],
    );
  }

  List<Widget> _brandSection(
    BuildContext context,
    MotorBrand brand,
    List<MotorModel> models,
  ) {
    final brandModels = models.where((m) => m.brand == brand).toList();
    if (brandModels.isEmpty) return const [];
    return [
      SliverPersistentHeader(
        pinned: true,
        delegate: _BrandHeaderDelegate(label: motorBrandLabel(brand)),
      ),
      SliverList.builder(
        itemCount: brandModels.length,
        itemBuilder: (context, index) {
          final model = brandModels[index];
          return _ModelRow(
            model: model,
            selected: model.id == widget.selectedModelId,
            onTap: () => Navigator.of(context).pop(model),
          );
        },
      ),
    ];
  }
}

class _BrandHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _BrandHeaderDelegate({required this.label});

  final String label;

  static const _height = 36.0;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final ext = TsThemeExtension.of(context);
    return Semantics(
      header: true,
      child: Container(
        height: _height,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: ext.textMuted),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_BrandHeaderDelegate oldDelegate) =>
      oldDelegate.label != label;
}

class _ModelRow extends StatelessWidget {
  const _ModelRow({
    required this.model,
    required this.selected,
    required this.onTap,
  });

  final MotorModel model;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final detail = '${motorCategoryLabel(model.category)} · ${model.cc} cc';

    return Semantics(
      button: true,
      selected: selected,
      label:
          '${model.name}, ${motorBrandLabel(model.brand)}, $detail'
          '${selected ? ', terpilih' : ''}',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name,
                      style: textTheme.bodyLarge?.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                    Text(
                      detail,
                      style: textTheme.bodySmall?.copyWith(
                        color: ext.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check_rounded, color: ext.textAccent, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
