import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/recipe.dart';
import '../providers/favorite_view_model.dart';

class RecipeCard extends ConsumerWidget {
  final Recipe recipe;
  const RecipeCard({required this.recipe, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoriteViewModelProvider).contains(recipe.id);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20), // from opacity 0.08
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Hero(
            tag: recipe.id,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                recipe.image,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 220,
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, color: Colors.grey, size: 50),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha(204), // from opacity 0.8
                  ],
                  stops: const [0.5, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.name,
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withAlpha(128), // from opacity 0.5
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined, size: 18, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text('${recipe.cookTimeMinutes} min', style: const TextStyle(color: Colors.white70)),
                    const SizedBox(width: 16),
                    const Icon(Icons.whatshot_outlined, size: 18, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text(recipe.difficulty, style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 15,
            left: 15,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51), // from opacity 0.2
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        recipe.rating.toStringAsFixed(1),
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 15,
            right: 15,
            child: CircleAvatar(
              backgroundColor: Colors.white.withAlpha(230), // from opacity 0.9
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey.shade600,
                  size: 24,
                ),
                onPressed: () {
                  ref.read(favoriteViewModelProvider.notifier).toggleFavorite(recipe.id);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}