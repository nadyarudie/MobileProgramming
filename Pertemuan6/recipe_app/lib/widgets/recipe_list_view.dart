// lib/widgets/recipe_list_view.dart
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../routes.dart';
import 'recipe_card.dart';

class RecipeListView extends StatelessWidget {
  final bool loading;
  final String? error;
  final List<Recipe> recipes;
  final Future<void> Function() onRefresh;

  const RecipeListView({
    super.key,
    required this.loading,
    required this.error,
    required this.recipes,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Terjadi kesalahan: $error'),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: onRefresh, child: const Text('Coba lagi')),
            ],
          ),
        ),
      );
    }
    if (recipes.isEmpty) {
      return const Center(child: Text('Tidak ada resep yang cocok.'));
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        itemCount: recipes.length,
        itemBuilder: (context, i) {
          final r = recipes[i];
          // ✅ Pakai InkWell agar IconButton di dalam RecipeCard tetap menangkap tap
          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.pushNamed(context, AppRoutes.detail, arguments: r),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: RecipeCard(recipe: r),
              ),
            ),
          );
        },
      ),
    );
  }
}
