// lib/services/recipe_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class RecipeService {
  // Alamat dasar dari API baru
  static const String _baseUrl = 'https://dummyjson.com/';

  // Fungsi untuk mengambil semua resep
  static Future<List<Recipe>> fetchAllRecipes() async {
    final response = await http.get(Uri.parse('${_baseUrl}recipes'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List recipesJson = json['recipes'];
      return recipesJson.map((recipe) => Recipe.fromJson(recipe)).toList();
    } else {
      throw Exception('Gagal memuat semua resep');
    }
  }
}