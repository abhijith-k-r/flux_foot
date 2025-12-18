import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/features/cart/views/widgets/price_row_widget.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';

//!  Bottom Checkout Section
Widget buildBottomCheckoutSection(
  double size,
  List<ProductModel> cartProducts,
  double subtotal,
  double discount,
  double shippingFee,
  double total,
) {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.bgWhite,
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2)),
      ],
    ),
    padding: EdgeInsets.all(size * 0.04),
    child: Column(
      children: [
        PriceRow(
          label: 'Subtotal (${cartProducts.length} items)',
          value: '₹${subtotal.toStringAsFixed(2)}',
        ),
        SizedBox(height: 8),
        PriceRow(label: 'Discount', value: '₹${discount.toStringAsFixed(2)}'),
        SizedBox(height: 8),
        PriceRow(
          label: 'Shipping fee',
          value: '₹${shippingFee.toStringAsFixed(2)}',
        ),
        Divider(height: 24, thickness: 1),
        PriceRow(
          label: 'Total',
          value: '₹${total.toStringAsFixed(2)}',
          isBold: true,
        ),
        SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.bgOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Make a Purchase',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
