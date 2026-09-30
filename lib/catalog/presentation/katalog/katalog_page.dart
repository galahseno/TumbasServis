import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/catalog/presentation/di/catalog_presentation_module.dart';
import 'package:tumbas_servis/catalog/presentation/katalog/components/category_chip_row.dart';
import 'package:tumbas_servis/catalog/presentation/katalog/components/part_detail_sheet.dart';
import 'package:tumbas_servis/catalog/presentation/katalog/components/selected_parts_bar.dart';
import 'package:tumbas_servis/catalog/presentation/katalog/katalog_view_model.dart';
import 'package:tumbas_servis/catalog/presentation/katalog/state/katalog_state.dart';
import 'package:tumbas_servis/core/domain/model/catalog/part.dart';
import 'package:tumbas_servis/core/presentation/components/adaptive_sheet.dart';
import 'package:tumbas_servis/core/presentation/components/max_width_box.dart';
import 'package:tumbas_servis/core/presentation/components/empty_state.dart';
import 'package:tumbas_servis/core/presentation/components/error_state.dart';
import 'package:tumbas_servis/core/presentation/components/part_option_tile.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/components/ts_app_bar.dart';
import 'package:tumbas_servis/core/presentation/components/ts_dialog.dart';
import 'package:tumbas_servis/core/presentation/components/ts_switch.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/core/presentation/utils/window_size_class.dart';
import 'package:tumbas_servis/core/presentation/utils/currency_formatter.dart';

class KatalogSelectArgs {
  const KatalogSelectArgs({
    required this.modelId,
    required this.initialPartIds,
    required this.unitNickname,
    required this.unitPlateNumber,
  });

  final String modelId;
  final List<String> initialPartIds;
  final String unitNickname;
  final String unitPlateNumber;
}

class KatalogPage extends ConsumerStatefulWidget {
  const KatalogPage({required this.mode, super.key, this.selectArgs});

  final KatalogMode mode;
  final KatalogSelectArgs? selectArgs;

  @override
  ConsumerState<KatalogPage> createState() => _KatalogPageState();
}

