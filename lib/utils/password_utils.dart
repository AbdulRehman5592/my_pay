import 'dart:convert';
import 'package:crypto/crypto.dart';

String hashPassword(String password) {
  final bytes = utf8.encode(password); // Convert to UTF-8
  final digest = sha256.convert(bytes); // Apply SHA-256
  return digest.toString(); // Return hex hash
}
