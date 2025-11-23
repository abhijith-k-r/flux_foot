part of 'favorites_bloc.dart';

class FavoritesState {
  final List<String> favoriteIds;
  final List<ProductModel> favoriteProducts;
  final bool isLoading;
  final String? error;

  FavoritesState({
    this.favoriteIds = const [],
    this.favoriteProducts = const [],
    this.isLoading = false,
    this.error,
  });

  FavoritesState copyWith({
    List<String>? favoriteIds,
    List<ProductModel>? favoriteProducts,
    bool? isLoading,
    String? error,
  }) {
    return FavoritesState(
      favoriteIds: favoriteIds ?? this.favoriteIds,
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
