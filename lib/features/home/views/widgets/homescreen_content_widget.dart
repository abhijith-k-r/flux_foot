import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/routing/navigator.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/core/widgets/shimmer_widgets.dart';
import 'package:fluxfoot_user/features/filter/view_model/bloc/filter_bloc.dart';
import 'package:fluxfoot_user/features/home/views/screens/all_brands.dart';
import 'package:fluxfoot_user/features/home/views/screens/view_all_products.dart';
import 'package:fluxfoot_user/features/home/views/widgets/homescreen_brandlist_widget.dart';
import 'package:fluxfoot_user/features/home/views/widgets/homescreen_featured_product_widget.dart';

//! --- Helper Widget: Normal Home Content ---
Widget buildHomeContent(BuildContext context, double size) {
  return Column(
    children: [
      // ! Main Banner
      ZoomIn(
        delay: const Duration(milliseconds: 100),
        duration: const Duration(milliseconds: 900),
        child: Container(
          width: size * 0.99,
          height: size * 0.4,
          decoration: BoxDecoration(
            color: AppColors.bgWhite,
            borderRadius: BorderRadius.circular(25),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.network(
              'https://i.pinimg.com/1200x/ca/e7/0d/cae70d9b1688cc21c1d7c2d07d0d808f.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return ShimmerPlaceholder(
                  width: size * 0.99,
                  height: size * 0.4,
                  borderRadius: 25,
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: size * 0.99,
                  height: size * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Icon(Icons.broken_image_rounded,
                        color: Colors.grey, size: 40),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      SizedBox(height: size * 0.01),

      // ! Brands Header
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customText(16, 'Search by brands', fontWeight: FontWeight.w600),
          TextButton(
            onPressed: () {
              fadePush(
                context,
                BlocProvider(
                  create: (_) => FilterBloc(),
                  child: const AllBrands(),
                ),
              );
            },
            child: customText(15, 'View All'),
          ),
        ],
      ).fadeInLeft(duration: const Duration(milliseconds: 600)),

      // ! Search By Brands List
      BrandListWidget(size: size).slideInRight(
        delay: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 700),
      ),

      SizedBox(height: size * 0.03),

      // ! Featured Products Header
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customText(16, 'Featured Product', fontWeight: FontWeight.w600),
          TextButton(
            onPressed: () {
              fadePush(
                context,
                BlocProvider(
                  create: (_) => FilterBloc(),
                  child: const ViewAllProducts(),
                ),
              );
            },
            child: customText(15, 'View All'),
          ),
        ],
      ).fadeInLeft(duration: const Duration(milliseconds: 600)),
      SizedBox(height: size * 0.02),

      // ! Featured Products Grid (limited to 4)
      FeaturedProductGrid(size: size).fadeInUp(
        delay: const Duration(milliseconds: 300),
        duration: const Duration(milliseconds: 800),
      ),
    ],
  );
}
