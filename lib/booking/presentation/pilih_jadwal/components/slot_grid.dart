import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/domain/model/workshop/time_slot.dart';

double slotRowExtent(BuildContext context) =>
    math.max(54, MediaQuery.textScalerOf(context).scale(40) + 18);

class SlotGrid extends StatelessWidget {
  const SlotGrid({required this.slots, required this.chipBuilder, super.key});

  final List<TimeSlot> slots;
  final Widget Function(TimeSlot slot) chipBuilder;

  @override
  Widget build(BuildContext context) {
    final extent = slotRowExtent(context);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        mainAxisExtent: extent,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) => chipBuilder(slots[index]),
    );
  }
}
