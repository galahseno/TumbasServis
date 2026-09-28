enum UnitStatus {
  terjadwal,
  checkIn,
  diperiksa,
  dikerjakan,
  qc,
  selesai,
  dibatalkan,
  unknown,
}

extension UnitStatusX on UnitStatus {
  static UnitStatus fromString(String? value) => switch (value) {
    'terjadwal' => UnitStatus.terjadwal,
    'checkIn' => UnitStatus.checkIn,
    'diperiksa' => UnitStatus.diperiksa,
    'dikerjakan' => UnitStatus.dikerjakan,
    'qc' => UnitStatus.qc,
    'selesai' => UnitStatus.selesai,
    'dibatalkan' => UnitStatus.dibatalkan,
    _ => UnitStatus.unknown,
  };

  static const List<UnitStatus> _forwardOrder = [
    UnitStatus.terjadwal,
    UnitStatus.checkIn,
    UnitStatus.diperiksa,
    UnitStatus.dikerjakan,
    UnitStatus.qc,
    UnitStatus.selesai,
  ];

  bool get isTerminal =>
      this == UnitStatus.selesai || this == UnitStatus.dibatalkan;

  int get stageIndex {
    final index = _forwardOrder.indexOf(this);
    return index == -1 ? 0 : index;
  }

  bool canTransitionTo(UnitStatus target) {
    if (target == UnitStatus.dibatalkan) return !isTerminal;
    final currentIndex = _forwardOrder.indexOf(this);
    final targetIndex = _forwardOrder.indexOf(target);
    if (currentIndex == -1 || targetIndex == -1) return false;
    return targetIndex == currentIndex + 1;
  }
}
