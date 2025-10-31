class Recipe {
  final int id;
  final String name;
  final String image;
  final double rating;
  final String difficulty;
  final int cookTimeMinutes;
  final List<String> ingredients;
  final List<String> mealType;
  final List<String>? tags;
  final String instructions; // tetap String agar mudah ditampilkan

  Recipe({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.difficulty,
    required this.cookTimeMinutes,
    required this.ingredients,
    required this.mealType,
    this.tags,
    required this.instructions,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    // Normalisasi: apa pun bentuknya, jadikan List<String>
    List<String> _asStringList(dynamic v) {
      if (v is List) return v.map((e) => e.toString()).toList();
      if (v == null) return <String>[];
      return [v.toString()];
    }

    // Normalisasi instructions: bisa String atau List -> String
    String _instructionsToString(dynamic v) {
      if (v is List) return v.map((e) => e.toString()).join('\n');
      return (v ?? '').toString();
    }

    return Recipe(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      name: (json['name'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
      rating: (json['rating'] is num) ? (json['rating'] as num).toDouble()
             : double.tryParse('${json['rating']}') ?? 0.0,
      difficulty: (json['difficulty'] ?? 'Medium').toString(),
      cookTimeMinutes: json['cookTimeMinutes'] is int
          ? json['cookTimeMinutes']
          : int.tryParse('${json['cookTimeMinutes']}') ?? 0,
      ingredients: _asStringList(json['ingredients']),
      mealType: _asStringList(json['mealType']).isNotEmpty
          ? _asStringList(json['mealType'])
          : _asStringList(json['tags']),
      tags: _asStringList(json['tags']),
      instructions: _instructionsToString(json['instructions']),
    );
  }
}
