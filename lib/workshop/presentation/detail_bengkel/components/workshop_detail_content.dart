import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/domain/model/workshop/workshop.dart';
import 'package:tumbas_servis/workshop/presentation/detail_bengkel/components/address_row.dart';
import 'package:tumbas_servis/workshop/presentation/detail_bengkel/components/service_chips.dart';
import 'package:tumbas_servis/workshop/presentation/detail_bengkel/components/static_map.dart';
import 'package:tumbas_servis/workshop/presentation/detail_bengkel/components/workshop_info_block.dart';
import 'package:tumbas_servis/workshop/presentation/detail_bengkel/components/workshop_photo.dart';

enum WorkshopDetailLayout { stacked, split }

class WorkshopDetailContent extends StatelessWidget {
  const WorkshopDetailContent({
    required this.workshop,
    required this.statusLine,
    required this.open,
    required this.chosen,
    required this.serviceNames,
    required this.onCopyAddress,
    required this.onOpenMaps,
    this.layout = WorkshopDetailLayout.stacked,
    this.photoHeight,
    this.mapHeight,
    this.mediaFlex = 560,
    this.infoFlex = 648,
    super.key,
  });

  final Workshop workshop;
  final String statusLine;
  final bool open;
  final bool chosen;
  final List<String> serviceNames;
  final VoidCallback onCopyAddress;
  final VoidCallback onOpenMaps;
  final WorkshopDetailLayout layout;

  final double? photoHeight;
  final double? mapHeight;
  final int mediaFlex;
  final int infoFlex;

  @override
  Widget build(BuildContext context) {
    final info = WorkshopInfoBlock(
      workshop: workshop,
      statusLine: statusLine,
      open: open,
      chosen: chosen,
    );
    final chips = ServiceChips(names: serviceNames);
    final address = AddressRow(
      address: workshop.address,
      onCopy: onCopyAddress,
      onOpenMaps: onOpenMaps,
    );

    if (layout == WorkshopDetailLayout.split) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: mediaFlex,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: WorkshopPhoto(height: photoHeight),
                ),
                const SizedBox(height: 16),
                StaticMap(height: mapHeight),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: infoFlex,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                info,
                const SizedBox(height: 20),
                chips,
                const SizedBox(height: 20),
                address,
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WorkshopPhoto(height: photoHeight),
        Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0), child: info),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: StaticMap(height: mapHeight),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: chips,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: address,
        ),
      ],
    );
  }
}
