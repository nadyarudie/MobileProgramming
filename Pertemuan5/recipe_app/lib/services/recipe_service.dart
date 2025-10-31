import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class RecipeService {
  static const String _baseUrl = 'https://dummyjson.com/';

  /// Fetches all recipes from the API.
  Future<List<Recipe>> fetchRecipes() async {
    final response = await http.get(Uri.parse('${_baseUrl}recipes'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List recipesJson = json['recipes'];
      return recipesJson.map((recipe) => Recipe.fromJson(recipe)).toList();
    } else {
      throw Exception('Gagal memuat resep dari server');
    }
  }
}