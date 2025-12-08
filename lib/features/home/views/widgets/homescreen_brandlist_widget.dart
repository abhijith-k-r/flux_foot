// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/core/widgets/shimmer_widgets.dart';
import 'package:fluxfoot_user/features/home/models/brands_model.dart';
import 'package:fluxfoot_user/features/home/view_model/home_bloc/home_bloc.dart';

//! Extracting brand list logic into a separate widget for clarity
class BrandListWidget extends StatelessWidget {
  const BrandListWidget({super.key, required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state is HomeLoading || state is HomeInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is HomeError) {
          return Center(child: Text('Error loading brands: ${state.message}'));
        }

        if (state is HomeDataLoaded) {
          final brands = state.brands;
          if (brands.isEmpty) {
            return Center(child: customText(16, 'No active brands available.'));
          }
          return _buildBrandsContent(context, brands);
        }
        return const SizedBox.shrink();
      },
    );
  }

  _buildBrandsContent(BuildContext context, List<BrandModel> brands) {
    return SizedBox(
      width: double.infinity,
      height: size * 0.19,
      child: Center(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: brands.length,
          itemBuilder: (context, index) {
            final brand = brands[index];
            return Padding(
              padding: EdgeInsets.all(size * 0.02),
              child: Container(
                width: size * 0.15,
                height: size * 0.15,
                decoration: BoxDecoration(
                  color: AppColors.bgWhite,
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.bgGrey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: Image.network(
                    brand.logoUrl ?? 'https://via.placeholder.com/150',
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return ShimmerPlaceholder(
                        width: size * 0.15,
                        height: size * 0.15,
                        borderRadius: 35,
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.broken_image, size: 20)),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
