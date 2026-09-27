enum MotorBrand { honda, yamaha, suzuki, kawasaki, unknown }

extension MotorBrandX on MotorBrand {
  static MotorBrand fromString(String? value) => switch (value) {
    'Honda' => MotorBrand.honda,
    'Yamaha' => MotorBrand.yamaha,
    'Suzuki' => MotorBrand.suzuki,
    'Kawasaki' => MotorBrand.kawasaki,
    _ => MotorBrand.unknown,
  };
}

enum MotorCategory { matic, bebek, sport, unknown }

extension MotorCategoryX on MotorCategory {
  static MotorCategory fromString(String? value) => switch (value) {
    'matic' => MotorCategory.matic,
    'bebek' => MotorCategory.bebek,
    'sport' => MotorCategory.sport,
    _ => MotorCategory.unknown,
  };
}

class MotorModel {
  const MotorModel({
    required this.id,
    required this.brand,
    required this.name,
    required this.category,
    required this.cc,
  });

  final String id;
  final MotorBrand brand;
  final String name;
  final MotorCategory category;
  final int cc;

  MotorModel copyWith({
    String? id,
    MotorBrand? brand,
    String? name,
    MotorCategory? category,
    int? cc,
  }) {
    return MotorModel(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      name: name ?? this.name,
      category: category ?? this.category,
      cc: cc ?? this.cc,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is MotorModel && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
