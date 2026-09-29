import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/core/presentation/components/error_state.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/components/ts_snackbar.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/workshop/presentation/detail_bengkel/components/workshop_detail_content.dart';
import 'package:tumbas_servis/workshop/presentation/di/workshop_presentation_module.dart';
import 'package:tumbas_servis/workshop/presentation/utils/workshop_maps.dart';
import 'package:flutter/services.dart';

class WorkshopDetailPane extends ConsumerStatefulWidget {
  const WorkshopDetailPane({
    required this.workshopId,
    required this.chosen,
    required this.onChoose,
    super.key,
  });

  final String workshopId;
  final bool chosen;
  final ValueChanged<Workshop> onChoose;

  @override
  ConsumerState<WorkshopDetailPane> createState() => _WorkshopDetailPaneState();
}

class _WorkshopDetailPaneState extends ConsumerState<WorkshopDetailPane> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void didUpdateWidget(WorkshopDetailPane oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.workshopId != widget.workshopId) _initialize();
  }

  void _initialize() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(detailBengkelViewModelProvider.notifier)
          .initialize(widget.workshopId);
    });
  }

  Future<void> _copyAddress(String address) async {
    await Clipboard.setData(ClipboardData(text: address));
    if (!mounted) return;
    TsSnackbar.info(context, 'Alamat disalin');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final state = ref.watch(detailBengkelViewModelProvider);
    final viewModel = ref.read(detailBengkelViewModelProvider.notifier);
    final workshop = state.workshop;

    Widget child;
    if (state.hasError) {
      child = ErrorState(
        message: 'Detail bengkel gagal dimuat. Coba lagi.',
        onRetry: viewModel.retry,
      );
    } else if (state.isLoading ||
        workshop == null ||
        workshop.id != widget.workshopId) {
      child = const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SkeletonBlock(height: 200),
            SizedBox(height: 16),
            SkeletonBlock(height: 88),
            SizedBox(height: 16),
            SkeletonBlock(height: 140),
          ],
        ),
      );
    } else {
      final open = viewModel.isOpenNow(workshop);
      child = Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16),
              child: WorkshopDetailContent(
                workshop: workshop,
                statusLine: viewModel.statusLineFor(workshop),
                open: open,
                chosen: widget.chosen,
                serviceNames: viewModel.serviceNamesFor(workshop),
                onCopyAddress: () => _copyAddress(workshop.address),
                onOpenMaps: () => openWorkshopInMaps(workshop.address),
                photoHeight: 240,
                mapHeight: 200,
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: ext.borderDefault)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!open) ...[
                    Text(
                      'Sedang tutup. Kamu tetap bisa pilih jadwal lain.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall?.copyWith(
                        color: ext.textMuted,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  TsButton(
                    label: widget.chosen
                        ? 'Lanjut ke jadwal'
                        : 'Pilih bengkel ini',
                    onPressed: () => widget.onChoose(workshop),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ext.borderDefault),
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(16), child: child),
    );
  }
}

class WorkshopPanePlaceholder extends StatelessWidget {
  const WorkshopPanePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ext.borderDefault),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.storefront_rounded, size: 40, color: ext.textFaint),
              const SizedBox(height: 12),
              Text(
                'Pilih bengkel untuk melihat detailnya',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(color: ext.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
