import 'dart:async';

class ManualTimerFactory {
  void Function()? _pending;
  var _cancelled = false;

  Timer call(Duration duration, void Function() callback) {
    _cancelled = false;
    _pending = callback;
    return _ManualTimer(this);
  }

  void fire() {
    final callback = _pending;
    _pending = null;
    callback?.call();
  }

  void _cancel() => _cancelled = true;
}

class _ManualTimer implements Timer {
  _ManualTimer(this._factory);

  final ManualTimerFactory _factory;

  @override
  bool get isActive => !_factory._cancelled;

  @override
  int get tick => 0;

  @override
  void cancel() => _factory._cancel();
}
