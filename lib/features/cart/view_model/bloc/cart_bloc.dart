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

    on<UpdateCartQuantityEvent>(_onUpdateCartQuantity);
    on<RemoveFromCartEvent>(_onRemoveFromCart);

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
              add(UpdatedCartList(cartIds, event.uid));
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

      await _repo.toggleToCart(
        product: event.productModel,
        shouldRemove: event.isCart,
        uid: currentUid,
        selectedColorName: event.selectedColorName,
        selectedSize: event.selectedSize,
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void _onUpdateCartList(UpdatedCartList event, Emitter<CartState> emit) async {
    // Only show loading if checking for the first time or list is empty to avoid flickering
    emit(
      state.copyWith(
        cartIds: event.cartIds,
        isLoading: state.cartProducts.isEmpty,
      ),
    );

    try {
      // 🛠️ FIX: Pass the UID to the repository method
      final List<ProductModel> products = await _repo.getProuductsByIds(
        event.cartIds,
        event.uid,
      );

      final currentCartModels = products
          .where((product) => event.cartIds.contains(product.id))
          .toList();

      emit(
        state.copyWith(
          cartIds: event.cartIds,
          cartProducts: currentCartModels,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  void _onClearCarites(ClearCarts event, Emitter<CartState> emit) {
    _cartDataSub?.cancel();

    emit(
      state.copyWith(
        cartIds: <String>[],
        cartProducts: <ProductModel>[],
        isLoading: false,
        error: null,
      ),
    );
  }

  Future<void> _onUpdateCartQuantity(
    UpdateCartQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) {
      emit(state.copyWith(error: 'User not logged in.'));
      return;
    }
    if (event.quantity < 1) {
      add(RemoveFromCartEvent(product: event.product));
      return;
    }

    try {
      await _repo.updateCartQuantity(
        event.product.id,
        event.quantity,
        currentUserId,
      );

      final updatedProducts = state.cartProducts.map((product) {
        if (product.id == event.product.id) {
          return product.copyWith(quantity: event.quantity);
        }
        return product;
      }).toList();

      emit(state.copyWith(cartProducts: updatedProducts));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to update quantity: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCartEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      final currentUid = _auth.currentUser?.uid;
      if (currentUid == null) {
        emit(state.copyWith(error: 'User not logged in.'));
        return;
      }

      await _repo.removeFromCart(event.product.id, currentUid);
    } catch (e) {
      emit(state.copyWith(error: 'Failed to remove item: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() async {
    await _authSub.cancel();
    await _cartDataSub?.cancel();
    return super.close();
  }
}
