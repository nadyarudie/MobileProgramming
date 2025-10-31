// lib/providers/favorite_view_model.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database_service.dart';

typedef FavoriteState = Set<int>;

final favoriteViewModelProvider =
    StateNotifierProvider<FavoriteViewModel, FavoriteState>((ref) {
  final vm = FavoriteViewModel();
  vm.loadFavorites();
  return vm;
});

class FavoriteViewModel extends StateNotifier<FavoriteState> {
  FavoriteViewModel() : super(<int>{});

  Future<void> loadFavorites() async {
    final ids = await DatabaseService.instance.getFavoriteIds();
    state = ids;
  }

  Future<void> toggleFavorite(int id) async {
    final isFav = await DatabaseService.instance.toggleFavorite(id);
    final next = Set<int>.from(state);
    if (isFav) {
      next.add(id);
    } else {
      next.remove(id);
    }
    state = next;
  }
}
