part of 'cart_bloc.dart';

abstract class CartEvent {}

class LoadCartItems extends CartEvent {
  final String uid;

  LoadCartItems(this.uid);
}

class ToggleCart extends CartEvent {
  final ProductModel productModel;
  final bool isCart;

  ToggleCart({required this.productModel, required this.isCart});
}

class UpdatedCartList extends CartEvent {
  final List<String> cartIds;
  final String uid;
  UpdatedCartList(this.cartIds, this.uid);
}

class ClearCarts extends CartEvent {}

class UpdateCartQuantityEvent extends CartEvent {
  final ProductModel product;
  final int quantity;

  UpdateCartQuantityEvent({required this.product, required this.quantity});
}


class RemoveFromCartEvent extends CartEvent {
  final ProductModel product;

  RemoveFromCartEvent({required this.product});
}
