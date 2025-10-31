import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/recipe_service.dart';
import 'recipe_state.dart';
import '../models/recipe.dart';

final recipeServiceProvider = Provider<RecipeService>((ref) => RecipeService());

final recipeViewModelProvider =
    StateNotifierProvider<RecipeViewModel, RecipeState>((ref) {
  final svc = ref.read(recipeServiceProvider);
  final vm = RecipeViewModel(svc);
  vm.load(); // initial load
  return vm;
});

class RecipeViewModel extends StateNotifier<RecipeState> {
  final RecipeService _svc;

  RecipeViewModel(this._svc) : super(const RecipeState());

  Future<void> load() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final data = await _svc.fetchRecipes(); // asumsi sudah ada
      state = state.copyWith(
        loading: false,
        all: data,
        view: _applyView(
          data: data,
          query: state.query,
          category: state.category,
          sort: state.sort,
        ),
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  void setQuery(String q) {
    state = state.copyWith(
      query: q,
      view: _applyView(
        data: state.all,
        query: q,
        category: state.category,
        sort: state.sort,
      ),
    );
  }

  void setCategory(String c) {
    state = state.copyWith(
      category: c,
      view: _applyView(
        data: state.all,
        query: state.query,
        category: c,
        sort: state.sort,
      ),
    );
  }

  void setSort(SortOption s) {
    state = state.copyWith(
      sort: s,
      view: _applyView(
        data: state.all,
        query: state.query,
        category: state.category,
        sort: s,
      ),
    );
  }

  List<Recipe> _applyView({
    required List<Recipe> data,
    required String query,
    required String category,
    required SortOption sort,
  }) {
    var list = data;

    if (query.isNotEmpty) {
      final q = query.toLowerCase();
      list = list.where((r) => r.name.toLowerCase().contains(q)).toList();
    }

    if (category.isNotEmpty) {
      list = list.where((r) => r.mealType.contains(category)).toList();
    }

    list = List<Recipe>.from(list);
    list.sort((a, b) {
      switch (sort) {
        case SortOption.rating:
          return b.rating.compareTo(a.rating);
        case SortOption.duration:
          return a.cookTimeMinutes.compareTo(b.cookTimeMinutes);
      }
    });

    return list;
  }
}
