class Wallet {
  final String walletId;
  final String userId;
  final String currencyCode;
  final double balance;
  final bool isActive;

  Wallet({
    required this.walletId,
    required this.userId,
    required this.currencyCode,
    this.balance = 0.0,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() => {
        'wallet_id': walletId,
        'user_id': userId,
        'currency_code': currencyCode,
        'balance': balance,
        'is_active': isActive ? 1 : 0,
      };

  factory Wallet.fromMap(Map<String, dynamic> map) => Wallet(
        walletId: map['wallet_id'],
        userId: map['user_id'],
        currencyCode: map['currency_code'],
        balance: map['balance'],
        isActive: map['is_active'] == 1,
      );
}
