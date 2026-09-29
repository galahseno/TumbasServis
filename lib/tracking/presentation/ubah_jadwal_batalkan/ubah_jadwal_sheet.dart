import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/date_strip_item.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/slot_chip.dart';
import 'package:tumbas_servis/core/presentation/components/sheet_header.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/tracking/presentation/di/tracking_presentation_module.dart';
import 'package:tumbas_servis/tracking/presentation/ubah_jadwal_batalkan/state/ubah_jadwal_state.dart';

Future<bool> showUbahJadwalSheet(
  BuildContext context, {
  required UbahJadwalArgs args,
}) async {
  final saved = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: false,
    backgroundColor: Theme.of(context).colorScheme.surface,
    constraints: const BoxConstraints(maxWidth: 560),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => UbahJadwalSheet(args: args),
  );
  return saved ?? false;
}

class UbahJadwalSheet extends ConsumerWidget {
  const UbahJadwalSheet({required this.args, super.key});

  final UbahJadwalArgs args;

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final viewModel = ref.read(ubahJadwalViewModelProvider(args).notifier);
    final saved = await viewModel.save();
    if (saved && context.mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ubahJadwalViewModelProvider(args);
    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    final booking = args.booking;
    final unitCount = viewModel.unitCount;
    final current = viewModel.currentSlot;
    final currentIsOnDate =
        current != null &&
        DateUtils.isSameDay(current.date, state.selectedDate);
    final capacity = state.slots.isEmpty ? 5 : state.slots.first.capacity;

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SheetHeader(
            title: 'Ubah jadwal',
            subtitle: '${booking.code} · $unitCount motor',
            onClose: () => Navigator.of(context).pop(false),
          ),
          Divider(height: 1, color: ext.borderDefault),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _WorkshopCard(
                      name: args.workshopName,
                      bayCount: args.bayCount,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: viewModel.dates.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final date = viewModel.dates[index];
                        return DateStripItem(
                          date: date,
                          today: date == viewModel.today(),
                          selected: date == state.selectedDate,
                          onTap: () => viewModel.selectDate(date),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                    child: Text(
                      [
                        if (currentIsOnDate)
                          'Jam ${current.hour.toString().padLeft(2, '0')}.00 '
                              'adalah jadwal sekarang.',
                        'Kapasitas $capacity motor per jam.',
                      ].join(' '),
                      style: textTheme.bodySmall?.copyWith(
                        color: ext.textMuted,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: state.isLoadingSlots
                        ? const _SlotSkeleton()
                        : state.slotsError
                        ? _InlineError(
                            title: 'Gagal memuat jam',
                            message: 'Periksa koneksi lalu coba lagi.',
                            onRetry: viewModel.retrySlots,
                          )
                        : _SlotGrid(args: args, state: state),
                  ),
                  if (state.saveFailed)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: _InlineError(
                        title: 'Gagal menyimpan jadwal',
                        message: 'Koneksi terputus. Perubahan belum tersimpan.',
                        onRetry: () => _save(context, ref),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TsButton(
                  label: 'Simpan jadwal',
                  loadingLabel: 'Menyimpan jadwal',
                  isLoading: state.isSaving,
                  onPressed: state.selectedSlot == null
                      ? null
                      : () => _save(context, ref),
                ),
                if (state.selectedSlot == null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Pilih jam untuk tanggal ini',
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall?.copyWith(
                        color: ext.textMuted,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkshopCard extends StatelessWidget {
  const _WorkshopCard({required this.name, required this.bayCount});

  final String name;
  final int bayCount;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ext.borderDefault),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.storefront_rounded,
              size: 20,
              color: ext.textBody,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: textTheme.titleSmall?.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
                Text(
                  '$bayCount bay servis',
                  style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SlotGrid extends ConsumerWidget {
  const _SlotGrid({required this.args, required this.state});

  final UbahJadwalArgs args;
  final UbahJadwalState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(ubahJadwalViewModelProvider(args).notifier);
    final extent = math.max(
      54.0,
      MediaQuery.textScalerOf(context).scale(40) + 18,
    );
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        mainAxisExtent: extent,
      ),
      itemCount: state.slots.length,
      itemBuilder: (context, index) {
        final slot = state.slots[index];
        final selected =
            state.selectedSlot != null &&
            state.selectedSlot!.hour == slot.hour &&
            DateUtils.isSameDay(state.selectedSlot!.date, slot.date);
        return SlotChip(
          hour: slot.hour,
          chipState: viewModel.chipState(slot),
          remaining: slot.remaining,
          selected: selected,
          captionOverride: viewModel.isCurrent(slot) ? 'Jadwal sekarang' : null,
          onTap: () => viewModel.selectSlot(slot),
        );
      },
    );
  }
}

class _SlotSkeleton extends StatelessWidget {
  const _SlotSkeleton();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Memuat jam',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (var i = 0; i < 9; i++)
            const SkeletonBlock(width: 104, height: 54),
        ],
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({
    required this.title,
    required this.message,
    required this.onRetry,
  });

  final String title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ext.borderDefault),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ext.warningSoft,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_off_rounded,
                size: 20,
                color: ext.warningText,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleSmall?.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                  Text(
                    message,
                    style: textTheme.bodySmall?.copyWith(color: ext.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            TsButton(
              label: 'Coba lagi',
              type: TsButtonType.outline,
              compact: true,
              fullWidth: false,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
