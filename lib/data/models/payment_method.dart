class PaymentMethod {
  final String methodId;
  final String userId;
  final String type; // 'card', 'bank', 'crypto'
  final String details; // JSON string

  final String addedAt;

  PaymentMethod({
    required this.methodId,
    required this.userId,
    required this.type,
    required this.details,
    required this.addedAt,
  });

  Map<String, dynamic> toMap() => {
        'method_id': methodId,
        'user_id': userId,
        'type': type,
        'details': details,
        'added_at': addedAt,
      };

  factory PaymentMethod.fromMap(Map<String, dynamic> map) => PaymentMethod(
        methodId: map['method_id'],
        userId: map['user_id'],
        type: map['type'],
        details: map['details'],
        addedAt: map['added_at'],
      );
}
