import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class AuthService {
  /// Membaca users.json dan mencocokkan username & password.
  static Future<bool> login(String username, String password) async {
    try {
      final raw = await rootBundle.loadString('assets/data/users.json');
      final List<dynamic> users = json.decode(raw);

      final found = users.any((u) =>
          (u['username']?.toString() ?? '') == username &&
          (u['password']?.toString() ?? '') == password);

      return found;
    } catch (_) {
      // Jika file/parse error, anggap gagal login
      return false;
    }
  }
}
