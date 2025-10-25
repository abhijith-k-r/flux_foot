import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';

// ! Custom Snack Bar
void customSnackBar(
  BuildContext context,
  String text,
  IconData? icon,
  Color? color,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        spacing: 5,
        children: [
          Icon(icon, color: AppColors.iconWhite),
          Text(text),
        ],
      ),
      action: SnackBarAction(label: 'Undo', onPressed: () {}),
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
    ),
  );
}

// ! Helper method to show feedback to the user
void showFeedback(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  customSnackBar(
    context,
    message,
    isError ? Icons.error_outline : Icons.done_all,
    isError ? AppColors.bgRed : AppColors.sucessGreen,
  );
}
