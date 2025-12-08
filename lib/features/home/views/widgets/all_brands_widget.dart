// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/widgets/custom_backbutton.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/core/widgets/shimmer_widgets.dart';
import 'package:fluxfoot_user/features/filter/view_model/bloc/filter_bloc.dart';
import 'package:fluxfoot_user/features/home/models/brands_model.dart';
import 'package:fluxfoot_user/features/home/views/screens/perticular_brand.dart';
import 'package:fluxfoot_user/features/home/views/widgets/perticularbrand_tabar_widget.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:lottie/lottie.dart';

// ! All Brands Showing as Gridview
Widget buildAllBrands(
  List<BrandModel> sortedBrands,
  Map<String, int> brandProductCounts,
  double size,
) {
  return BlocBuilder<FilterBloc, FilterState>(
    builder: (context, filterState) {
      List<BrandModel> searchableBrands = [...sortedBrands];
      // ! Searching Brands
      final query = filterState.searchQuery.toLowerCase().trim();
      if (query.isNotEmpty) {
        searchableBrands = searchableBrands.where((brand) {
          return brand.name.toLowerCase().trim().contains(
            query.toLowerCase().trim(),
          );
        }).toList();
      }

      if (searchableBrands.isEmpty) {
        return Column(
          children: [
            SizedBox(height: size * 0.3),
            Lottie.asset('Flux_Foot/assets/images/lottie/Empty Cart.json'),
            customText(size * 0.05, 'Brand Not Found!.'),
          ],
        );
      }
      return Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(15, '${sortedBrands.length} products Found'),

          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: searchableBrands.length,
            itemBuilder: (context, index) {
              final brand = searchableBrands[index];

              final productCount = brandProductCounts[brand.name] ?? 0;
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: LiquidGlassLayer(
                  settings: iosGlassSettings,
                  child: LiquidGlass(
                    shape: LiquidRoundedSuperellipse(borderRadius: 15),
                    child: GlassGlow(
                      child: ListTile(
                        leading: Padding(
                          padding: EdgeInsets.all(size * 0.02),
                          child: Container(
                            width: size * 0.15,
                            height: size * 0.15,
                            decoration: BoxDecoration(
                              color: AppColors.bgBlack,
                              borderRadius: BorderRadius.circular(35),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.bgGrey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(35),
                              child: Image.network(
                                brand.logoUrl ??
                                    'https://via.placeholder.com/150',
                                fit: BoxFit.contain,
                                color: AppColors.bgWhite,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return ShimmerPlaceholder(
                                        width: size * 0.15,
                                        height: size * 0.15,
                                        borderRadius: 35,
                                      );
                                    },
                                errorBuilder: (context, error, stackTrace) =>
                                    const Center(
                                      child: Icon(Icons.broken_image, size: 20),
                                    ),
                              ),
                            ),
                          ),
                        ),
                        title: customText(
                          15,
                          brand.name,
                          fontWeight: FontWeight.bold,
                        ),
                        subtitle: customText(
                          12,
                          '$productCount Products',
                          fontWeight: FontWeight.w500,
                        ),
                        trailing: customForwordButton(
                          context,
                          PerticularBrand(title: brand.name),
                          // color: AppColors.bgGrey,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      );
    },
  );
}
