import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/recipe_service.dart';
import 'recipe_state.dart';
import '../models/recipe.dart';

final recipeServiceProvider = Provider<RecipeService>((ref) => RecipeService());

/// Manages fetching, filtering, and sorting of recipes.
final recipeViewModelProvider =
    StateNotifierProvider<RecipeViewModel, RecipeState>((ref) {
  final svc = ref.read(recipeServiceProvider);
  final vm = RecipeViewModel(svc);

  Future.microtask(() async {
    if (vm.mounted) {
      await vm.load();
    }
  });

  return vm;
});

class RecipeViewModel extends StateNotifier<RecipeState> {
  final RecipeService _svc;

  RecipeViewModel(this._svc) : super(const RecipeState());

  Future<void> load() async {
    if (!mounted) return;
    state = state.copyWith(loading: true, error: null);

    try {
      final data = await _svc.fetchRecipes();
      if (!mounted) return;

      final view = _applyView(
        data: data,
        query: state.query,
        category: state.category,
        sort: state.sort,
      );

      state = state.copyWith(
        loading: false,
        all: data,
        view: view,
      );
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  void setQuery(String q) => _updateView(query: q);
  void setCategory(String c) => _updateView(category: c);
  void setSort(SortOption s) => _updateView(sort: s);

  void _updateView({String? query, String? category, SortOption? sort}) {
    if (!mounted) return;

    final newQuery = query ?? state.query;
    final newCategory = category ?? state.category;
    final newSort = sort ?? state.sort;

    final newView = _applyView(
      data: state.all,
      query: newQuery,
      category: newCategory,
      sort: newSort,
    );

    state = state.copyWith(
      query: newQuery,
      category: newCategory,
      sort: newSort,
      view: newView,
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