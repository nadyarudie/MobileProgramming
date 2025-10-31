// lib/widgets/category_chips_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/recipe_provider.dart';

class CategoryChipsBar extends ConsumerWidget {
  const CategoryChipsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ['Semua', 'Sarapan', 'Makan Siang', 'Makan Malam', 'Dessert', 'Minuman'];
    // Widget ini MEMBACA state kategori yang dipilih
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: GestureDetector(
              onTap: () {
                // Widget ini MENGUBAH state saat di-tap
                ref.read(selectedCategoryProvider.notifier).state = category;
              },
              child: Chip(
                label: Text(category),
                labelStyle: GoogleFonts.montserrat(
                  color: category == selectedCategory ? Colors.white : Colors.black87,
                  fontWeight: category == selectedCategory ? FontWeight.w700 : FontWeight.w500,
                ),
                backgroundColor: category == selectedCategory ? Theme.of(context).primaryColor : const Color(0xFFE0E0E0),
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
            ),
          );
        },
      ),
    );
  }
}