class InvoiceLine {
  const InvoiceLine({
    required this.unitCode,
    required this.label,
    required this.qty,
    required this.price,
  });

  final String unitCode;
  final String label;
  final int qty;
  final int price;

  InvoiceLine copyWith({
    String? unitCode,
    String? label,
    int? qty,
    int? price,
  }) {
    return InvoiceLine(
      unitCode: unitCode ?? this.unitCode,
      label: label ?? this.label,
      qty: qty ?? this.qty,
      price: price ?? this.price,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoiceLine &&
          other.unitCode == unitCode &&
          other.label == label &&
          other.qty == qty &&
          other.price == price);

  @override
  int get hashCode => Object.hash(unitCode, label, qty, price);
}