class _KatalogPageState extends ConsumerState<KatalogPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(katalogViewModelProvider.notifier)
          .initialize(
            mode: widget.mode,
            modelId: widget.selectArgs?.modelId,
            unitNickname: widget.selectArgs?.unitNickname,
            unitPlateNumber: widget.selectArgs?.unitPlateNumber,
            initialPartIds:
                widget.selectArgs?.initialPartIds.toSet() ?? const {},
          );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch(KatalogViewModel viewModel) {
    _searchController.clear();
    viewModel.setSearchQuery('');
  }

  Future<void> _handleClose(
    BuildContext context,
    KatalogViewModel viewModel,
  ) async {
    if (widget.mode == KatalogMode.select && viewModel.isDirty) {
      final confirmed = await TsDialog.confirmSave(
        context,
        title: 'Buang perubahan?',
        message: 'Pilihan yang belum disimpan akan hilang.',
        confirmLabel: 'Buang',
        cancelLabel: 'Lanjut memilih',
      );
      if ((confirmed ?? false) && context.mounted) Navigator.of(context).pop();
      return;
    }
    Navigator.of(context).pop();
  }

  void _handleSelesai(BuildContext context, KatalogState state) {
    Navigator.of(context).pop(state.stagedPartIds.toList());
  }

  Future<void> _openDetail(Part part) async {
    final viewModel = ref.read(katalogViewModelProvider.notifier);
    final state = ref.read(katalogViewModelProvider);
    final ruleLine = viewModel.compatibilityRuleLine(part);
    final compatible = viewModel.isCompatible(part);
    final isSelect = widget.mode == KatalogMode.select;

    final compatRows = isSelect
        ? [
            PartDetailCompatRowData(
              label:
                  '${state.unitNickname ?? ''} · ${state.unitPlateNumber ?? ''}',
              compatible: compatible,
            ),
          ]
        : [
            for (final motor in state.garageMotors)
              PartDetailCompatRowData(
                label: '${motor.nickname} · ${motor.plateNumber}',
                compatible: part.compatibleModelIds.contains(motor.modelId),
              ),
          ];

    await showAdaptiveSheet<void>(
      context,
      builder: (_) => Consumer(
        builder: (context, ref, _) {
          final liveState = ref.watch(katalogViewModelProvider);
          final staged = liveState.stagedPartIds.contains(part.id);
          return PartDetailSheet(
            part: part,
            ruleLine: ruleLine,
            compatRows: compatRows,
            selectMode: isSelect,
            selected: staged,
            compatible: compatible,
            incompatibleReason: compatible
                ? null
                : viewModel.incompatibleReason(part),
            onToggle: (_) => viewModel.toggleStaged(part.id),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(katalogViewModelProvider);
    final viewModel = ref.read(katalogViewModelProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isSelect = widget.mode == KatalogMode.select;
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    Widget body;
    if (state.hasError) {
      body = ErrorState(
        message: 'Katalog gagal dimuat. Coba lagi.',
        onRetry: viewModel.retry,
        layout: ErrorStateLayout.fullPage,
      );
    } else {
      final visibleParts = viewModel.visibleParts;
      final sizeClass = context.windowSizeClass;
      final isWide = sizeClass.isAtLeast(WindowSizeClass.expanded);
      final gutter = sizeClass.isCompact ? 20.0 : 24.0;
      final unitLine = Text(
        'Untuk: ${state.unitNickname} · ${state.unitPlateNumber}',
        style: textTheme.titleMedium?.copyWith(color: scheme.onSurface),
      );
      final showUnit = isSelect && state.unitNickname != null && !keyboardOpen;
      final searchField = _SearchField(
        key: const ValueKey('katalog_search'),
        controller: _searchController,
        onChanged: viewModel.setSearchQuery,
        onClear: () => _clearSearch(viewModel),
      );
      final compatToggle = _CompatToggleRow(
        nickname: state.unitNickname ?? '',
        value: state.compatOnlyEnabled,
        onChanged: viewModel.setCompatOnly,
        horizontalPadding: isWide ? 0 : 20,
      );
      body = Column(
        children: [
          if (isWide) ...[
            const SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: gutter),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (showUnit) ...[
                    Flexible(flex: 3, child: unitLine),
                    const SizedBox(width: 24),
                  ],
                  Expanded(flex: 5, child: searchField),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CategoryChipRow(
                    selectedCategory: state.selectedCategory,
                    onSelected: viewModel.setCategory,
                    horizontalPadding: gutter,
                  ),
                ),
                if (isSelect && !keyboardOpen)
                  Padding(
                    padding: EdgeInsets.only(right: gutter),
                    child: SizedBox(width: 340, child: compatToggle),
                  ),
              ],
            ),
          ] else ...[
            Visibility(
              visible: showUnit,
              child: Padding(
                padding: EdgeInsets.fromLTRB(gutter, 8, gutter, 0),
                child: Align(alignment: Alignment.centerLeft, child: unitLine),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: gutter),
              child: searchField,
            ),
            const SizedBox(height: 12),
            CategoryChipRow(
              selectedCategory: state.selectedCategory,
              onSelected: viewModel.setCategory,
              horizontalPadding: gutter,
            ),
            Visibility(
              visible: isSelect && !keyboardOpen,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: _CompatToggleRow(
                  nickname: state.unitNickname ?? '',
                  value: state.compatOnlyEnabled,
                  onChanged: viewModel.setCompatOnly,
                  horizontalPadding: gutter,
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
          Expanded(
            child: state.isLoading
                ? const _LoadingList()
                : visibleParts.isEmpty
                ? EmptyState(
                    title: 'Tidak ada suku cadang',
                    body: state.searchQuery.isNotEmpty
                        ? 'Coba kata kunci lain.'
                        : 'Coba kategori lain.',
                    ctaLabel: state.searchQuery.isNotEmpty
                        ? 'Hapus pencarian'
                        : null,
                    onCta: state.searchQuery.isNotEmpty
                        ? () => _clearSearch(viewModel)
                        : null,
                  )
                : _PartList(
                    parts: visibleParts,
                    isSelect: isSelect,
                    stagedPartIds: state.stagedPartIds,
                    isCompatible: viewModel.isCompatible,
                    reasonFor: viewModel.incompatibleReason,
                    onToggle: viewModel.toggleStaged,
                    onOpenDetail: _openDetail,
                    gutter: gutter,
                  ),
          ),
          if (isSelect)
            SelectedPartsBar(
              selectedCount: state.stagedPartIds.length,
              subtotal: viewModel.stagedSubtotal,
              isLoading: state.isLoading,
              onSelesai: () => _handleSelesai(context, state),
            ),
        ],
      );
    }

    final sizeClass = context.windowSizeClass;
    if (!sizeClass.isCompact && !state.hasError) {
      body = MaxWidthBox(
        maxWidth: sizeClass.isAtLeast(WindowSizeClass.expanded) ? 1232 : 720,
        child: body,
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handleClose(context, viewModel);
      },
      child: Scaffold(
        backgroundColor: scheme.surface,
        appBar: isSelect
            ? TsAppBar.close(
                title: 'Suku cadang & oli',
                onClose: () => _handleClose(context, viewModel),
                semanticLabel: 'Tutup katalog',
              )
            : TsAppBar.back(title: 'Katalog suku cadang'),
        body: SafeArea(top: false, child: body),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: textTheme.bodyLarge?.copyWith(color: scheme.onSurface),
      cursorColor: ext.focusRing,
      decoration: InputDecoration(
        hintText: 'Cari oli, kampas, aki…',
        hintStyle: textTheme.bodyLarge?.copyWith(color: ext.textMuted),
        prefixIcon: Icon(Icons.search_rounded, color: ext.textMuted),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close_rounded),
                color: ext.textMuted,
                tooltip: 'Hapus pencarian',
                onPressed: onClear,
              )
            : null,
        filled: true,
        fillColor: scheme.surfaceContainer,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
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
    );
  }
}

class _CompatToggleRow extends StatelessWidget {
  const _CompatToggleRow({
    required this.nickname,
    required this.value,
    required this.onChanged,
    this.horizontalPadding = 20,
  });

  final String nickname;
  final bool value;
  final ValueChanged<bool> onChanged;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Hanya yang cocok untuk $nickname',
              style: textTheme.bodyMedium?.copyWith(color: ext.textBody),
            ),
          ),
          TsSwitch(
            value: value,
            onChanged: onChanged,
            semanticLabel: 'Hanya yang cocok untuk $nickname',
          ),
        ],
      ),
    );
  }
}

