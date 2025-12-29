// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/cart/view_model/bloc/cart_bloc.dart';
import 'package:fluxfoot_user/features/cart/views/widgets/bottom_checkout_section.dart';
import 'package:fluxfoot_user/features/cart/views/widgets/carted_card_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class CartsViews extends StatelessWidget {
  const CartsViews({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        title: customText(
          size,
          'Shopping Cart',
          style: GoogleFonts.rozhaOne(fontSize: size * 0.07),
        ),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text('Error: ${state.error}'));
          }

          final cartProducts = state.cartProducts;

          if (cartProducts.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'Flux_Foot/assets/images/lottie/Carrinho De Compras.json',
                ),
                SizedBox(height: 20),
                customText(size * 0.05, 'No Cart Added yet!'),
              ],
            );
          }

          // ! Calculate totals
          double subtotal = 0;
          for (var product in cartProducts) {
            final salePrice = product.salePrice;
            final regularPrice = product.regularPrice;
            final price = salePrice > 0 ? salePrice : regularPrice;
            final quantity = product.quantity;
            subtotal += price * quantity;
          }

          double discount = subtotal > 500 ? subtotal * 0.015 : 0;
          const double freeShippingThreshold = 700.0;
          const double fixedShippingFee = 50.0;

          double shippingFee = subtotal >= freeShippingThreshold
              ? 0.0
              : fixedShippingFee;

          double total = subtotal - discount + shippingFee;

          return Column(
            children: [
              // ! Cart Items List
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(size * 0.04),
                  itemCount: cartProducts.length,
                  itemBuilder: (context, index) {
                    final product = cartProducts[index];
                    return CartItemCard(product: product, size: size);
                  },
                ),
              ),

              //!  Bottom Checkout Section
              buildBottomCheckoutSection(
                context,
                size,
                cartProducts,
                subtotal,
                discount,
                shippingFee,
                total,
              ),
            ],
          );
        },
      ),
    );
  }
}
 