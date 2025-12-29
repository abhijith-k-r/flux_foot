import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/features/checkout/view_model/bloc/checkout_bloc.dart';
import 'package:fluxfoot_user/features/checkout/views/screens/checkout_view.dart';
import 'package:fluxfoot_user/features/home/models/color_variant.model.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';
import 'package:fluxfoot_user/features/home/view_model/product_variant/product_variant_bloc.dart';

// ! Helper Fucntion Navigate to Checkout screen
void goToCheckout(BuildContext context, ProductModel product) {
  // ! Get the CURRENT state from the bloc directly
  final currentState = context.read<ProductVariantBloc>().state;
  final selectedVariant = currentState.selectedVariant;
  final selectedSize = currentState.selectedSize;

  // ! Construct a ProductModel that reflects the CHOICE
  final List<ColorvariantModel> filteredVariants = [selectedVariant];

  List<String> productImages = product.images;
  if (selectedVariant.imageUrls.isNotEmpty) {
    productImages = selectedVariant.imageUrls;
  }

  final checkoutProduct = product.copyWith(
    quantity: 1,
    images: productImages,
    variants: filteredVariants,
  );

  if (selectedSize != null) {
    final modifiedVariant = selectedVariant.copyWith(sizes: [selectedSize]);

    final checkoutProductWithExactSize = checkoutProduct.copyWith(
      variants: [modifiedVariant],
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => CheckoutBloc()
            ..add(
              LoadCheckoutData(
                products: [checkoutProductWithExactSize],
                totalAmount: product.salePrice,
              ),
            ),
          child: const CheckoutPage(),
        ),
      ),
    );
    return;
  }

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => CheckoutBloc()
          ..add(
            LoadCheckoutData(
              products: [checkoutProduct],
              totalAmount: product.salePrice,
            ),
          ),
        child: const CheckoutPage(),
      ),
    ),
  );
}
