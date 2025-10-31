import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/recipe_view_model.dart';

class CategoryChipsBar extends ConsumerWidget {
  const CategoryChipsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeVM = ref.read(recipeViewModelProvider.notifier);
    final selectedCategory = ref.watch(recipeViewModelProvider).category;

    const categories = ['Semua', 'Breakfast', 'Lunch', 'Dinner', 'Snack', 'Dessert'];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isActive = (category == 'Semua' && selectedCategory.isEmpty) || category == selectedCategory;

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                final categoryToSet = (category == 'Semua') ? '' : category;
                recipeVM.setCategory(categoryToSet);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isActive ? Theme.of(context).primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isActive ? Theme.of(context).primaryColor : Colors.grey.shade300,
                    width: 1.5,
                  ),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: Theme.of(context).primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  category,
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