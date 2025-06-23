import '../helpers/database_helper.dart';
import '../models/payment_method.dart';

class PaymentMethodRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<void> insertPaymentMethod(PaymentMethod method) async {
    final db = await dbHelper.database;
    await db.insert('PaymentMethods', method.toMap());
  }

  Future<List<PaymentMethod>> getMethodsForUser(String userId) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'PaymentMethods',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return result.map((e) => PaymentMethod.fromMap(e)).toList();
  }

  Future<void> verifyMethod(String methodId) async {
    final db = await dbHelper.database;
    await db.update(
      'PaymentMethods',
      {'verified': 1},
      where: 'method_id = ?',
      whereArgs: [methodId],
    );
  }
}
