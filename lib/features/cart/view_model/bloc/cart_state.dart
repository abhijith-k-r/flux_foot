part of 'cart_bloc.dart';

// ! Signals one-shot UI feedback for cart add/remove actions
enum CartActionStatus { none, itemAdded, itemRemoved }

class CartState {
  final List<String> cartIds;
  final List<ProductModel> cartProducts;
  final bool isLoading;
  final String? error;
  // ! One-shot status flag — consumed by BlocListener to show toast
  final CartActionStatus lastAction;

  CartState({
    this.cartIds = const [],
    this.cartProducts = const [],
    this.isLoading = false,
    this.error,
    this.lastAction = CartActionStatus.none,
  });

  CartState copyWith({
    List<String>? cartIds,
    List<ProductModel>? cartProducts,
    bool? isLoading,
    String? error,
    CartActionStatus? lastAction,
  }) {
    return CartState(
      cartIds: cartIds ?? this.cartIds,
      cartProducts: cartProducts ?? this.cartProducts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      // Reset to none by default so listeners only fire once
      lastAction: lastAction ?? CartActionStatus.none,
    );
  }
}
