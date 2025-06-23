import 'package:sqflite/sqflite.dart';

import '../helpers/database_helper.dart';
import '../models/transaction.dart';

class TransactionRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<void> insertTransaction(TransactionModel txn) async {
    final db = await dbHelper.database;
    await db.insert('Transactions', txn.toMap());
  }

  Future<List<TransactionModel>> getWalletTransactions(String walletId) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'Transactions',
      where: 'wallet_id = ?',
      whereArgs: [walletId],
    );
    return result.map((e) => TransactionModel.fromMap(e)).toList();
  }

  Future<void> updateTransactionStatus(String txnId, String newStatus) async {
    final db = await dbHelper.database;
    await db.update(
      'Transactions',
      {'status': newStatus},
      where: 'txn_id = ?',
      whereArgs: [txnId],
    );
  }

  Future<void> addTransaction(TransactionModel txn) async {
    final db = await dbHelper.database;

    await db.insert(
      'transactions',
      txn.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Optionally update wallet balance
    if (txn.txnType == 'deposit') {
      await db.rawUpdate(
        'UPDATE wallets SET balance = balance + ? WHERE wallet_id = ?',
        [txn.amount, txn.walletId],
      );
    } else if (txn.txnType == 'withdrawal') {
      await db.rawUpdate(
        'UPDATE wallets SET balance = balance - ? WHERE wallet_id = ?',
        [txn.amount, txn.walletId],
      );
    }
  }
}
