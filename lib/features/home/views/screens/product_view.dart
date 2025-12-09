import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_backbutton.dart';
import 'package:fluxfoot_user/core/widgets/custom_button.dart';
import 'package:fluxfoot_user/core/widgets/custom_readmore_widget.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';
import 'package:fluxfoot_user/features/home/view_model/product_variant/product_variant_bloc.dart';
import 'package:fluxfoot_user/features/home/views/widgets/productview_carousel_widget.dart';
import 'package:fluxfoot_user/features/home/views/widgets/productview_addtocart_widget.dart';
import 'package:fluxfoot_user/features/home/views/widgets/productview_color_selectionrow_widget.dart';
import 'package:fluxfoot_user/features/home/views/widgets/productview_details_card_widgets.dart';
import 'package:fluxfoot_user/features/home/views/widgets/productview_favoritebutton_widget.dart';

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
          buildAddtoCartButton(size, product),
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
