// lib/widgets/recipe_list_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/recipe_provider.dart';
import '../widgets/recipe_card.dart';

class RecipeListView extends ConsumerWidget {
  const RecipeListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 🔄 pakai list yang SUDAH diurutkan
    final recipes = ref.watch(displayedRecipesSortedProvider);

    // (Jika sebelumnya kamu menampilkan loading/error berdasarkan FutureProvider,
    // kamu bisa tetap menonton allRecipesProvider untuk indikatornya.)
    final asyncAll = ref.watch(allRecipesProvider);

    return asyncAll.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Gagal memuat: $e')),
      data: (_) {
        if (recipes.isEmpty) {
          return const Center(child: Text('Tidak ada resep'));
        }
        return ListView.builder(
          padding: const EdgeInsets.only(top: 0),
          itemCount: recipes.length,
          itemBuilder: (_, i) => RecipeCard(recipe: recipes[i]),
        );
      },
    );
  }
}
