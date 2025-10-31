import '../models/recipe.dart';

enum SortOption { rating, duration }

/// Represents the state for the recipe list view.
class RecipeState {
  final bool loading;
  final List<Recipe> all;     // All recipes from the source.
  final List<Recipe> view;    // Filtered and sorted list for display.
  final String? error;
  final String query;
  final String category;
  final SortOption sort;

  const RecipeState({
    this.loading = false,
    this.all = const [],
    this.view = const [],
    this.error,
    this.query = '',
    this.category = '', 
    this.sort = SortOption.rating,
  });

  RecipeState copyWith({
    bool? loading,
    List<Recipe>? all,
    List<Recipe>? view,
    String? error,
    String? query,
    String? category,
    SortOption? sort,
  }) {
    return RecipeState(
      loading: loading ?? this.loading,
      all: all ?? this.all,
      view: view ?? this.view,
      error: error,
      query: query ?? this.query,
      category: category ?? this.category,
      sort: sort ?? this.sort,
    );
  }
}