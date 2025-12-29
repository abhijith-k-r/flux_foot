part of 'checkout_bloc.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object> get props => [];
}

class LoadCheckoutData extends CheckoutEvent {
  final List<ProductModel> products;
  final double totalAmount;

  const LoadCheckoutData({required this.products, required this.totalAmount});

  @override
  List<Object> get props => [products, totalAmount];
}

class SelectAddress extends CheckoutEvent {
  final AddressModel address;
  const SelectAddress(this.address);
}

class PlaceOrderEvent extends CheckoutEvent {
  final String paymentMethod; 
  const PlaceOrderEvent({this.paymentMethod = 'Razorpay'});
}


class UpdatePaymentStatus extends CheckoutEvent {
  final String? paymentId;
  final bool isSuccess;

  const UpdatePaymentStatus({this.paymentId, required this.isSuccess});

  @override
  List<Object> get props => [isSuccess, paymentId ?? ''];
}
