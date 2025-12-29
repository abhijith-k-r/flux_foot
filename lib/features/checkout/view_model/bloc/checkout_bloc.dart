import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluxfoot_user/features/address/model/address_model.dart';
import 'package:fluxfoot_user/features/checkout/models/order_model.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  late Razorpay _razorpay;

  CheckoutBloc() : super(CheckoutState()) {
    _razorpay = Razorpay();
    // Handlers
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

    on<LoadCheckoutData>(_onLoadCheckoutData);
    on<PlaceOrderEvent>(_onPlaceOrder);
    on<UpdatePaymentStatus>(_onUpdatePaymentStatus);
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
            .orderBy('createdAt', descending: true)
            .get();

        if (snapshot.docs.isNotEmpty) {
          try {
            // Try to find one with isSelected == true
            var selectedDoc = snapshot.docs.firstWhere(
              (doc) => doc.data()['isSelected'] == true,
              orElse: () => snapshot.docs.first,
            );
            address = AddressModel.fromFirestore(
              selectedDoc.data(),
              selectedDoc.id,
            );
          } catch (e) {
            address = null;
          }
        }
      }

      // 2. Calculate Costs
      // Calculate subtotal based on price * quantity for each item
      double subtotal = event.products.fold(
        0,
        (sums, item) => sums + (item.salePrice * item.quantity),
      );
      double discount = 0.0; // Apply coupon logic here if any
      double shipping = subtotal > 500
          ? 0.0
          : 40.0; // Example logic: Free shipping over $500
      double finalTotal = subtotal - discount + shipping;
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

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // When payment succeeds, we tell the Bloc to save the order
    add(UpdatePaymentStatus(paymentId: response.paymentId!, isSuccess: true));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    add(const UpdatePaymentStatus(isSuccess: false));
  }

  Future<void> _onPlaceOrder(
    PlaceOrderEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    if (state.selectedAddress == null) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: "Please select an address",
        ),
      );
      return;
    }
    if (event.paymentMethod == 'COD') {
      emit(state.copyWith(status: CheckoutStatus.paymentProcessing));
      await _createOrderInFirestore(paymentId: "COD", method: "COD");
      emit(state.copyWith(status: CheckoutStatus.success));
    } else {
      // Trigger Razorpay
      var options = {
        'key': 'rzp_test_RxLmZP0MJXDE9e',
        'amount': state.total * 100, // amount in paise
        'name': 'Flux Foot',
        'description': 'Purchase Football Gear',
        'prefill': {'contact': '8888888888', 'email': 'test@test.com'},
      };

      try {
        _razorpay.open(options);
      } catch (e) {
        debugPrint('Error From OpenPay: $e');
      }
    }
  }

  Future<void> _createOrderInFirestore({
    required String paymentId,
    required String method,
  }) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    // Group products by Seller ID so each seller sees their specific order
    for (var product in state.products) {
      final order = OrderModel(
        id: '', // Firestore auto-id
        userId: userId!,
        sellerId: product.sellerId, // Ensure your ProductModel has sellerId
        totalAmount: product.salePrice * product.quantity,
        paymentType: method,
        status: method == 'COD' ? 'Placed' : 'Paid',
        paymentId: paymentId,
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

      emit(state.copyWith(status: CheckoutStatus.success));
    } else {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: "Payment Failed or Cancelled",
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _razorpay.clear();
    return super.close();
  }
}
