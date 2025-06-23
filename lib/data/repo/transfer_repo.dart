import '../helpers/database_helper.dart';
import '../models/transfer.dart';

class TransferRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<void> insertTransfer(Transfer transfer) async {
    final db = await dbHelper.database;
    await db.insert('Transfers', transfer.toMap());
  }

  Future<List<Transfer>> getTransfersForWallet(String walletId) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'Transfers',
      where: 'sender_wallet_id = ? OR receiver_wallet_id = ?',
      whereArgs: [walletId, walletId],
    );
    return result.map((e) => Transfer.fromMap(e)).toList();
  }

  Future<void> updateTransferStatus(String transferId, String newStatus) async {
    final db = await dbHelper.database;
    await db.update(
      'Transfers',
      {'status': newStatus},
      where: 'transfer_id = ?',
      whereArgs: [transferId],
    );
  }
}
