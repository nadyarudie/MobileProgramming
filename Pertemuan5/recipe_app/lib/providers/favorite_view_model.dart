import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database_service.dart';
import 'auth_view_model.dart';

final databaseProvider = Provider<DatabaseService>((ref) => DatabaseService());

/// Provides access to the user's favorite recipes.
/// Rebuilds when the active user changes.
final favoriteViewModelProvider =
    StateNotifierProvider<FavoriteViewModel, Set<int>>((ref) {
  final db = ref.read(databaseProvider);
  final user = ref.watch(authViewModelProvider).user ?? 'guest';
  final vm = FavoriteViewModel(db: db, user: user);

  Future.microtask(() async {
    if (vm.mounted) await vm.load();
  });

  return vm;
});

class FavoriteViewModel extends StateNotifier<Set<int>> {
  FavoriteViewModel({required DatabaseService db, required String user})
      : _db = db,
        _user = user,
        super(<int>{});

  final DatabaseService _db;
  final String _user;

  Future<void> load() async {
    final ids = await _db.getFavoriteIds(_user);
    if (!mounted) return;
    state = ids.toSet();
  }

  Future<void> toggle(int recipeId) async {
    if (state.contains(recipeId)) {
      await _db.removeFavorite(_user, recipeId);
      if (!mounted) return;
      state = {...state}..remove(recipeId);
    } else {
      await _db.addFavorite(_user, recipeId);
      if (!mounted) return;
      state = {...state, recipeId};
    }
  }

  Future<void> toggleFavorite(int recipeId) => toggle(recipeId);

  bool isFavorite(int id) => state.contains(id);
}