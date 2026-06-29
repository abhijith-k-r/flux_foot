// ignore_for_file: deprecated_member_use


import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';

//!  Helper Widget: Payment Card
Widget buildPaymentCard({required bool isDark, required VoidCallback onEdit}) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: isDark ? Colors.grey[800] : Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[200]!),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.credit_card, size: 20, color: AppColors.bgGrey),
                const SizedBox(width: 8),
                Text(
                  'Payment Method',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              width: 48,
              height: 32,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
              child: Center(
                child: Image.asset(
                  'Flux_Foot/assets/images/icons/stripe-com-logo.png',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Stripe',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    ),
  );
}
