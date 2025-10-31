import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart'; // <-- 1. Import package

class AuthService {
  // Kunci untuk menyimpan username di SharedPreferences
  static const _userKey = 'current_username'; // <-- 2. Buat konstanta kunci

  Future<bool> login(String username, String password) async {
    final String jsonString = await rootBundle.loadString('assets/data/users.json');
    final List<dynamic> users = json.decode(jsonString);
    final user = users.firstWhere(
      (u) => u['username'] == username && u['password'] == password,
      orElse: () => null,
    );
    await Future.delayed(const Duration(milliseconds: 600));

    if (user != null) {
      // <-- 3. Jika login berhasil, simpan username
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, username);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    // <-- 4. Hapus username saat logout
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }

  Future<String?> restoreUser() async {
    // <-- 5. Baca username dari storage saat aplikasi mulai
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey);
  }
}