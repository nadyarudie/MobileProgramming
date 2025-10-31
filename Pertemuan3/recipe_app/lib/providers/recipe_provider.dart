// lib/providers/recipe_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/dummy_data.dart';
import '../models/recipe.dart';

// Provider 1: Menyediakan daftar resep asli (tidak berubah)
final recipesProvider = Provider<List<Recipe>>((ref) {
  return dummyRecipes;
});

// Provider 2: State untuk kategori yang dipilih
final selectedCategoryProvider = StateProvider<String>((ref) {
  return 'Semua';
});

// BARU -> Provider 3: State untuk teks pencarian
final searchQueryProvider = StateProvider<String>((ref) {
  return '';
});

// DIPERBARUI -> Provider 4: Provider pintar yang menggabungkan filter kategori & pencarian
final displayedRecipesProvider = Provider<List<Recipe>>((ref) {
  // Awasi ketiga provider lainnya
  final allRecipes = ref.watch(recipesProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final searchQuery = ref.watch(searchQueryProvider);

  // Langkah 1: Filter berdasarkan kategori
  List<Recipe> categoryFilteredRecipes;
  if (selectedCategory == 'Semua') {
    categoryFilteredRecipes = allRecipes;
  } else {
    categoryFilteredRecipes = allRecipes.where((recipe) => recipe.category == selectedCategory).toList();
  }

  // Langkah 2: Filter lagi berdasarkan pencarian
  if (searchQuery.isEmpty) {
    return categoryFilteredRecipes;
  } else {
    return categoryFilteredRecipes.where((recipe) {
      return recipe.title.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }
});