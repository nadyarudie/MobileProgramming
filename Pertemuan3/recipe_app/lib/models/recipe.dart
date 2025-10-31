// lib/models/recipe.dart

class Recipe {
  final String title;
  final String imageUrl;
  final String duration;
  final String difficulty;
  final String category;

  final double rating;
  final List<String> ingredients; // BARU: Tambahkan ini
  final List<String> steps;

  Recipe({
    required this.title,
    required this.imageUrl,
    required this.duration,
    required this.difficulty,
    required this.rating,
    required this.category,

    required this.ingredients, // BARU: Tambahkan ini
    required this.steps,
  });
}