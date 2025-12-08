import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/features/home/models/color_variant.model.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';
import 'package:fluxfoot_user/features/home/view_model/product_variant/product_variant_bloc.dart';

Widget buildColorSelectionRow(
  double size,
  ColorvariantModel selectedVariant,
  ProductVariantBloc variantBloc,
  ProductModel product,
) {
  return SizedBox(
    width: double.infinity,
    height: size * 0.15,
    child: Center(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: product.variants.length,
        itemBuilder: (context, index) {
          final variant = product.variants[index];
          final isSelected = variant.colorName == selectedVariant.colorName;

          final imageUrl = variant.imageUrls;

          final String displayImageUrl = imageUrl.first;

          return Padding(
            padding: EdgeInsets.only(right: size * 0.02),
            child: InkWell(
              onTap: () => variantBloc.add(SelectColorVariant(variant)),
              child: Container(
                width: size * 0.15,
                height: size * 0.15,
                decoration: BoxDecoration(
                  color: hexToColor(variant.colorCode),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.outLineOrang
                        : AppColors.bgWhite,
                    width: isSelected ? 3 : 1,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      displayImageUrl,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                            child: Icon(Icons.broken_image, size: 20),
                          ),
                    ),

                    Positioned(
                      child: SizedBox(
                        child: isSelected
                            ? Icon(
                                Icons.check,
                                color: AppColors.iconOrangeAccent,
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}

// //! Helper function to convert Hex String to Color
Color hexToColor(String code) {
  String hex = code.replaceAll('#', '');
  if (hex.length == 6) {
    hex = 'FF$hex';
  }
  return Color(int.parse(hex, radix: 16));
}
