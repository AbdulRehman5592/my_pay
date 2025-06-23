import 'package:sqflite/sqflite.dart';

import '../data/helpers/database_helper.dart';
import '../data/models/user.dart';

class AuthService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Map<String, dynamic>>> signIn(
      String email, String hashedPassword) async {
    final db = await _dbHelper.database;

    // Query user with email and hashed password
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT u.user_id, u.email, u.full_name, u.phone, w.balance
      FROM Users u
      LEFT JOIN Wallets w ON u.user_id = w.user_id AND w.is_active = 1
      WHERE u.email = ? AND u.hashed_password = ?
    ''', [email, hashedPassword]);

    return result;
  }

  Future<bool> doesUserExist(String email) async {
    final db = await _dbHelper.database;

    final result = await db.query(
      'Users',
      where: 'email = ?',
      whereArgs: [email],
    );

    return result.isNotEmpty; // true if user exists
  }

  Future<String> signUp(User user) async {
    final db = await _dbHelper.database;

    try {
      // Insert user
      await db.insert('Users', user.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);

      // Create a default wallet for the user
      await db.insert('Wallets', {
        'wallet_id': 'wallet_${user.userId}',
        'user_id': user.userId,
        'currency_code': 'IDR',
        'balance': 0.0,
        'is_active': 1,
      });

      return "success";
    } catch (e) {
      return "error: $e";
    }
  }
}
