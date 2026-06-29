// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';

//! Helper Widget: Cost Breakdown
Widget buildCostBreakdown({
  required bool isDark,
  required double subtotal,
  required double discount,
  required double shipping,
  required double total,
}) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: isDark ? Colors.grey[800] : Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isDark ? Colors.grey[700]!.withOpacity(0.5) : Colors.grey[100]!,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      children: [
        buildCostRow(
          isDark: isDark,
          label: 'Subtotal',
          value: '₹${subtotal.toStringAsFixed(2)}',
          isRegular: true,
        ),
        const SizedBox(height: 12),
        buildCostRow(
          isDark: isDark,
          label: 'Discount',
          value: '- ₹${discount.toStringAsFixed(2)}',
          isDiscount: true,
        ),
        const SizedBox(height: 12),
        buildCostRow(
          isDark: isDark,
          label: 'Shipping',
          value: shipping == 0 ? "Free" : '₹${shipping.toStringAsFixed(2)}',
          isRegular: true,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Divider(
            height: 1,
            color: isDark ? Colors.grey[700] : Colors.grey[100],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            Text(
              '₹${total.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget buildCostRow({
  required bool isDark,
  required String label,
  required String value,
  bool isRegular = false,
  bool isDiscount = false,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
      Text(
        value,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isDiscount
              ? AppColors.bgOrange
              : isDark
              ? Colors.white
              : Colors.black87,
        ),
      ),
    ],
  );
}
