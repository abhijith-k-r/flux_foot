part of 'checkout_bloc.dart';

enum CheckoutStatus { initial, loading, success, failure, paymentProcessing , noAddress}

class CheckoutState extends Equatable {
  final CheckoutStatus status;
  final List<ProductModel> products;
  final AddressModel? selectedAddress;
  final double subtotal;
  final double discount;
  final double shipping;
  final double total;
  final String? errorMessage;

  const CheckoutState({
    this.status = CheckoutStatus.initial,
    this.products = const [],
    this.selectedAddress,
    this.subtotal = 0.0,
    this.discount = 0.0,
    this.shipping = 0.0,
    this.total = 0.0,
    this.errorMessage,
  });
  CheckoutState copyWith({
    CheckoutStatus? status,
    List<ProductModel>? products,
    AddressModel? selectedAddress,
    double? subtotal,
    double? discount,
    double? shipping,
    double? total,
    String? errorMessage,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      products: products ?? this.products,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      shipping: shipping ?? this.shipping,
      total: total ?? this.total,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    products,
    selectedAddress,
    subtotal,
    discount,
    shipping,
    total,
    errorMessage,
  ];
}
