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
  UpdatedCartList(this.cartIds);
}

class ClearCarts extends CartEvent {}


