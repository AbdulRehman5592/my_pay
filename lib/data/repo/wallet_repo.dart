import '../helpers/database_helper.dart';
import '../models/wallet.dart';

class WalletRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<void> insertWallet(Wallet wallet) async {
    final db = await dbHelper.database;
    await db.insert('Wallets', wallet.toMap());
  }

  Future<List<Wallet>> getWalletsForUser(String userId) async {
    final db = await dbHelper.database;
    final maps =
        await db.query('Wallets', where: 'user_id = ?', whereArgs: [userId]);
    return maps.map((e) => Wallet.fromMap(e)).toList();
  }

  Future<Wallet?> getWalletById(String id) async {
    final db = await dbHelper.database;
    final maps =
        await db.query('Wallets', where: 'wallet_id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Wallet.fromMap(maps.first);
    }
    return null;
  }

  Future<void> updateBalance(String walletId, double newBalance) async {
    final db = await dbHelper.database;
    await db.update(
      'Wallets',
      {'balance': newBalance},
      where: 'wallet_id = ?',
      whereArgs: [walletId],
    );
  }

  Future<double> getBalance(String userId) async {
    final db = await dbHelper.database;

    final result = await db.rawQuery(
      'SELECT balance FROM wallets WHERE user_id = ?',
      [userId],
    );

    if (result.isNotEmpty && result.first['balance'] != null) {
      return result.first['balance'] as double;
    }

    // Return 0.0 if no wallet found
    return 0.0;
  }
}
