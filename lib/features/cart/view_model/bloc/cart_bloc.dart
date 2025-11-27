import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluxfoot_user/core/services/firebase/cart_repository.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _repo;
  final FirebaseAuth _auth;
  late final StreamSubscription<User?> _authSub;
  StreamSubscription? _cartDataSub;

  CartBloc({required CartRepository repo, FirebaseAuth? firebaseAuth})
    : _repo = repo,
      _auth = firebaseAuth ?? FirebaseAuth.instance,
      super(CartState()) {
    on<LoadCartItems>(_onLoadCart);
    on<ToggleCart>(_onToggleCart);
    on<UpdatedCartList>(_onUpdateCartList);
    on<ClearCarts>(_onClearCarites);

    _authSub = _auth.authStateChanges().listen((user) {
      if (user == null) {
        add(ClearCarts());
      } else {
        add(LoadCartItems(user.uid));
      }
    });

    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      add(LoadCartItems(currentUser.uid));
    }
  }

  Future<void> _onLoadCart(LoadCartItems event, Emitter<CartState> emit) async {
    try {
      await _cartDataSub?.cancel();
      emit(state.copyWith(isLoading: true));

      _cartDataSub = _repo
          .getCartItemId(event.uid)
          .listen(
            (cartIds) {
              add(UpdatedCartList(cartIds));
            },
            onError: (e) {
              emit(state.copyWith(error: e.toString(), isLoading: false));
            },
          );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onToggleCart(ToggleCart event, Emitter<CartState> emit) async {
    try {
      final currentUid = _auth.currentUser?.uid;
      if (currentUid == null) {
        emit(state.copyWith(error: 'User not logged in.', isLoading: false));
        return;
      }

      await _repo.toggleToCart(event.productModel, event.isCart, currentUid);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void _onUpdateCartList(UpdatedCartList event, Emitter<CartState> emit) async {
    emit(state.copyWith(cartIds: event.cartIds, isLoading: true));

    try {
      final List<ProductModel> products = await _repo.getProuductsByIds(
        event.cartIds,
      );

      final currentFavoriteModels = products
          .where((product) => event.cartIds.contains(product.id))
          .toList();

      emit(
        state.copyWith(
          cartIds: event.cartIds,
          cartProducts: currentFavoriteModels,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  void _onClearCarites(ClearCarts event, Emitter<CartState> emit) {
    _cartDataSub?.cancel();

    emit(state.copyWith(cartIds: <String>[], isLoading: false, error: null));
  }



  @override
  Future<void> close() async {
    await _authSub.cancel();
    await _cartDataSub?.cancel();
    return super.close();
  }
}
