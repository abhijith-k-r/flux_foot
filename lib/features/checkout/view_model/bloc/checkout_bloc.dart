
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluxfoot_user/core/services/firebase/stripe_repository.dart';
import 'package:fluxfoot_user/features/address/model/address_model.dart';
import 'package:fluxfoot_user/features/checkout/models/order_model.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  // late Razorpay _razorpay;
  final StripeRepository _stripeRepository = StripeRepository();

  CheckoutBloc() : super(CheckoutState()) {
    // _razorpay = Razorpay();
    // // Handlers
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

    on<LoadCheckoutData>(_onLoadCheckoutData);
    on<PlaceOrderEvent>(_onPlaceOrder);
    on<UpdatePaymentStatus>(_onUpdatePaymentStatus);
    on<SelectAddress>(_onSelectAddress);
  }

  Future<void> _onLoadCheckoutData(
    LoadCheckoutData event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(state.copyWith(status: CheckoutStatus.loading));

    try {
      // 1. Fetch default address
      final userId = FirebaseAuth.instance.currentUser?.uid;
      AddressModel? address;

      if (userId != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('addresses')
            // .orderBy('createdAt', descending: true)
            .get();

        if (snapshot.docs.isNotEmpty) {
          final selectedDocs = snapshot.docs.where(
            (doc) => doc.data()['isSelected'] == true,
          );

          if (selectedDocs.isNotEmpty) {
            address = AddressModel.fromFirestore(
              selectedDocs.first.data(),
              selectedDocs.first.id,
            );
          } else {
            address = AddressModel.fromFirestore(
              snapshot.docs.first.data(),
              snapshot.docs.first.id,
            );
          }
        }
      }

      // 2. Calculate Costs
      double subtotal = event.subtotal ?? event.products.fold(
        0,
        (sums, item) => sums + (item.salePrice * item.quantity),
      );
      double discount = event.discount ?? 0.0;
      double shipping = event.shipping ?? (subtotal > 500 ? 0.0 : 40.0);
      double finalTotal = event.totalAmount;
      if (address == null) {
        // Emit noAddress status but still keep products so we can show them later
        emit(
          state.copyWith(
            status: CheckoutStatus.noAddress,
            products: event.products,
            subtotal: subtotal,
            discount: discount,
            shipping: shipping,
            total: finalTotal,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: CheckoutStatus.success,
            products: event.products,
            selectedAddress: address,
            subtotal: subtotal,
            discount: discount,
            shipping: shipping,
            total: finalTotal,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //   // When payment succeeds, we tell the Bloc to save the order
  //   add(UpdatePaymentStatus(paymentId: response.paymentId!, isSuccess: true));
  // }

  // void _handlePaymentError(PaymentFailureResponse response) {
  //   add(const UpdatePaymentStatus(isSuccess: false));
  // }

  Future<void> _onPlaceOrder(
    PlaceOrderEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    if (state.selectedAddress == null) return;

    emit(state.copyWith(status: CheckoutStatus.loading));

    try {
      final String amount = state.total.toInt().toString();

      await _stripeRepository.initPaymentSheet(
        amount: amount,
        currency: 'inr',
        merchantName: 'Flux Foot India',
      );

      await _stripeRepository.presentPaymentSheet();

      await _createOrderInFirestore(
        paymentId: "STRIPE_${DateTime.now().millisecondsSinceEpoch}",
        method: "Stripe",
      );

      emit(state.copyWith(status: CheckoutStatus.orderPlaced));
    } catch (e) {
      if (e is StripeException) {
        emit(
          state.copyWith(
            status: CheckoutStatus.failure,
            errorMessage: e.error.localizedMessage ?? "payment Cancellec",
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: CheckoutStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

    Future<void> _createOrderInFirestore({
    required String paymentId,
    required String method,
  }) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (state.selectedAddress == null) return;

    // Convert address to map for historical record
    final addressMap = state.selectedAddress!.toFireStore();

    for (var product in state.products) {
      final order = OrderModel(
        id: '', // Firestore auto-id
        userId: userId!,
        sellerId: product.sellerId,
        productId: product.id,
        productName: product.name,
        productImage: product.images.isNotEmpty ? product.images[0] : "",
        quantity: product.quantity,
        totalAmount: product.salePrice * product.quantity, // Individual price requested by seller
        paymentType: method,
        status: method == 'COD' ? 'Placed' : 'Paid',
        paymentId: paymentId,
        shippingAddress: addressMap,
      );

      await FirebaseFirestore.instance.collection('orders').add(order.toMap());
    }
  }


  Future<void> _onUpdatePaymentStatus(
    UpdatePaymentStatus event,
    Emitter<CheckoutState> emit,
  ) async {
    if (event.isSuccess) {
      emit(state.copyWith(status: CheckoutStatus.paymentProcessing));

      // Call your firestore saving logic here
      await _createOrderInFirestore(
        paymentId: event.paymentId ?? "RZP_ID",
        method: "Razorpay",
      );

      emit(state.copyWith(status: CheckoutStatus.orderPlaced));
    } else {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: "Payment Failed or Cancelled",
        ),
      );
    }
  }

  void _onSelectAddress(SelectAddress event, Emitter<CheckoutState> emit) {
    emit(
      state.copyWith(
        selectedAddress: event.address,
        status: CheckoutStatus.success,
      ),
    );
  }

  @override
  Future<void> close() {
    // _razorpay.clear();
    return super.close();
  }
}
