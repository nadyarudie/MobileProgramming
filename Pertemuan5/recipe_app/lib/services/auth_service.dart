import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  /// Key for storing the current user's username in SharedPreferences.
  static const _userKey = 'current_username';

  Future<bool> login(String username, String password) async {
    final String jsonString = await rootBundle.loadString('assets/data/users.json');
    final List<dynamic> users = json.decode(jsonString);
    final user = users.firstWhere(
      (u) => u['username'] == username && u['password'] == password,
      orElse: () => null,
    );
    await Future.delayed(const Duration(milliseconds: 600));

    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, username);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }

  /// Restores the last logged-in user from storage.
  Future<String?> restoreUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey);
  }
}