import '../helpers/database_helper.dart';
import '../models/user.dart';

class UserRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<void> insertUser(User user) async {
    final db = await dbHelper.database;
    await db.insert('Users', user.toMap());
  }

  Future<User?> getUserById(String id) async {
    final db = await dbHelper.database;
    final maps = await db.query('Users', where: 'user_id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<List<User>> getAllUsers() async {
    final db = await dbHelper.database;
    final maps = await db.query('Users');
    return maps.map((e) => User.fromMap(e)).toList();
  }

  Future<int> deleteUser(String id) async {
    final db = await dbHelper.database;
    return await db.delete('Users', where: 'user_id = ?', whereArgs: [id]);
  }
}
