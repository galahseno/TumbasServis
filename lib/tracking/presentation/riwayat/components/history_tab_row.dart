import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/tracking/presentation/riwayat/state/riwayat_state.dart';

class HistoryTabRow extends StatefulWidget {
  const HistoryTabRow({
    required this.selected,
    required this.countFor,
    required this.onSelected,
    super.key,
  });

  final RiwayatTab selected;
  final int Function(RiwayatTab tab) countFor;
  final ValueChanged<RiwayatTab> onSelected;

  @override
  State<HistoryTabRow> createState() => _HistoryTabRowState();
}

class _HistoryTabRowState extends State<HistoryTabRow> {
  final Map<RiwayatTab, GlobalKey> _keys = {
    for (final tab in RiwayatTab.values) tab: GlobalKey(),
  };

  @override
  void didUpdateWidget(HistoryTabRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) _scrollActiveIntoView();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollActiveIntoView(),
    );
  }

  void _scrollActiveIntoView() {
    final context = _keys[widget.selected]?.currentContext;
    if (context == null || !context.mounted) return;
    Scrollable.ensureVisible(
      context,
      alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ext = TsThemeExtension.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: ext.borderDefault)),
      ),
      child: Semantics(
        container: true,
        label: 'Filter status booking',
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              for (final tab in RiwayatTab.values)
                _HistoryTab(
                  key: _keys[tab],
                  tab: tab,
                  count: widget.countFor(tab),
                  active: tab == widget.selected,
                  onTap: () => widget.onSelected(tab),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({
    required this.tab,
    required this.count,
    required this.active,
    required this.onTap,
    super.key,
  });

  final RiwayatTab tab;
  final int count;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final color = active ? ext.textAccent : ext.textMuted;

    return Semantics(
      button: true,
      selected: active,
      label: '${tab.label}, $count booking',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(right: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 45,
                child: Center(
                  child: Text(
                    '${tab.label} · $count',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: color,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ),
              Container(
                height: 3,
                decoration: BoxDecoration(
                  color: active ? scheme.primary : Colors.transparent,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(3),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
