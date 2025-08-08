import 'dart:convert';
import 'package:crypto/crypto.dart';

String hashPassword(String plain) {
  // 간단 SHA-256 해시 (원하면 salt 붙일 수 있음)
  final bytes = utf8.encode(plain);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
