import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // GANTI DENGAN URL NGROK BARU ANDA (Setiap restart ngrok berubah!)
  static const String _baseUrl = 'https://nickolas-phonetic-unsqueamishly.ngrok-free.dev/'; 
  
  static const _userKey = 'current_username';

  // Fungsi Register (POST)
  Future<bool> register(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${_baseUrl}register'),
        headers: {
          'Content-Type': 'application/json',
          "ngrok-skip-browser-warning": "true",
        },
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 201) {
        return true; // Berhasil daftar
      } else {
        print('Gagal daftar: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error register: $e');
      return false;
    }
  }

  // Fungsi Login (POST)
  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${_baseUrl}login'),
        headers: {
          'Content-Type': 'application/json',
          "ngrok-skip-browser-warning": "true",
        },
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userKey, username);
        return true;
      }
      return false;
    } catch (e) {
      print('Error login: $e');
      return false;
    }
  }

  // Fungsi untuk Test GET (Ambil semua user)
  Future<List<dynamic>> getAllUsers() async {
    try {
      final response = await http.get(
        Uri.parse('${_baseUrl}users'),
        headers: {"ngrok-skip-browser-warning": "true"},
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  Future<String?> restoreUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey);
  }
}