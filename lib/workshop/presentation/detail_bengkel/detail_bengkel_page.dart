import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/booking/presentation/booking_draft/booking_draft_view_model.dart';
import 'package:tumbas_servis/booking/presentation/di/booking_presentation_module.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/core/presentation/components/error_state.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/components/ts_app_bar.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/components/ts_snackbar.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/workshop/presentation/components/chosen_tag.dart';
import 'package:tumbas_servis/workshop/presentation/components/workshop_status_pill.dart';
import 'package:tumbas_servis/workshop/presentation/detail_bengkel/components/static_map.dart';
import 'package:tumbas_servis/workshop/presentation/detail_bengkel/components/workshop_cta_bar.dart';
import 'package:tumbas_servis/workshop/presentation/detail_bengkel/components/workshop_photo.dart';
import 'package:tumbas_servis/workshop/presentation/detail_bengkel/state/detail_bengkel_state.dart';
import 'package:tumbas_servis/workshop/presentation/di/workshop_presentation_module.dart';
import 'package:tumbas_servis/workshop/presentation/utils/workshop_maps.dart';
import 'package:tumbas_servis/workshop/presentation/utils/workshop_status_display.dart';

class DetailBengkelPage extends ConsumerStatefulWidget {
  const DetailBengkelPage({
    required this.workshopId,
    required this.variant,
    super.key,
  });

  final String workshopId;
  final WorkshopDetailVariant variant;

  @override
  ConsumerState<DetailBengkelPage> createState() => _DetailBengkelPageState();
}

class _DetailBengkelPageState extends ConsumerState<DetailBengkelPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(detailBengkelViewModelProvider.notifier)
          .initialize(widget.workshopId);
    });
  }

  Future<void> _handleCopyAddress(BuildContext context, String address) async {
    await Clipboard.setData(ClipboardData(text: address));
    if (!context.mounted) return;
    TsSnackbar.info(context, 'Alamat disalin');
  }

  Future<void> _handleCta({
    required BuildContext context,
    required Workshop workshop,
    required BookingDraftViewModel draftNotifier,
  }) async {
    if (widget.variant == WorkshopDetailVariant.standalone) {
      await draftNotifier.reset();
      if (!context.mounted) return;
      await ref.read(bookingDraftProvider.notifier).selectWorkshop(workshop.id);
      if (!context.mounted) return;
      context.push(Routes.bookingVehicles);
      return;
    }
    await draftNotifier.selectWorkshop(workshop.id);
    if (!context.mounted) return;
    context.push(Routes.bookingSchedule);
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(bookingDraftProvider);
    final draftNotifier = ref.read(bookingDraftProvider.notifier);
    final state = ref.watch(detailBengkelViewModelProvider);
    final viewModel = ref.read(detailBengkelViewModelProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final isInFlow = widget.variant == WorkshopDetailVariant.inFlow;

    Widget body;
    if (state.hasError) {
      body = ErrorState(
        message: 'Detail bengkel gagal dimuat. Coba lagi.',
        onRetry: viewModel.retry,
        layout: ErrorStateLayout.fullPage,
      );
    } else if (state.isLoading || state.workshop == null) {
      body = const _LoadingBody();
    } else {
      final workshop = state.workshop!;
      final chosen = draft?.workshopId == workshop.id;
      final open = viewModel.isOpenNow(workshop);
      final ctaLabel = isInFlow
          ? (chosen ? 'Lanjut ke jadwal' : 'Pilih bengkel ini')
          : 'Booking di sini';
      final helperLine = open
          ? null
          : 'Sedang tutup. Kamu tetap bisa pilih jadwal lain.';

      body = Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const WorkshopPhoto(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: _WorkshopInfoBlock(
                    workshop: workshop,
                    statusLine: viewModel.statusLineFor(workshop),
                    open: open,
                    chosen: chosen,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: StaticMap(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: _ServiceChips(
                    names: viewModel.serviceNamesFor(workshop),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: _AddressRow(
                    address: workshop.address,
                    onCopy: () => _handleCopyAddress(context, workshop.address),
                    onOpenMaps: () => openWorkshopInMaps(workshop.address),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: WorkshopCtaBar(
              ctaLabel: ctaLabel,
              helperLine: helperLine,
              onPressed: () => _handleCta(
                context: context,
                workshop: workshop,
                draftNotifier: draftNotifier,
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: TsAppBar.back(title: 'Detail bengkel'),
      body: SafeArea(top: false, child: body),
    );
  }
}

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SkeletonBlock(height: 200),
          SizedBox(height: 16),
          SkeletonBlock(height: 88),
          SizedBox(height: 16),
          SkeletonBlock(height: 140),
          SizedBox(height: 16),
          SkeletonBlock(height: 64),
        ],
      ),
    );
  }
}

class _WorkshopInfoBlock extends StatelessWidget {
  const _WorkshopInfoBlock({
    required this.workshop,
    required this.statusLine,
    required this.open,
    required this.chosen,
  });

  final Workshop workshop;
  final String statusLine;
  final bool open;
  final bool chosen;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                workshop.name,
                style: textTheme.headlineSmall?.copyWith(
                  color: scheme.onSurface,
                ),
              ),
            ),
            if (chosen) ...[const SizedBox(width: 8), const ChosenTag()],
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.star_rounded, size: 16, color: ext.ratingStar),
            const SizedBox(width: 4),
            Text(
              '${workshopRatingLabel(workshop.rating)} '
              '(${workshop.reviewCount} ulasan)',
              style: textTheme.bodyMedium?.copyWith(color: ext.textBody),
            ),
          ],
        ),
        const SizedBox(height: 8),
        WorkshopStatusPill(open: open, label: statusLine),
        const SizedBox(height: 4),
        Text(
          workshopHoursLine(workshop),
          style: textTheme.bodyMedium?.copyWith(color: ext.textMuted),
        ),
        Text(
          '${workshop.bayCount} bay servis',
          style: textTheme.bodyMedium?.copyWith(color: ext.textMuted),
        ),
      ],
    );
  }
}

class _ServiceChips extends StatelessWidget {
  const _ServiceChips({required this.names});

  final List<String> names;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Layanan yang tersedia',
          style: textTheme.titleMedium?.copyWith(color: scheme.onSurface),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final name in names)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: ext.borderDefault),
                ),
                child: Text(
                  name,
                  style: textTheme.labelLarge?.copyWith(color: ext.textBody),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _AddressRow extends StatelessWidget {
  const _AddressRow({
    required this.address,
    required this.onCopy,
    required this.onOpenMaps,
  });

  final String address;
  final VoidCallback onCopy;
  final VoidCallback onOpenMaps;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.place_outlined, size: 20, color: ext.textMuted),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                address,
                style: textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            TsButton(
              label: 'Salin',
              type: TsButtonType.outline,
              compact: true,
              fullWidth: false,
              leadingIcon: Icons.copy_rounded,
              onPressed: onCopy,
            ),
            TsButton(
              label: 'Buka di Maps',
              type: TsButtonType.outline,
              compact: true,
              fullWidth: false,
              leadingIcon: Icons.map_outlined,
              onPressed: onOpenMaps,
            ),
          ],
        ),
      ],
    );
  }
}
