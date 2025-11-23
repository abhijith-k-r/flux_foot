part of 'favorites_bloc.dart';

abstract class FavoritesEvent {}

class LoadFavorites extends FavoritesEvent {
  final String uid;
  LoadFavorites(this.uid);
}

class ToggleFavoriteEvent extends FavoritesEvent {
  final ProductModel productModel;
  final bool isFavorites;

  ToggleFavoriteEvent({required this.productModel, required this.isFavorites});
}

class UpdateFavoritesList extends FavoritesEvent {
  final List<String> favoriteIds;
  UpdateFavoritesList(this.favoriteIds);
}

class ClearFavorites extends FavoritesEvent{}