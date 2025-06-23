class User {
  final String userId;
  final String email;
  final String hashedPassword;
  final String fullName;
  final String? phone;

  User({
    required this.userId,
    required this.email,
    required this.hashedPassword,
    required this.fullName,
    this.phone,
  });

  Map<String, dynamic> toMap() => {
        'user_id': userId,
        'email': email,
        'hashed_password': hashedPassword,
        'full_name': fullName,
        'phone': phone,
      };

  factory User.fromMap(Map<String, dynamic> map) => User(
        userId: map['user_id'],
        email: map['email'],
        hashedPassword: map['hashed_password'],
        fullName: map['full_name'],
        phone: map['phone'],
      );
}
