import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/booking/presentation/booking_draft/booking_draft_view_model.dart';
import 'package:tumbas_servis/booking/presentation/di/booking_presentation_module.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/core/presentation/components/error_state.dart';
import 'package:tumbas_servis/core/presentation/components/max_width_box.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/components/ts_app_bar.dart';
import 'package:tumbas_servis/core/presentation/components/ts_snackbar.dart';
import 'package:tumbas_servis/core/presentation/utils/window_size_class.dart';
import 'package:tumbas_servis/workshop/presentation/detail_bengkel/components/workshop_cta_bar.dart';
import 'package:tumbas_servis/workshop/presentation/detail_bengkel/components/workshop_detail_content.dart';
import 'package:tumbas_servis/workshop/presentation/detail_bengkel/state/detail_bengkel_state.dart';
import 'package:tumbas_servis/workshop/presentation/di/workshop_presentation_module.dart';
import 'package:tumbas_servis/workshop/presentation/utils/workshop_maps.dart';

const _stackedMaxWidth = 720.0;
const _splitMaxWidth = 560.0 + 24 + 648 + 48;

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

      final sizeClass = context.windowSizeClass;
      final isSplit = sizeClass.isAtLeast(WindowSizeClass.expanded);
      final content = WorkshopDetailContent(
        workshop: workshop,
        statusLine: viewModel.statusLineFor(workshop),
        open: open,
        chosen: chosen,
        serviceNames: viewModel.serviceNamesFor(workshop),
        onCopyAddress: () => _handleCopyAddress(context, workshop.address),
        onOpenMaps: () => openWorkshopInMaps(workshop.address),
        layout: isSplit
            ? WorkshopDetailLayout.split
            : WorkshopDetailLayout.stacked,
        photoHeight: sizeClass.isCompact ? null : (isSplit ? 320 : 300),
        mapHeight: sizeClass.isCompact ? null : 200,
      );
      final ctaBar = WorkshopCtaBar(
        ctaLabel: ctaLabel,
        helperLine: helperLine,
        maxWidth: sizeClass.isCompact ? null : 560 + 32,
        onPressed: () => _handleCta(
          context: context,
          workshop: workshop,
          draftNotifier: draftNotifier,
        ),
      );

      body = Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: isSplit
                ? MaxWidthBox(
                    maxWidth: _splitMaxWidth,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: content,
                    ),
                  )
                : MaxWidthBox(maxWidth: _stackedMaxWidth, child: content),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: isSplit
                ? MaxWidthBox(
                    maxWidth: _splitMaxWidth,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          const Spacer(flex: 560 + 24),
                          Expanded(flex: 648, child: ctaBar),
                        ],
                      ),
                    ),
                  )
                : ctaBar,
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
