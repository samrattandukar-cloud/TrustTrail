enum UserRole { owner, buyer }

class User {
  const User({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.role,
    this.locale,
    this.isDemo = false,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String phone;
  final String? email;
  final UserRole role;
  final String? locale;
  final bool isDemo;
  final DateTime createdAt;

  String get firstName => name.trim().split(RegExp(r'\s+')).first;

  Map<String, Object?> toMap() => {
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
    'role': role.name,
    'locale': locale,
    'is_demo': isDemo ? 1 : 0,
    'created_at': createdAt.toIso8601String(),
  };

  factory User.fromMap(Map<String, Object?> map) => User(
    id: map['id'] as String,
    name: map['name'] as String,
    phone: map['phone'] as String,
    email: map['email'] as String?,
    role: UserRole.values.firstWhere(
      (role) => role.name == map['role'],
      orElse: () => UserRole.owner,
    ),
    locale: map['locale'] as String?,
    isDemo: (map['is_demo'] as int? ?? 0) == 1,
    createdAt: DateTime.parse(map['created_at'] as String),
  );
}
