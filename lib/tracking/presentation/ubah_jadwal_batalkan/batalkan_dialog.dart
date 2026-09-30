import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/presentation/components/ts_button.dart';
import 'package:tumbas_servis/core/presentation/components/ts_chip.dart';
import 'package:tumbas_servis/core/presentation/components/ts_dialog.dart';
import 'package:tumbas_servis/tracking/presentation/ubah_jadwal_batalkan/components/cancel_scope_chooser.dart';

typedef BatalkanChoice = ({String? unitCode, String? reason});

const cancelReasons = [
  'Jadwal bentrok',
  'Berubah pikiran',
  'Harga tidak sesuai',
  'Lainnya',
];

List<CancelScopeOption> cancelScopeOptions(
  Booking booking, {
  required bool canCancelWhole,
}) {
  final liveUnits = booking.units
      .where((u) => u.status != UnitStatus.dibatalkan)
      .toList();
  final terjadwal = liveUnits
      .where((u) => u.status == UnitStatus.terjadwal)
      .toList();
  return [
    if (canCancelWhole)
      CancelScopeOption(label: 'Seluruh booking · ${liveUnits.length} motor'),
    if (liveUnits.length > 1)
      for (final unit in terjadwal)
        CancelScopeOption(
          label: 'Hanya ${unit.motorSnapshot.nickname} · Unit ${unit.unitCode}',
          unitCode: unit.unitCode,
        ),
  ];
}

Future<BatalkanChoice?> showBatalkanDialog(
  BuildContext context, {
  required Booking booking,
  required bool canCancelWhole,
}) {
  final options = cancelScopeOptions(booking, canCancelWhole: canCancelWhole);
  return TsDialog.custom<BatalkanChoice>(
    context,
    maxWidth: 400,
    builder: (_) => _BatalkanBody(options: options),
  );
}

class _BatalkanBody extends StatefulWidget {
  const _BatalkanBody({required this.options});

  final List<CancelScopeOption> options;

  @override
  State<_BatalkanBody> createState() => _BatalkanBodyState();
}

class _BatalkanBodyState extends State<_BatalkanBody> {
  var _selected = 0;
  String? _reason;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TsDialog.headerBlock(
            context,
            title: 'Batalkan booking?',
            message:
                'Pilih cakupan dan alasan pembatalan. '
                'Pembatalan tidak bisa diurungkan.',
          ),
          const SizedBox(height: 16),
          CancelScopeChooser(
            options: widget.options,
            selectedIndex: _selected,
            onChanged: (index) => setState(() => _selected = index),
          ),
          const SizedBox(height: 16),
          Text(
            'Alasan pembatalan (opsional)',
            style: textTheme.titleSmall?.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final reason in cancelReasons)
                TsChip(
                  label: reason,
                  selected: _reason == reason,
                  onSelected: (_) => setState(
                    () => _reason = _reason == reason ? null : reason,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TsButton(
                  label: 'Kembali',
                  type: TsButtonType.ghost,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TsButton(
                  label: 'Ya, batalkan',
                  type: TsButtonType.danger,
                  leadingIcon: Icons.delete_outline_rounded,
                  onPressed: () => Navigator.of(context).pop((
                    unitCode: widget.options[_selected].unitCode,
                    reason: _reason,
                  )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
