import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/widgets/custom_button.dart';
import 'package:fluxfoot_user/features/cart/view_model/bloc/cart_bloc.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

// ! Custom Add to Cart Button
Widget buildAddtoCartButton(double size, ProductModel product, {
  String? selectedColorName,
  String? selectedSize,
}) {
  return BlocBuilder<CartBloc, CartState>(
    builder: (context, state) {
      final isCart = state.cartIds.contains(product.id);
      return LiquidGlassLayer(
        child: LiquidGlass(
          shape: LiquidRoundedSuperellipse(borderRadius: 15),
          child: GlassGlow(
            child: CustomButton(
              width: 180,
              ontap: () {
                context.read<CartBloc>().add(
                  ToggleCart(productModel: product, isCart: isCart,
                    selectedColorName: selectedColorName,
                    selectedSize: selectedSize,
                  ),
                );
              },
              backColor: Colors.transparent,
              textColor: AppColors.textBlack,
              widget: Icon(
                isCart ? CupertinoIcons.cart_fill : CupertinoIcons.cart,
                color: isCart ? AppColors.iconOrangeAccent : null,
              ),
              text: isCart ? 'Added To Cart' : 'Add to Cart',
              fontSize: size * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    },
  );
}
