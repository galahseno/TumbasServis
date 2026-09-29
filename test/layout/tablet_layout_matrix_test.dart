import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbas_servis/booking/presentation/detail_servis/detail_servis_page.dart';
import 'package:tumbas_servis/booking/presentation/pilih_jadwal/pilih_jadwal_page.dart';
import 'package:tumbas_servis/booking/presentation/pilih_motor/pilih_motor_page.dart';
import 'package:tumbas_servis/booking/presentation/ringkasan/ringkasan_page.dart';
import 'package:tumbas_servis/booking/presentation/tiket/tiket_page.dart';
import 'package:tumbas_servis/booking/presentation/voucher/voucher_page.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_draft.dart';
import 'package:tumbas_servis/workshop/presentation/detail_bengkel/detail_bengkel_page.dart';
import 'package:tumbas_servis/workshop/presentation/detail_bengkel/state/detail_bengkel_state.dart';
import 'package:tumbas_servis/workshop/presentation/pilih_bengkel/pilih_bengkel_page.dart';

import '../support/layout_test_harness.dart';

const tabletSizes = [
  Size(800, 1280),
  Size(1280, 800),
  Size(1024, 768),
  Size(673, 841),
];
const textScales = [1.0, 1.3];

class _Case {
  const _Case(this.screen, {this.overrides});

  final Widget Function() screen;
  final List<Override> Function()? overrides;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  final splitDraft = layoutDraft().copyWith(
    scheduleMode: ScheduleMode.split,
    sharedSlot: null,
    unitSlots: {'m_vario': layoutSlot},
  );

  final cases = <String, _Case>{
    'S10 Pilih motor': _Case(PilihMotorPage.new),
    'S11 Detail servis (3 units)': _Case(DetailServisPage.new),
    'S11 Detail servis (1 unit)': _Case(
      DetailServisPage.new,
      overrides: () => layoutFakes(draft: layoutDraft(motors: ['m_vario'])),
    ),
    'S13 Pilih bengkel': _Case(
      PilihBengkelPage.new,
      overrides: () => layoutFakes(workshops: layoutWorkshops),
    ),
    'S14 Detail bengkel (in flow)': _Case(
      () => const DetailBengkelPage(
        workshopId: 'ws_001',
        variant: WorkshopDetailVariant.inFlow,
      ),
    ),
    'S14 Detail bengkel (standalone)': _Case(
      () => const DetailBengkelPage(
        workshopId: 'ws_001',
        variant: WorkshopDetailVariant.standalone,
      ),
    ),
    'S15 Pilih jadwal (shared)': _Case(PilihJadwalPage.new),
    'S15 Pilih jadwal (split)': _Case(
      PilihJadwalPage.new,
      overrides: () => layoutFakes(draft: splitDraft),
    ),
    'S16 Ringkasan': _Case(RingkasanPage.new),
    'S17 Voucher': _Case(() => const LayoutSummaryReady(child: VoucherPage())),
    'S18 Tiket': _Case(() => const TiketPage(bookingId: 'bk_1')),
  };

  for (final entry in cases.entries) {
    for (final size in tabletSizes) {
      for (final scale in textScales) {
        testWidgets('${entry.key} ${size.width.toInt()}×${size.height.toInt()} '
            '@ text ×$scale: no overflow', (tester) async {
          final errors = captureLayoutErrors();
          await pumpLayoutScreen(
            tester,
            entry.value.screen(),
            size: size,
            scale: scale,
            overrides: entry.value.overrides?.call(),
          );

          expectNoLayoutErrors(errors);
        });
      }
    }
  }

  for (final entry in cases.entries) {
    for (final size in tabletSizes) {
      testWidgets('${entry.key} ${size.width.toInt()}×${size.height.toInt()} '
          'loading skeleton: no overflow', (tester) async {
        final errors = captureLayoutErrors();
        await pumpLayoutScreen(
          tester,
          entry.value.screen(),
          size: size,
          scale: 1.3,
          overrides: entry.value.overrides?.call(),
          settleFrames: 0,
        );
        for (var i = 0; i < 20; i++) {
          await tester.pump(const Duration(milliseconds: 50));
        }

        expectNoLayoutErrors(errors);
      });
    }
  }
}
