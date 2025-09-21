// lib/models/recipe.dart

class Recipe {
  final String title;
  final String imageUrl;
  final String duration;
  final String difficulty;
  final double rating;
  final String category; 

  Recipe({
    required this.title,
    required this.imageUrl,
    required this.duration,
    required this.difficulty,
    required this.rating,
    required this.category, 
  });
}