class Transfer {
  final String transferId;
  final String senderWalletId;
  final String receiverWalletId;
  final double amount;
  final String status;
  final String initiatedAt;
  final String? completedAt;

  Transfer({
    required this.transferId,
    required this.senderWalletId,
    required this.receiverWalletId,
    required this.amount,
    required this.status,
    required this.initiatedAt,
    this.completedAt,
  });

  Map<String, dynamic> toMap() => {
        'transfer_id': transferId,
        'sender_wallet_id': senderWalletId,
        'receiver_wallet_id': receiverWalletId,
        'amount': amount,
        'status': status,
        'initiated_at': initiatedAt,
        'completed_at': completedAt,
      };

  factory Transfer.fromMap(Map<String, dynamic> map) => Transfer(
        transferId: map['transfer_id'],
        senderWalletId: map['sender_wallet_id'],
        receiverWalletId: map['receiver_wallet_id'],
        amount: map['amount'],
        status: map['status'],
        initiatedAt: map['initiated_at'],
        completedAt: map['completed_at'],
      );
}
