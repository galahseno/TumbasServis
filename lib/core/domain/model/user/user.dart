class User {
  const User({
    required this.id,
    required this.name,
    required this.phone,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final String phone;
  final String? avatarUrl;

  User copyWith({String? id, String? name, String? phone, String? avatarUrl}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is User && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
