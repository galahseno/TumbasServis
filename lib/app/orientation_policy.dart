import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tumbas_servis/core/presentation/utils/window_size_class.dart';

List<DeviceOrientation> preferredOrientationsFor(Size displaySize) =>
    isTabletSize(displaySize)
    ? DeviceOrientation.values
    : const [DeviceOrientation.portraitUp];

class OrientationPolicy extends StatefulWidget {
  const OrientationPolicy({required this.child, super.key});

  final Widget child;

  @override
  State<OrientationPolicy> createState() => _OrientationPolicyState();
}

class _OrientationPolicyState extends State<OrientationPolicy>
    with WidgetsBindingObserver {
  List<DeviceOrientation>? _applied;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _apply();
  }

  @override
  void didChangeMetrics() => _apply();

  void _apply() {
    final view = View.maybeOf(context);
    final display = view?.display;
    if (display == null) return;
    final orientations = preferredOrientationsFor(
      display.size / display.devicePixelRatio,
    );
    if (listEquals(orientations, _applied)) return;
    _applied = orientations;
    SystemChrome.setPreferredOrientations(orientations);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
