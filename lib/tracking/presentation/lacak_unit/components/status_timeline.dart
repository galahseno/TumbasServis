import 'package:flutter/material.dart';
import 'package:tumbas_servis/core/domain/model/booking/booking_unit.dart';
import 'package:tumbas_servis/core/domain/model/booking/unit_status.dart';
import 'package:tumbas_servis/core/presentation/theme/ts_theme_extension.dart';
import 'package:tumbas_servis/tracking/presentation/utils/tracking_display.dart';

enum TimelineNodeState { done, current, pending, cancelled }

class _NodeData {
  const _NodeData({
    required this.status,
    required this.state,
    required this.label,
    this.stamp,
    this.caption,
  });

  final UnitStatus status;
  final TimelineNodeState state;
  final String label;
  final String? stamp;
  final String? caption;
}

IconData _iconFor(UnitStatus status) => switch (status) {
  UnitStatus.terjadwal || UnitStatus.unknown => Icons.event_rounded,
  UnitStatus.checkIn => Icons.hourglass_top_rounded,
  UnitStatus.diperiksa => Icons.search_rounded,
  UnitStatus.dikerjakan => Icons.build_rounded,
  UnitStatus.qc => Icons.fact_check_outlined,
  UnitStatus.selesai => Icons.check_circle_outline_rounded,
  UnitStatus.dibatalkan => Icons.cancel_outlined,
};

String? _currentCaption(UnitStatus status, String? startedAt) {
  final base = switch (status) {
    UnitStatus.terjadwal || UnitStatus.unknown => 'Menunggu kedatangan',
    UnitStatus.checkIn => 'Menunggu giliran',
    UnitStatus.diperiksa => 'Sedang diperiksa',
    UnitStatus.dikerjakan => 'Sedang dikerjakan',
    UnitStatus.qc => 'Sedang QC',
    UnitStatus.selesai || UnitStatus.dibatalkan => null,
  };
  if (base == null) return null;
  return startedAt == null || status == UnitStatus.terjadwal
      ? base
      : '$base · mulai $startedAt';
}

List<_NodeData> _buildNodes(BookingUnit unit, DateTime reference) {
  String? stampOf(UnitStatus status) {
    final event = eventFor(unit, status);
    return event == null
        ? null
        : timelineStamp(event.timestamp, reference: reference);
  }

  if (unit.status == UnitStatus.dibatalkan) {
    final reached = <UnitStatus>[];
    for (final event in unit.statusHistory) {
      if (event.status == UnitStatus.dibatalkan ||
          event.status == UnitStatus.unknown ||
          reached.contains(event.status)) {
        continue;
      }
      reached.add(event.status);
    }
    if (reached.isEmpty) reached.add(UnitStatus.terjadwal);
    final cancel = cancelEvent(unit);
    final reason = cancelReason(cancel);
    return [
      for (final status in reached)
        _NodeData(
          status: status,
          state: TimelineNodeState.done,
          label: status.timelineLabel,
          stamp: stampOf(status),
        ),
      _NodeData(
        status: UnitStatus.dibatalkan,
        state: TimelineNodeState.cancelled,
        label: 'Dibatalkan',
        stamp: cancel == null
            ? null
            : '${timelineStamp(cancel.timestamp, reference: reference)}'
                  ' · ${reason ?? 'sebelum servis dimulai'}',
      ),
    ];
  }

  final currentIndex = unit.status.stageIndex;
  final finished = unit.status == UnitStatus.selesai;
  return [
    for (var i = 0; i < timelineStages.length; i++)
      _NodeData(
        status: timelineStages[i],
        state: finished || i < currentIndex
            ? TimelineNodeState.done
            : i == currentIndex
            ? TimelineNodeState.current
            : TimelineNodeState.pending,
        label: timelineStages[i].timelineLabel,
        stamp: i <= currentIndex ? stampOf(timelineStages[i]) : null,
        caption: !finished && i == currentIndex
            ? _currentCaption(
                timelineStages[i],
                eventFor(unit, timelineStages[i]) == null
                    ? null
                    : timeOnly(eventFor(unit, timelineStages[i])!.timestamp),
              )
            : null,
      ),
  ];
}

