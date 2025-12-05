import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';

//! Helper method for full-width text fields (keep as-is)
Widget buildTextField({
  required double size,
  required String label,
  required String hint,
  required TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      customText(size * 0.04, label),
      const SizedBox(height: 5),
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) =>
            value == null || value.isEmpty ? 'This field is required' : null,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: AppColors.bgWhite,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          prefixIcon: Icon(
            CupertinoIcons.house_alt,
            color: AppColors.iconBlack,
          ),
        ),
      ),
    ],
  );
}

//! Helper method for half-width text fields (keep as-is)
Widget buildHalfTextField({
  required double size,
  required String label,
  required String hint,
  required TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
}) {
  return SizedBox(
    width: size * 0.4,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(size * 0.04, label),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: (value) =>
              value == null || value.isEmpty ? 'Required' : null,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.bgWhite,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            prefixIcon: Icon(
              CupertinoIcons.location,
              color: AppColors.iconBlack,
            ),
          ),
        ),
      ],
    ),
  );
}
