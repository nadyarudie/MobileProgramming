import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/recipe_provider.dart';

class CategoryChipsBar extends ConsumerWidget {
  const CategoryChipsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Kategori diambil sesuai tag API DummyJSON
    final categories = [
      'Semua',
      'Breakfast',
      'Lunch',
      'Dinner',
      'Dessert',
      'Vegetarian',
      'Seafood',
      'Healthy',
      'Italian',
      'Asian'
    ];

    // Ambil kategori yang sedang dipilih dari provider
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: GestureDetector(
              onTap: () {
                // Perbarui kategori terpilih di provider
                ref.read(selectedCategoryProvider.notifier).state = category;
                // Provider recipesByCategoryProvider akan otomatis refetch data API
              },
              child: Chip(
                label: Text(category),
                labelStyle: GoogleFonts.montserrat(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
                backgroundColor: isSelected
                    ? Theme.of(context).primaryColor
                    : const Color(0xFFE0E0E0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
              ),
            ),
          );
        },
      ),
    );
  }
}
