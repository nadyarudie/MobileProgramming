// lib/services/recipe_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class RecipeService {
  // Alamat dasar dari API
  static const String _baseUrl = 'https://dummyjson.com/';

  /// Mengambil semua resep dari API.
  /// Metode ini bukan lagi static agar sesuai dengan pola Dependency Injection.
  Future<List<Recipe>> fetchRecipes() async {
    final response = await http.get(Uri.parse('${_baseUrl}recipes'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List recipesJson = json['recipes'];
      return recipesJson.map((recipe) => Recipe.fromJson(recipe)).toList();
    } else {
      // Melemparkan exception jika request gagal.
      throw Exception('Gagal memuat resep dari server');
    }
  }
}