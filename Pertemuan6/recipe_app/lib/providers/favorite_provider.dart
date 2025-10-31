// lib/providers/favorite_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database_service.dart';

final favoriteIdsProvider = FutureProvider<Set<int>>((ref) async {
  return DatabaseService.instance.getFavoriteIds();
});

final isFavoriteProvider = FutureProvider.family<bool, int>((ref, recipeId) async {
  return DatabaseService.instance.isFavorite(recipeId);
});
