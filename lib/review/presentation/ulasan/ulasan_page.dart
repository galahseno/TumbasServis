import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tumbas_servis/app/navigation/routes.dart';
import 'package:tumbas_servis/core/domain/model/review/review.dart';
import 'package:tumbas_servis/core/presentation/components/empty_state.dart';
import 'package:tumbas_servis/core/presentation/components/error_state.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/components/ts_app_bar.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/components/ts_snackbar.dart';
import 'package:tumbas_servis/core/presentation/components/ts_text_field.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/review/presentation/di/review_presentation_module.dart';
import 'package:tumbas_servis/review/presentation/ulasan/components/mechanic_rating_row.dart';
import 'package:tumbas_servis/review/presentation/ulasan/components/rating_stars.dart';
import 'package:tumbas_servis/review/presentation/ulasan/components/review_recap.dart';
import 'package:tumbas_servis/review/presentation/ulasan/state/ulasan_state.dart';

class UlasanPage extends ConsumerStatefulWidget {
  const UlasanPage({required this.bookingId, super.key});

  final String bookingId;

  @override
  ConsumerState<UlasanPage> createState() => _UlasanPageState();
}

class _UlasanPageState extends ConsumerState<UlasanPage> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _goBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.bookingDetail(widget.bookingId));
    }
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final viewModel = ref.read(
      ulasanViewModelProvider(widget.bookingId).notifier,
    );
    final ok = await viewModel.submit();
    if (!mounted) return;
    if (ok) {
      TsSnackbar.success(
        context,
        'Ulasan terkirim. Terima kasih!',
        aboveNavBar: true,
      );
    } else if (!ref
        .read(ulasanViewModelProvider(widget.bookingId))
        .ratingError) {
      TsSnackbar.error(
        context,
        'Gagal mengirim ulasan. Coba lagi.',
        aboveNavBar: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = ulasanViewModelProvider(widget.bookingId);
    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: TsAppBar.back(title: 'Beri ulasan', onBack: _goBack),
      body: SafeArea(
        top: false,
        child: state.hasError
            ? ErrorState(
                message: 'Gagal memuat halaman ulasan. Coba lagi.',
                onRetry: viewModel.retry,
                layout: ErrorStateLayout.fullPage,
              )
            : !state.isReady
            ? const _UlasanSkeleton()
            : state.blockedUnpaid
            ? EmptyState(
                icon: Icons.lock_outline_rounded,
                title: UlasanState.unpaidReason,
                body: 'Ulasan bisa dikirim setelah invoice ditandai lunas.',
                ctaLabel: 'Buka invoice',
                onCta: () =>
                    context.pushReplacement(Routes.invoice(widget.bookingId)),
              )
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 560),
                          child: state.isSubmitted
                              ? ReviewRecap(
                                  review: state.submitted!,
                                  workshopName: state.workshopName,
                                  mechanics: state.mechanics,
                                )
                              : _UlasanForm(
                                  state: state,
                                  controller: _commentController,
                                  onWorkshopRating: viewModel.setWorkshopRating,
                                  onMechanicRating: viewModel.setMechanicRating,
                                  onComment: viewModel.setComment,
                                ),
                        ),
                      ),
                    ),
                  ),
                  _UlasanBar(
                    submitted: state.isSubmitted,
                    isSubmitting: state.isSubmitting,
                    onSubmit: _submit,
                    onBack: _goBack,
                  ),
                ],
              ),
      ),
    );
  }
}

class _UlasanForm extends StatelessWidget {
  const _UlasanForm({
    required this.state,
    required this.controller,
    required this.onWorkshopRating,
    required this.onMechanicRating,
    required this.onComment,
  });

  final UlasanState state;
  final TextEditingController controller;
  final ValueChanged<int> onWorkshopRating;
  final void Function(String mechanicId, int value) onMechanicRating;
  final ValueChanged<String> onComment;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            border: state.ratingError
                ? Border.all(color: ext.danger, width: 1.5)
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bagaimana servis di ${state.workshopName}?',
                style: textTheme.titleSmall?.copyWith(color: scheme.onSurface),
              ),
              const SizedBox(height: 12),
              RatingStars.input(
                value: state.workshopRating,
                onChanged: onWorkshopRating,
                semanticLabel: 'Nilai bengkel',
              ),
              const SizedBox(height: 8),
              RatingLabel(value: state.workshopRating),
              if (state.ratingError) ...[
                const SizedBox(height: 8),
                Semantics(
                  liveRegion: true,
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 16,
                        color: ext.dangerText,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          UlasanState.ratingRequired,
                          style: textTheme.bodySmall?.copyWith(
                            color: ext.dangerText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        TsTextField(
          label: 'Komentar (opsional)',
          placeholder: 'Ceritakan pengalamanmu (opsional)',
          controller: controller,
          onChanged: onComment,
          maxLines: 4,
          maxLength: Review.workshopCommentMaxLength,
          keyboardType: TextInputType.multiline,
        ),
        if (state.showMechanicSection) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            decoration: BoxDecoration(
              border: Border.all(color: ext.borderDefault),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nilai montir',
                  style: textTheme.titleSmall?.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
                Text(
                  'Lebih dari satu montir menangani motormu.',
                  style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
                ),
                const SizedBox(height: 4),
                for (final m in state.mechanics)
                  MechanicRatingRow(
                    name: m.name,
                    initial: m.initial,
                    unitsLabel: m.unitsLabel,
                    value: state.mechanicRatings[m.mechanicId] ?? 0,
                    onChanged: (v) => onMechanicRating(m.mechanicId, v),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _UlasanBar extends StatelessWidget {
  const _UlasanBar({
    required this.submitted,
    required this.isSubmitting,
    required this.onSubmit,
    required this.onBack,
  });

  final bool submitted;
  final bool isSubmitting;
  final VoidCallback onSubmit;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: BorderSide(color: ext.borderDefault)),
      ),
      child: submitted
          ? TsButton(label: 'Kembali ke detail booking', onPressed: onBack)
          : TsButton(
              label: 'Kirim ulasan',
              loadingLabel: 'Mengirim ulasan',
              isLoading: isSubmitting,
              onPressed: onSubmit,
            ),
    );
  }
}

class _UlasanSkeleton extends StatelessWidget {
  const _UlasanSkeleton();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: 'Memuat halaman ulasan',
      child: const SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          children: [
            SkeletonBlock(
              height: 140,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            SizedBox(height: 16),
            SkeletonBlock(
              height: 120,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ],
        ),
      ),
    );
  }
}
