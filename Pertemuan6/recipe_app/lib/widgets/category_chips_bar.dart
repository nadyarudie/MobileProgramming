// lib/widgets/category_chips_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/recipe_view_model.dart';

class CategoryChipsBar extends ConsumerWidget {
  const CategoryChipsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeState = ref.watch(recipeViewModelProvider);
    final recipeVM = ref.read(recipeViewModelProvider.notifier);
    final selected = recipeState.category;

    // Tambahkan "Semua" di awal seperti kode kamu
    const categories = ['Semua', 'Breakfast', 'Lunch', 'Dinner', 'Snack', 'Dessert'];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final c = categories[index];
          final isActive = (c == 'Semua' && selected.isEmpty) || c == selected;

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                final categoryToSet = (c == 'Semua') ? '' : c;
                recipeVM.setCategory(categoryToSet);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isActive ? Theme.of(context).primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isActive
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade300,
                    width: 1.5,
                  ),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            // ganti withOpacity → withValues agar hilang deprecation
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  c,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive ? Colors.white : Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
