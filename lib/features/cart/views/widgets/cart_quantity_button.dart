import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';

// ! Quatntity Button
class QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const QuantityButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgWhite,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(8),
        child: Icon(icon, size: 18),
      ),
    );
  }
}
