import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/services/firebase/seller_repository.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_backbutton.dart';
import 'package:fluxfoot_user/core/widgets/custom_button.dart';
import 'package:fluxfoot_user/core/widgets/custom_readmore_widget.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/core/widgets/shimmer_widgets.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';
import 'package:fluxfoot_user/features/home/view_model/cubit/seller_cubit.dart';
import 'package:fluxfoot_user/features/home/view_model/cubit/seller_state.dart';
import 'package:fluxfoot_user/features/home/view_model/product_variant/product_variant_bloc.dart';
import 'package:fluxfoot_user/features/home/views/widgets/productview_carousel_widget.dart';
import 'package:fluxfoot_user/features/home/views/widgets/productview_addtocart_widget.dart';
import 'package:fluxfoot_user/features/home/views/widgets/productview_color_selectionrow_widget.dart';
import 'package:fluxfoot_user/features/home/views/widgets/productview_details_card_widgets.dart';
import 'package:fluxfoot_user/features/home/views/widgets/productview_favoritebutton_widget.dart';
import 'package:fluxfoot_user/features/home/views/widgets/productview_helperfucntion.dart';
import 'package:google_fonts/google_fonts.dart';

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
          // ! Favorite Button
          buildCustomFavoriteButton(product),
        ],
      ),
      body: BlocBuilder<ProductVariantBloc, ProductVariantState>(
        builder: (context, state) {
          final currentImages = state.currentImages;
          final selectedVariant = state.selectedVariant;
          final selectedSize = state.selectedSize;
          final availableSizes = state.selectedVariant.sizes;

          final String productName = product.name;
          final String regularPrice = product.regularPrice.toString();
          final String salePrice = product.salePrice.toString();
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
                      child: currentImages.isEmpty
                          ? Center(child: customText(15, "No Images Available"))
                          // !Custom Carousal Image Flicker
                          : ProductImageFlipCarousel(
                              images: currentImages,
                              height: size * 1,
                            ),
                    ),
                  ),

                  // ! here to show the current index
                  Center(child: buildCarouselIndex(currentImages)),
                  SizedBox(height: size * 0.02),

                  //! --- Color Selector Row ---
                  if (product.variants.isNotEmpty)
                    buildColorSelectionRow(
                      size,
                      selectedVariant,
                      variantBloc,
                      product,
                    ),
                  SizedBox(height: size * 0.02),
                  //! --- Product Details Card (Uses state for Size Selector) ---
                  buildProductDetails(
                    size,
                    productName,
                    salePrice,
                    regularPrice,
                    selectedVariant,
                    availableSizes,
                    selectedSize,
                    variantBloc,
                  ),
                  customText(16, 'Description', fontWeight: FontWeight.w600),
                  // ! Custom Read More Text
                  customReadmoreText(description),
                  SizedBox(height: 10),
                  // ! Seller Details
                  BlocProvider(
                    create: (context) =>
                        SellerCubit(SellerRepository())
                          ..fetchSeller(product.sellerId),
                    child: BlocBuilder<SellerCubit, SellerState>(
                      builder: (context, state) {
                        if (state is SellerLoaded) {
                          return SizedBox(
                            width: double.infinity,
                            child: Row(
                              children: [
                                Container(
                                  height: size * 0.11,
                                  width: size * 0.11,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.bgWhite,
                                  ),
                                  child: Center(
                                    child: Text(
                                      state.seller.name,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.openSans(
                                        fontSize: size * 0.015,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),

                                SizedBox(width: 10),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      spacing: 5,
                                      children: [
                                        customText(
                                          size * 0.04,
                                          state.seller.storeName,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        CircleAvatar(
                                          radius: size * 0.02,
                                          backgroundColor:
                                              AppColors.sucessGreen,
                                          child: Icon(
                                            CupertinoIcons.check_mark,
                                            size: size * 0.02,
                                            color: AppColors.iconWhite,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),

                                    Row(
                                      spacing: 10,
                                      children: [
                                        customText(
                                          size * 0.03,
                                          '98% Positive',
                                          appColor: AppColors.bgOrange,
                                        ),
                                        customText(
                                          size * 0.033,
                                          'In Active Seller',
                                          appColor: AppColors.textGrey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                Spacer(),

                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    width: size * 0.2,
                                    height: size * 0.07,
                                    decoration: BoxDecoration(
                                      border: BoxBorder.all(
                                        width: .3,
                                        color: AppColors.outLineOrang,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      color: AppColors.bgWhite,
                                    ),
                                    child: Center(
                                      child: customText(
                                        10,
                                        'View Profile',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                          // ListTile(
                          // leading: Container(
                          //   height: size * 0.3,
                          //   width: size * 0.3,
                          //   // radius: size * 0.05,
                          //   // backgroundColor: AppColors.bgWhite,
                          //   // // AppColors.bgOrangeAccent,
                          //   decoration: BoxDecoration(
                          //     shape: BoxShape.circle,
                          //     color: AppColors.bgWhite,
                          //   ),
                          //   child: Center(
                          //     child: customText(
                          //       8,
                          //       state.seller.name,
                          //       maxLines: 2,
                          //     ),
                          //   ),
                          // ),
                          // title: Row(
                          //   spacing: 5,
                          //   children: [
                          //     customText(
                          //       size * 0.04,
                          //       state.seller.storeName,
                          //       fontWeight: FontWeight.w600,
                          //     ),
                          //     CircleAvatar(
                          //       radius: size * 0.02,
                          //       backgroundColor: AppColors.sucessGreen,
                          //       child: Icon(
                          //         CupertinoIcons.check_mark,
                          //         size: size * 0.02,
                          //         color: AppColors.iconWhite,
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // subtitle: Row(
                          //   spacing: 10,
                          //   children: [
                          //     customText(
                          //       size * 0.03,
                          //       '98% Positive',
                          //       appColor: AppColors.bgOrange,
                          //     ),
                          //     customText(
                          //       size * 0.033,
                          //       'In Active Seller',
                          //       appColor: AppColors.textGrey,
                          //       fontWeight: FontWeight.w500,
                          //     ),
                          //   ],
                          // ),
                          // trailing: InkWell(
                          //   onTap: () {},
                          //   child: Container(
                          //     width: size * 0.2,
                          //     height: size * 0.07,
                          //     decoration: BoxDecoration(
                          //       border: BoxBorder.all(
                          //         width: .3,
                          //         color: AppColors.outLineOrang,
                          //       ),
                          //       borderRadius: BorderRadius.circular(15),
                          //       color: AppColors.bgWhite,
                          //     ),
                          //     child: Center(
                          //       child: customText(
                          //         10,
                          //         'View Profile',
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // );
                        }
                        return ShimmerWrapper(child: ListTile());
                      },
                    ),
                  ),
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
          // ! Add to Cart Button
          BlocBuilder<ProductVariantBloc, ProductVariantState>(
            builder: (context, variantState) {
              final selectedVariant = variantState.selectedVariant;
              final selectedSize = variantState.selectedSize;
              return buildAddtoCartButton(
                size,
                product,
                selectedColorName: selectedVariant.colorName,
                selectedSize: selectedSize?.size,
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
            ontap: () {
              goToCheckout(context, product);
            },
          ),
        ],
      ),
    );
  }
}
