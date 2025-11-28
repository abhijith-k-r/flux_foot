import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_backbutton.dart';
import 'package:fluxfoot_user/core/widgets/custom_button.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/cart/view_model/bloc/cart_bloc.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';
import 'package:fluxfoot_user/features/home/view_model/bloc/product_variant_bloc.dart';
import 'package:fluxfoot_user/features/wishlists/view_model/bloc/favorites_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

class ProductView extends StatelessWidget {
  final ProductModel product;
  const ProductView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    final variantBloc = context.read<ProductVariantBloc>();

    return Scaffold(
      appBar: CustomAppBar(
        leading: customBackButton(context),
        action: [
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              final isFavorite = state.favoriteIds.contains(product.id);
              return IconButton(
                onPressed: () {
                  context.read<FavoritesBloc>().add(
                    ToggleFavoriteEvent(
                      productModel: product,
                      isFavorites: isFavorite,
                    ),
                  );
                },
                icon: Icon(
                  isFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                  color: isFavorite
                      ? AppColors.iconOrangeAccent
                      : AppColors.outLineOrang,
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductVariantBloc, ProductVariantState>(
        builder: (context, state) {
          final currentImages = state.currentImages;
          final selectedVariant = state.selectedVariant;
          final selectedSize = state.selectedSize;
          final availableSizes = state.selectedVariant.sizes;

          // Static product details
          final String productName = product.name;
          final String regularPrice = product.regularPrice;
          final String salePrice = product.salePrice;
          final String description = product.description ?? '';

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(size * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: size * 0.02,
                children: [
                  Center(
                    child: SizedBox(
                      height: size * 0.8,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: currentImages.length,
                        itemBuilder: (context, i) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            child: Image.network(currentImages[i]),
                          );
                        },
                      ),
                    ),
                  ),
                  //! --- Color Selector Row ---
                  if (product.variants.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      height: size * 0.15,
                      child: Center(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: product.variants.length,
                          itemBuilder: (context, index) {
                            final variant = product.variants[index];
                            final isSelected =
                                variant.colorName == selectedVariant.colorName;

                            return Padding(
                              padding: EdgeInsets.only(right: size * 0.02),
                              child: InkWell(
                                onTap: () => variantBloc.add(
                                  SelectColorVariant(variant),
                                ),
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
                                  child: isSelected
                                      ? Icon(
                                          Icons.check,
                                          color: AppColors.bgWhite,
                                        )
                                      : null,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  SizedBox(height: size * 0.02),
                  //! --- Product Details Card (Uses state for Size Selector) ---
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(size * 0.03),
                      child: Column(
                        spacing: size * 0.02,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customText(
                                16,
                                productName,
                                fontWeight: FontWeight.w600,
                              ),
                              Row(
                                spacing: size * 0.02,
                                children: [
                                  customText(
                                    15,
                                    '₹ $salePrice/-',
                                    fontWeight: FontWeight.w600,
                                  ),
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
                                  customText(
                                    14,
                                    '4.1',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: BoxBorder.all(
                                    color: hexToColor(
                                      selectedVariant.colorCode,
                                    ),
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
                              customText(
                                16,
                                'Size: ',
                                fontWeight: FontWeight.w600,
                              ),
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
                                      final isSelected =
                                          sizeVariant.size ==
                                          selectedSize?.size;
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          right: size * 0.02,
                                        ),
                                        child: InkWell(
                                          onTap: () => variantBloc.add(
                                            SelectSizeVariant(sizeVariant),
                                          ),
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? AppColors.bgOrange
                                                  : AppColors.scaffBg,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                top: size * 0.01,
                                                left: size * 0.02,
                                                right: size * 0.02,
                                                bottom: size * 0.01,
                                              ),
                                              child: customText(
                                                15,
                                                sizeVariant.size,
                                              ),
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
                  ),

                  customText(16, 'Description', fontWeight: FontWeight.w600),
                  // ! Custom Read More Text
                  customReadmoreText(description),
                  SizedBox(height: size * 1),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: size * 0.02,
        children: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              final isCart = state.cartIds.contains(product.id);
              return CustomButton(
                width: 180,
                ontap: () {
                  context.read<CartBloc>().add(
                    ToggleCart(productModel: product, isCart: isCart),
                  );
                },
                backColor: AppColors.bgWhite,
                textColor: AppColors.textBlack,
                widget: Icon(
                  isCart ? CupertinoIcons.cart_fill : CupertinoIcons.cart,
                  color: isCart ? AppColors.iconOrangeAccent  : null,
                ),
                text: isCart ? 'Added To Cart' : 'Add to Cart',
                fontSize: size * 0.04,
                fontWeight: FontWeight.bold,
              );
            },
          ),
          CustomButton(
            width: 180,
            backColor: AppColors.bgOrange,
            textColor: AppColors.textBlack,
            widget: Icon(Icons.price_change),
            text: 'Buy now',
            fontSize: size * 0.04,
            fontWeight: FontWeight.bold,
            ontap: () {},
          ),
        ],
      ),
    );
  }
}

// ! Custom READ MORE TEXT

customReadmoreText(String description) {
  return ReadMoreText(
    description,
    trimLines: 5,
    colorClickableText: AppColors.textBlack,
    trimMode: TrimMode.Line,
    trimCollapsedText: '...Read more',
    trimExpandedText: ' Less',
    style: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w500),
    moreStyle: GoogleFonts.openSans(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: AppColors.textBlack,
    ),
    lessStyle: GoogleFonts.openSans(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: AppColors.textBlack,
    ),
  );
}

//! Helper function to convert Hex String to Color
Color hexToColor(String code) {
  String hex = code.replaceAll('#', '');
  if (hex.length == 6) {
    hex = 'FF$hex';
  }
  return Color(int.parse(hex, radix: 16));
}
