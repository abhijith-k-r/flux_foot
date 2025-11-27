part of 'cart_bloc.dart';

class CartState {
  final List<String> cartIds;
  final List<ProductModel> cartProducts;
  final bool isLoading;
  final String? error;

  CartState({
    this.cartIds = const [],
    this.cartProducts = const [],
    this.isLoading = false,
    this.error,
  });

  CartState copyWith({
    List<String>? cartIds,
    List<ProductModel>? cartProducts,
    bool? isLoading,
    String? error,
  }) {
    return CartState(
      cartIds: cartIds ?? this.cartIds,
      cartProducts: cartProducts ?? this.cartProducts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
