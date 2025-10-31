// lib/widgets/recipe_list_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/recipe_provider.dart';
import 'recipe_card.dart';

class RecipeListView extends ConsumerWidget {
  const RecipeListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Widget ini MEMBACA state daftar resep yang sudah terfilter (gabungan)
    final displayedRecipes = ref.watch(displayedRecipesProvider);

    return ListView.builder(
      padding: const EdgeInsets.only(top: 0),
      itemCount: displayedRecipes.length,
      itemBuilder: (BuildContext context, int index) {
        final recipe = displayedRecipes[index];
        return RecipeCard(recipe: recipe);
      },
    );
  }
}