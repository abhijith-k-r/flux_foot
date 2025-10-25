import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';

// ! Custom Back Button
Padding customBackButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: GestureDetector(
      onTap: () => Navigator.pop(context),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.bgWhite,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.arrow_back_ios_new),
        ),
      ),
    ),
  );
}
