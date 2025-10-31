// lib/widgets/recipe_card.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // <-- 1. Import Riverpod
import 'package:google_fonts/google_fonts.dart';
import '../models/recipe.dart';
import '../providers/favorite_view_model.dart'; // <-- 2. Import Favorite VM

// ✅ 3. Ubah menjadi ConsumerWidget
class RecipeCard extends ConsumerWidget {
  final Recipe recipe;
  const RecipeCard({required this.recipe, super.key});

  @override
  // ✅ 4. Tambahkan WidgetRef ref
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ 5. Pantau state favorit
    final favoriteIds = ref.watch(favoriteViewModelProvider);
    final isFavorite = favoriteIds.contains(recipe.id);

    // ❌ 6. GestureDetector untuk navigasi DIHAPUS dari sini.
    // (Logika navigasi sudah ada di recipe_list_view.dart)
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // ✅ PERBAIKAN: gunakan withValues (pengganti withOpacity)
            color: Colors.black.withValues(alpha: 0.08),
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
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
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
                    // ✅ PERBAIKAN: withValues
                    Colors.black.withValues(alpha: 0.8),
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
                        // ✅ PERBAIKAN: withValues
                        color: Colors.black.withValues(alpha: 0.5),
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
                    Text(
                      '${recipe.cookTimeMinutes} min',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.whatshot_outlined, size: 18, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text(
                      recipe.difficulty,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // --- Rating (Dipindah ke Kiri) ---
          Positioned(
            top: 15,
            left: 15, // <-- 7. Dipindah ke kiri
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    // ✅ PERBAIKAN: withValues
                    color: Colors.white.withValues(alpha: 0.2),
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
          // --- ✅ 8. Tombol Favorit Baru (di Kanan) ---
          Positioned(
            top: 15,
            right: 15,
            child: CircleAvatar(
              // ✅ PERBAIKAN: withValues
              backgroundColor: Colors.white.withValues(alpha: 0.9),
              child: IconButton(
                icon: Icon(
                  // Ikon berubah berdasarkan state
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  // Warna berubah berdasarkan state
                  color: isFavorite ? Colors.red : Colors.grey.shade600,
                  size: 24,
                ),
                onPressed: () {
                  // Panggil fungsi toggleFavorite dari ViewModel
                  ref
                      .read(favoriteViewModelProvider.notifier)
                      .toggleFavorite(recipe.id);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
