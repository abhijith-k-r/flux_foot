// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_backbutton.dart';
import 'package:fluxfoot_user/core/widgets/custom_searchbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/home/view_model/home_bloc/home_bloc.dart';
import 'package:fluxfoot_user/features/home/views/screens/perticular_brand.dart';
import 'package:google_fonts/google_fonts.dart';

class AllBrands extends StatelessWidget {
  const AllBrands({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        leading: customBackButton(context),
        title: customText(
          25,
          'All Brands',
          style: GoogleFonts.rozhaOne(fontSize: 28),
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size * 0.04,
          vertical: size * 0.02,
        ),
        child: SingleChildScrollView(
          child: BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (previous, current) {
              return previous != current;
            },
            builder: (context, state) {
              if (state is HomeLoading || state is HomeInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is HomeError) {
                return Center(child: Text('Error: ${state.message}'));
              }

              if (state is HomeDataLoaded) {
                final brands = state.brands;
                final allProducts = state.products;

                if (brands.isEmpty) {
                  return Center(
                    child: customText(16, 'No active brands available.'),
                  );
                }

                final Map<String, int> brandProductCounts = {};
                for (final brand in brands) {
                  final count = allProducts
                      .where((product) => product.brand == brand.name)
                      .length;
                  brandProductCounts[brand.name] = count;
                }

                final sortedBrands = [...brands];

                sortedBrands.sort(
                  (a, b) => brandProductCounts[b.name]!.compareTo(
                    brandProductCounts[a.name]!,
                  ),
                );

                return Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomSearchBarAdvanced(width: size, height: size * 1.3),

                    customText(15, '${sortedBrands.length} products Found'),

                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: sortedBrands.length,
                      itemBuilder: (context, index) {
                        final brand = sortedBrands[index];

                        final productCount =
                            brandProductCounts[brand.name] ?? 0;
                        return Card(
                          color: AppColors.bgWhite,
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
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Center(
                                              child: Icon(
                                                Icons.broken_image,
                                                size: 40,
                                              ),
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
                              color: AppColors.bgGrey,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              }
              return SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
