import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluxfoot_user/core/services/firebase/favorites_repository.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesRepository _repo;
  final FirebaseAuth _auth;
  late final StreamSubscription<User?> _authSub;
  StreamSubscription? _favoritesDataSub;

  FavoritesBloc({required FavoritesRepository repo, FirebaseAuth? firebaseAuth})
    : _repo = repo,
      _auth = firebaseAuth ?? FirebaseAuth.instance,
      super(FavoritesState()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<UpdateFavoritesList>(_onUpdateFavoritesList);
    on<ClearFavorites>(_onClearFavorites);

    _authSub = _auth.authStateChanges().listen(
      (user) {
        if (user == null) {
          add(ClearFavorites());
        } else {
          add(LoadFavorites(user.uid));
        }
      },
      onError: (error) {
        // print('Error fetching favoriteds: $error');
      },
    );
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await _favoritesDataSub?.cancel();
      emit(state.copyWith(isLoading: true));

      _favoritesDataSub = _repo
          .getFavoriteItemIds(event.uid)
          .listen(
            (favoriteIds) {
              add(UpdateFavoritesList(favoriteIds));
            },
            onError: (e) {
              emit(state.copyWith(error: e.toString(), isLoading: false));
            },
          );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final currentUid = _auth.currentUser?.uid;
      if (currentUid == null) {
        emit(state.copyWith(error: 'User not logged in.', isLoading: false));
        return;
      }

      await _repo.toggleFavorite(
        event.productModel,
        event.isFavorites,
        currentUid,
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void _onUpdateFavoritesList(
    UpdateFavoritesList event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(state.copyWith(favoriteIds: event.favoriteIds, isLoading: true));

    try {
      final List<ProductModel> products = await _repo.getProductsByIds(
        event.favoriteIds,
      );

      final currentFavoriteModels = products
          .where((product) => event.favoriteIds.contains(product.id))
          .toList();

      emit(
        state.copyWith(
          favoriteIds: event.favoriteIds,
          favoriteProducts: currentFavoriteModels,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  void _onClearFavorites(ClearFavorites event, Emitter<FavoritesState> emit) {
    _favoritesDataSub?.cancel();

    emit(
      state.copyWith(favoriteIds: <String>[], isLoading: false, error: null),
    );
  }

  @override
  Future<void> close() async {
    await _authSub.cancel();
    await _favoritesDataSub?.cancel();
    return super.close();
  }
}
