import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Import Riverpod
import '../providers/recipe_provider.dart'; // 2. Import provider yang kita buat
import '../widgets/recipe_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  // 4. Method build sekarang punya parameter 'WidgetRef ref'
  Widget build(BuildContext context, WidgetRef ref) {
    // 5. Membaca daftar resep yang sudah difilter dari provider
    final filteredRecipes = ref.watch(filteredRecipesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo, Sahabat Masak!',
                    style: GoogleFonts.montserrat(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Temukan resep favoritmu di sini',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey, size: 24),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Cari resep lezat...',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // 6. Mengirim 'ref' ke helper method
            _buildCategoryChips(context, ref),

            const Padding(
              padding: EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 15.0),
              child: Text(
                'Rekomendasi Populer',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
            
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 0),
                // 7. Gunakan data dari provider yang sudah difilter
                itemCount: filteredRecipes.length, 
                itemBuilder: (BuildContext context, int index) {
                  final recipe = filteredRecipes[index];
                  return RecipeCard(recipe: recipe);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 8. Helper method sekarang menerima 'WidgetRef ref'
  Widget _buildCategoryChips(BuildContext context, WidgetRef ref) {
    // Daftar kategori dibuat dinamis
    final List<String> categories = ['Semua', 'Sarapan', 'Makan Siang', 'Makan Malam', 'Dessert', 'Minuman'];
    // Membaca state kategori yang sedang dipilih dari provider
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return SizedBox(
      height: 48,
      child: ListView.builder( // Diubah menjadi ListView.builder agar lebih efisien
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          // Kirim 'ref' dan state yang relevan ke _buildChip
          return _buildChip(
            context,
            ref,
            category,
            isSelected: category == selectedCategory,
          );
        },
      ),
    );
  }
  
  // 9. _buildChip sekarang interaktif
  Widget _buildChip(BuildContext context, WidgetRef ref, String label, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      // GestureDetector membuat Chip bisa di-tap
      child: GestureDetector(
        onTap: () {
          // Saat di-tap, UBAH state kategori yang dipilih
          ref.read(selectedCategoryProvider.notifier).state = label;
        },
        child: Chip(
          label: Text(label),
          labelStyle: GoogleFonts.montserrat(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
          backgroundColor: isSelected ? Theme.of(context).primaryColor : const Color(0xFFE0E0E0),
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
      ),
    );
  }
}