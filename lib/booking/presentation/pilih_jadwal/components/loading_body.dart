import 'package:flutter/material.dart';
import 'package:tumbas_servis/booking/presentation/components/booking_stepper.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/components/slot_grid.dart';
import 'package:tumbas_servis/core/presentation/components/max_width_box.dart';
import 'package:tumbas_servis/core/presentation/components/skeleton.dart';
import 'package:tumbas_servis/core/presentation/utils/window_size_class.dart';

const double stackedMaxWidth = 720.0;

class LoadingBody extends StatelessWidget {
  const LoadingBody({super.key});

  @override
  Widget build(BuildContext context) {
    final capped = !context.windowSizeClass.isCompact;
    Widget cap(Widget child) =>
        capped ? MaxWidthBox(maxWidth: stackedMaxWidth, child: child) : child;

    return Column(
      children: [
        BookingStepper(currentStep: 3),
        cap(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: SkeletonBlock(height: 40),
          ),
        ),
        cap(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SkeletonBlock(height: 48),
          ),
        ),
        Expanded(
          child: cap(
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              children: [
                const SkeletonBlock(height: 72),
                const SizedBox(height: 12),
                const SlotSkeletonGrid(),
              ],
            ),
          ),
        ),
        cap(
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: SkeletonBlock(height: 48),
          ),
        ),
      ],
    );
  }
}

class SlotSkeletonGrid extends StatelessWidget {
  const SlotSkeletonGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Memuat jam tersedia',
      child: ExcludeSemantics(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            mainAxisExtent: slotRowExtent(context),
          ),
          itemCount: 9,
          itemBuilder: (_, _) => const SkeletonBlock(height: 54),
        ),
      ),
    );
  }
}
