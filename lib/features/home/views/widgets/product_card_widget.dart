import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/home/models/color_variant.model.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';
import 'package:fluxfoot_user/features/wishlists/view_model/bloc/favorites_bloc.dart';

class ProductCard extends StatelessWidget {
  final String productName;
  // final List<String> imageUrl;
  final String regularPrice;
  final String salePrice;
  final String description;
  final ProductModel product;
  final ColorvariantModel? productVariants;
  const ProductCard({
    super.key,
    required this.productName,
    // required this.imageUrl,
    required this.regularPrice,
    required this.salePrice,
    required this.description,
    required this.product,
    required this.productVariants,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;

    String? firstVariantImage;
    if ((product.variants.isNotEmpty)) {
      for (final v in product.variants) {
        if (v.imageUrls.isNotEmpty) {
          firstVariantImage = v.imageUrls.first;
          break;
        }
      }
    }

    final imageUrl =
        firstVariantImage ??
        (product.images.isNotEmpty ? product.images.first : null);

    final String displayImageUrl =
        imageUrl ?? 'https://example.com/placeholder.png';
    return Card(
      color: AppColors.bgWhite,
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned(
            top: 7,
            left: 25,
            right: 25,
            child: SizedBox(
              width: 140,
              height: 90,
              child: Image.network(
                displayImageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.broken_image, size: 40)),
              ),
            ),
          ),

          Positioned(
            top: 103,
            left: 5,
            right: 5,
            child: Container(
              width: 160,
              height: 95,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFD4D4D4), Color(0xFFF9F9F9)],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(size * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: size * 0.005,
                  children: [
                    customText(
                      size * 0.033,
                      productName,
                      fontWeight: FontWeight.bold,
                    ),
                    // ! For RATING
                    Row(
                      spacing: 5,
                      children: [
                        customText(size * 0.03, 'rating'),
                        customText(
                          size * 0.03,
                          '4.9',
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            customText(
                              size * 0.04,
                              '₹ $salePrice/-',
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(width: 5),
                            customText(
                              size * 0.025,
                              '₹ $regularPrice/-',
                              textDecoration: TextDecoration.lineThrough,
                            ),
                          ],
                        ),

                        // ! Container Icon For Cart
                        Container(
                          width: size * 0.08,
                          height: size * 0.08,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.bgOrangeAccent,
                                Color(0xFFF9F9F9),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),

                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(1),
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.bgWhite,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Icon(
                                  CupertinoIcons.cart,
                                  color: AppColors.iconOrangeAccent,
                                  size: size * 0.045,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // ! After Filled Cart
                        // Container(
                        //   width: size * 0.08,
                        //   height: size * 0.08,

                        //   decoration: BoxDecoration(
                        //     color: AppColors.bgOrange,
                        //     borderRadius: BorderRadius.circular(7),
                        //   ),
                        //   child: Icon(
                        //     CupertinoIcons.cart_fill,
                        //     color: AppColors.iconWhite,
                        //     size: size * 0.045,
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: BlocBuilder<FavoritesBloc, FavoritesState>(
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
                    isFavorite
                        ? CupertinoIcons.heart_fill
                        : CupertinoIcons.heart,
                    color: isFavorite
                        ? AppColors.iconOrangeAccent
                        : AppColors.outLineOrang,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
