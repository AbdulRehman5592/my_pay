class TransactionModel {
  final String txnId;
  final String walletId;
  final String txnType; // 'deposit', 'withdrawal', etc.
  final double amount;
  final String status; // 'pending', 'completed', 'failed'
  final String? description;
  final String? referenceId;
  final String createdAt;

  TransactionModel({
    required this.txnId,
    required this.walletId,
    required this.txnType,
    required this.amount,
    required this.status,
    this.description,
    this.referenceId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'txn_id': txnId,
        'wallet_id': walletId,
        'txn_type': txnType,
        'amount': amount,
        'status': status,
        'description': description,
        'reference_id': referenceId,
        'created_at': createdAt,
      };

  factory TransactionModel.fromMap(Map<String, dynamic> map) =>
      TransactionModel(
        txnId: map['txn_id'],
        walletId: map['wallet_id'],
        txnType: map['txn_type'],
        amount: map['amount'],
        status: map['status'],
        description: map['description'],
        referenceId: map['reference_id'],
        createdAt: map['created_at'],
      );
}