class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      children: const [
        SkeletonBlock(height: 76),
        SizedBox(height: 8),
        SkeletonBlock(height: 76),
        SizedBox(height: 8),
        SkeletonBlock(height: 76),
        SizedBox(height: 8),
        SkeletonBlock(height: 76),
      ],
    );
  }
}

class _PartList extends StatelessWidget {
  const _PartList({
    required this.parts,
    required this.isSelect,
    required this.stagedPartIds,
    required this.isCompatible,
    required this.reasonFor,
    required this.onToggle,
    required this.onOpenDetail,
    this.gutter = 20,
  });

  final double gutter;
  final List<Part> parts;
  final bool isSelect;
  final Set<String> stagedPartIds;
  final bool Function(Part) isCompatible;
  final String Function(Part) reasonFor;
  final ValueChanged<String> onToggle;
  final ValueChanged<Part> onOpenDetail;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1024
            ? 4
            : constraints.maxWidth >= 600
            ? 2
            : 1;
        if (columns == 1) {
          return ListView.separated(
            padding: EdgeInsets.fromLTRB(gutter, 0, gutter, 12),
            itemCount: parts.length,
            separatorBuilder: (_, _) => const SizedBox(height: 4),
            itemBuilder: (context, index) => _tile(parts[index]),
          );
        }
        final rowCount = (parts.length / columns).ceil();
        return ListView.separated(
          padding: EdgeInsets.fromLTRB(gutter, 0, gutter, 12),
          itemCount: rowCount,
          separatorBuilder: (_, _) => const SizedBox(height: 4),
          itemBuilder: (context, row) => IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var col = 0; col < columns; col++) ...[
                  if (col > 0) const SizedBox(width: 12),
                  Expanded(
                    child: row * columns + col < parts.length
                        ? _tile(parts[row * columns + col])
                        : const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _tile(Part part) {
    final compatible = isCompatible(part);
    final staged = stagedPartIds.contains(part.id);
    return PartOptionTile(
      name: part.name,
      subtitle:
          '${CurrencyFormatter.format(part.price)} · '
          '${part.brand} ${part.grade}',
      selected: staged,
      showCheckbox: isSelect,
      disabled: isSelect && !compatible,
      reasonText: isSelect && !compatible ? reasonFor(part) : null,
      onChanged: (_) => onToggle(part.id),
      onTap: () => onOpenDetail(part),
    );
  }
}
