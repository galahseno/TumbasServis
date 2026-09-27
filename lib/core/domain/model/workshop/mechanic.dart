class Mechanic {
  const Mechanic({
    required this.id,
    required this.name,
    required this.avatarInitial,
    required this.rating,
  });

  final String id;
  final String name;
  final String avatarInitial;
  final double rating;

  Mechanic copyWith({
    String? id,
    String? name,
    String? avatarInitial,
    double? rating,
  }) {
    return Mechanic(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarInitial: avatarInitial ?? this.avatarInitial,
      rating: rating ?? this.rating,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Mechanic && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
