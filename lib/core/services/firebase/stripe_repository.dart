import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluxfoot_user/core/secret/stripe_key.dart';

class StripeRepository {
  final Dio _dio = Dio();

  Future<void> initPaymentSheet({
    required String amount,
    required String currency,
    required String merchantName,
  }) async {
    try {
      final paymentIntel = await _createPaymentIntent(amount, currency);

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntel['client_secret'],
          merchantDisplayName: merchantName,
          style: ThemeMode.light,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _createPaymentIntent(
    String amount,
    String currency,
  ) async {
    final body = {
      'amount': (int.parse(amount) * 100).toString(),
      'currency': currency,
      'payment_method_types[]': 'card',
    };

    final response = await _dio.post(
      'https://api.stripe.com/v1/payment_intents',
      data: body,
      options: Options(
        headers: {
          'Authorization': 'Bearer $secretkey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
    );
    return response.data;
  }

  // Future<String?> createPaymentIntent(double amount, String currency) async {
  //   try {
  //     final response = await dio.post(
  //       Uri.parse('https://your-cloud-function-url/createPaymentIntent'),
  //       body: {
  //         'amount': (amount * 100)
  //             .toInt()
  //             .toString(), // Stripe uses cents/paise
  //         'currency': currency,
  //       },
  //     );

  //     final jsonResponse = jsonDecode(response.body);
  //     return jsonResponse['client_secret'];
  //   } catch (e) {
  //     debugPrint("Error creating payment intent: $e");
  //     return null;
  //   }
  // }

  Future<bool> processStripePayment(String clientSecret) async {
    try {
      // Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Flux Foot India',
          style: ThemeMode.light,
          // RBI India Requirement: Add billing details for local transactions
          billingDetails: const BillingDetails(
            address: Address(
              city: 'City',
              country: 'IN',
              line1: 'Line 1',
              line2: '',
              postalCode: '',
              state: '',
            ),
          ),
        ),
      );

      // Present Payment Sheet
      await Stripe.instance.presentPaymentSheet();
      return true;
    } catch (e) {
      if (e is StripeException) {
        debugPrint("Stripe Error: ${e.error.localizedMessage}");
      }
      return false;
    }
  }
}
