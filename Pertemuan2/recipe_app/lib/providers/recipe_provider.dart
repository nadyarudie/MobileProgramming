import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/dummy_data.dart';
import '../models/recipe.dart';

// Provider 1: Menyediakan daftar resep asli (tidak akan berubah)
final recipesProvider = Provider<List<Recipe>>((ref) {
  return dummyRecipes;
});

// Provider 2: Menyimpan state kategori yang sedang dipilih (bisa berubah)
final selectedCategoryProvider = StateProvider<String>((ref) {
  return 'Semua'; // Nilai awal saat aplikasi pertama kali dibuka
});

// Provider 3: Menyediakan daftar resep yang sudah difilter secara otomatis
final filteredRecipesProvider = Provider<List<Recipe>>((ref) {
  final selectedCategory = ref.watch(selectedCategoryProvider);
  
  final allRecipes = ref.watch(recipesProvider);

  // Filter Category
  if (selectedCategory == 'Semua') {
    return allRecipes;
  } else {
    return allRecipes.where((recipe) => recipe.category == selectedCategory).toList();
  }
});