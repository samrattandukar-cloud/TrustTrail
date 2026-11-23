import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../models/user.dart';

class AuthRepository {
  AuthRepository(this._db);

  final Database _db;

  Future<User?> findById(String id) async {
    final rows = await _db.query('users', where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : User.fromMap(rows.first);
  }

  Future<User?> findByPhone(String phone) async {
    final normalized = _phoneKey(phone);
    final rows = await _db.query('users');
    for (final row in rows) {
      if (_phoneKey(row['phone'] as String) == normalized) {
        return User.fromMap(row);
      }
    }
    return null;
  }

  Future<User> register({
    required String name,
    required String phone,
    String? email,
    required UserRole role,
    String? locale,
    bool isDemo = false,
  }) async {
    final user = User(
      id: const Uuid().v4(),
      name: name.trim(),
      phone: phone.trim(),
      email: (email ?? '').trim().isEmpty ? null : email!.trim(),
      role: role,
      locale: locale,
      isDemo: isDemo,
      createdAt: DateTime.now(),
    );
    await _db.insert('users', user.toMap());
    return user;
  }

  Future<User> updateRole(String id, UserRole role) async {
    await _db.update(
      'users',
      {'role': role.name},
      where: 'id = ?',
      whereArgs: [id],
    );
    final user = await findById(id);
    if (user == null) throw StateError('User $id no longer exists');
    return user;
  }

  Future<User> demoOwner() async {
    final existing = await findById('demo-owner');
    if (existing != null) return existing;
    final user = User(
      id: 'demo-owner',
      name: 'Sujan Bajracharya',
      phone: '+977 9801234567',
      email: 'sujan.b@example.com',
      role: UserRole.owner,
      locale: 'en',
      isDemo: true,
      createdAt: DateTime.now(),
    );
    await _db.insert('users', user.toMap());
    return user;
  }

  Future<User> demoBuyer() async {
    final existing = await findById('demo-buyer');
    if (existing != null) return existing;
    final user = User(
      id: 'demo-buyer',
      name: 'Anita Gurung',
      phone: '+977 9812345678',
      role: UserRole.buyer,
      locale: 'en',
      isDemo: true,
      createdAt: DateTime.now(),
    );
    await _db.insert('users', user.toMap());
    return user;
  }

  static String _phoneKey(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    return digits.length > 10 ? digits.substring(digits.length - 10) : digits;
  }
}
