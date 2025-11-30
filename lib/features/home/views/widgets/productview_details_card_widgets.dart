import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/home/models/color_variant.model.dart';
import 'package:fluxfoot_user/features/home/models/size_quantity_model.dart';
import 'package:fluxfoot_user/features/home/view_model/product_variant/product_variant_bloc.dart';
import 'package:fluxfoot_user/features/home/views/widgets/productview_color_selectionrow_widget.dart';

//! --- Product Details Card (Uses state for Size Selector) ---
Widget buildProductDetails(
  double size,
  String productName,
  String salePrice,
  String regularPrice,
  ColorvariantModel selectedVariant,
  List<SizeQuantityVariant> availableSizes,
  SizeQuantityVariant? selectedSize,
  ProductVariantBloc variantBloc,
) {
  return Card(
    child: Padding(
      padding: EdgeInsets.all(size * 0.03),
      child: Column(
        spacing: size * 0.02,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customText(16, productName, fontWeight: FontWeight.w600),
              Row(
                spacing: size * 0.02,
                children: [
                  customText(15, '₹ $salePrice/-', fontWeight: FontWeight.w600),
                  customText(
                    10,
                    '₹$regularPrice/-',
                    textDecoration: TextDecoration.lineThrough,
                  ),
                ],
              ),
            ],
          ),
          // ! Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: size * 0.02,
                children: [
                  Icon(
                    CupertinoIcons.star_fill,
                    size: size * 0.05,
                    color: AppColors.iconOrangeAccent,
                  ),
                  customText(14, '4.1', fontWeight: FontWeight.w600),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: BoxBorder.all(
                    color: hexToColor(selectedVariant.colorCode),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: size * 0.05,
                    right: size * 0.05,
                  ),
                  child: customText(
                    15,
                    selectedVariant.colorName,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          // ! Product Sizes
          Row(
            children: [
              customText(16, 'Size: ', fontWeight: FontWeight.w600),
              SizedBox(width: size * 0.02),
              if (availableSizes.isNotEmpty)
                SizedBox(
                  width: size * 0.73,
                  height: size * 0.08,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: availableSizes.length,
                    itemBuilder: (context, index) {
                      final sizeVariant = availableSizes[index];
                      final isSelected = sizeVariant.size == selectedSize?.size;
                      return Padding(
                        padding: EdgeInsets.only(right: size * 0.02),
                        child: InkWell(
                          onTap: () =>
                              variantBloc.add(SelectSizeVariant(sizeVariant)),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.bgOrange
                                  : AppColors.scaffBg,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: size * 0.01,
                                left: size * 0.02,
                                right: size * 0.02,
                                bottom: size * 0.01,
                              ),
                              child: customText(15, sizeVariant.size),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                customText(15, 'N/A'),
            ],
          ),
        ],
      ),
    ),
  );
}
