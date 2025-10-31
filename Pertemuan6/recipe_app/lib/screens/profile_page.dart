// lib/screens/profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorite_view_model.dart';
import '../providers/recipe_view_model.dart';
import '../models/recipe.dart';
import '../routes.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favIds = ref.watch(favoriteViewModelProvider);
    final recipeState = ref.watch(recipeViewModelProvider);
    final all = recipeState.all;

    // Cocokkan id favorit dengan list resep
    final favorites = all.where((r) => favIds.contains(r.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            tooltip: 'Lihat semua resep',
            icon: const Icon(Icons.grid_on),
            onPressed: () {}, // optional: aksi lain
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: favorites.isEmpty
            ? const _EmptyFavorite()
            : GridView.builder(
                itemCount: favorites.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,          // grid 2 kolom
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.78,     // proporsional card
                ),
                itemBuilder: (context, i) {
                  final r = favorites[i];
                  return _FavoriteTile(recipe: r);
                },
              ),
      ),
    );
  }
}

class _EmptyFavorite extends StatelessWidget {
  const _EmptyFavorite();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.favorite_border, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            'Belum ada favorit',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'Tap ikon hati di kartu resep untuk menambahkan.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _FavoriteTile extends StatelessWidget {
  final Recipe recipe;
  const _FavoriteTile({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, AppRoutes.detail, arguments: recipe),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // gambar
            AspectRatio(
              aspectRatio: 16 / 11,
              child: Image.network(
                recipe.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
            // informasi ringkas
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 16, color: Colors.black54),
                      const SizedBox(width: 4),
                      Text('${recipe.cookTimeMinutes} min', style: const TextStyle(color: Colors.black54)),
                      const SizedBox(width: 10),
                      const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(recipe.rating.toStringAsFixed(1)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
