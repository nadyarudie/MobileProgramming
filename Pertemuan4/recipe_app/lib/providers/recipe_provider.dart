// lib/providers/recipe_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';

// =====================
// ENUM & SORT PROVIDER
// =====================
enum SortOption { rating, duration }
final sortOptionProvider = StateProvider<SortOption>((ref) => SortOption.rating);

// =====================
// YANG SUDAH ADA
// =====================
final selectedCategoryProvider = StateProvider<String>((ref) => 'Dinner');
final searchQueryProvider = StateProvider<String>((ref) => '');
final allRecipesProvider = FutureProvider<List<Recipe>>((ref) => RecipeService.fetchAllRecipes());

// Filter kategori + search (tanpa urut)
final displayedRecipesProvider = Provider<List<Recipe>>((ref) {
  final allRecipes = ref.watch(allRecipesProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final searchQuery = ref.watch(searchQueryProvider);

  return allRecipes.when(
    data: (recipes) {
      List<Recipe> filteredList = recipes;

      if (selectedCategory != 'Semua') {
        filteredList = filteredList.where((recipe) {
          return recipe.mealType.contains(selectedCategory);
        }).toList();
      }

      if (searchQuery.isNotEmpty) {
        filteredList = filteredList.where((recipe) {
          return recipe.name.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();
      }

      return filteredList;
    },
    loading: () => [],
    error: (err, stack) => [],
  );
});

// =====================
// LIST YANG SUDAH DIURUTKAN
// =====================
final displayedRecipesSortedProvider = Provider<List<Recipe>>((ref) {
  final list = [...ref.watch(displayedRecipesProvider)];
  final sort = ref.watch(sortOptionProvider);

  if (sort == SortOption.rating) {
    list.sort((a, b) => b.rating.compareTo(a.rating));
  } else {
    list.sort((a, b) => a.cookTimeMinutes.compareTo(b.cookTimeMinutes));
  }
  return list;
});