class StatusTimeline extends StatefulWidget {
  const StatusTimeline({required this.unit, required this.now, super.key});

  final BookingUnit unit;
  final DateTime now;

  @override
  State<StatusTimeline> createState() => _StatusTimelineState();
}

class _StatusTimelineState extends State<StatusTimeline>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );

  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nodes = _buildNodes(widget.unit, widget.now);
    return Semantics(
      container: true,
      label: 'Riwayat status unit',
      child: Column(
        children: [
          for (var i = 0; i < nodes.length; i++)
            FadeTransition(
              opacity: CurvedAnimation(
                parent: _controller,
                curve: Interval(
                  (i * 0.08).clamp(0.0, 0.6),
                  ((i * 0.08) + 0.4).clamp(0.0, 1.0),
                ),
              ),
              child: _TimelineRow(
                node: nodes[i],
                isLast: i == nodes.length - 1,
              ),
            ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.node, required this.isLast});

  final _NodeData node;
  final bool isLast;

  static const double _circle = 36;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = TsThemeExtension.of(context);
    final textTheme = Theme.of(context).textTheme;

    final (Color fill, Color iconColor, Color? border) = switch (node.state) {
      TimelineNodeState.done => (scheme.primary, scheme.onPrimary, null),
      TimelineNodeState.current => (
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
        scheme.primary,
      ),
      TimelineNodeState.pending => (
        scheme.surfaceContainerLow,
        ext.textFaint,
        ext.borderDefault,
      ),
      TimelineNodeState.cancelled => (
        ext.dangerSoft,
        ext.dangerText,
        ext.danger,
      ),
    };
    final lineColor = node.state == TimelineNodeState.done
        ? scheme.primary
        : ext.borderDefault;
    final labelColor = switch (node.state) {
      TimelineNodeState.pending => ext.textMuted,
      TimelineNodeState.cancelled => ext.dangerText,
      _ => scheme.onSurface,
    };
    final semanticsState = switch (node.state) {
      TimelineNodeState.done => 'selesai',
      TimelineNodeState.current => 'saat ini',
      TimelineNodeState.pending => 'belum',
      TimelineNodeState.cancelled => 'dibatalkan',
    };

    return Semantics(
      label:
          '${node.label}, $semanticsState'
          '${node.stamp != null ? ', ${node.stamp}' : ''}'
          '${node.caption != null ? ', ${node.caption}' : ''}',
      excludeSemantics: true,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: _circle,
              child: Column(
                children: [
                  Container(
                    width: _circle,
                    height: _circle,
                    decoration: BoxDecoration(
                      color: fill,
                      shape: BoxShape.circle,
                      border: border == null
                          ? null
                          : Border.all(
                              color: border,
                              width: node.state == TimelineNodeState.current
                                  ? 3
                                  : 1.5,
                            ),
                    ),
                    child: Icon(
                      _iconFor(node.status),
                      size: 18,
                      color: iconColor,
                    ),
                  ),
                  if (!isLast)
                    Expanded(child: Container(width: 2, color: lineColor)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 6, bottom: isLast ? 0 : 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            node.label,
                            style: textTheme.titleMedium?.copyWith(
                              color: labelColor,
                              fontWeight:
                                  node.state == TimelineNodeState.current
                                  ? FontWeight.w800
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        if (node.stamp != null)
                          Flexible(
                            child: Text(
                              node.stamp!,
                              textAlign: TextAlign.end,
                              style: textTheme.bodySmall?.copyWith(
                                color: ext.textMuted,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (node.caption != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          node.caption!,
                          style: textTheme.bodySmall?.copyWith(
                            color: ext.textAccent,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
