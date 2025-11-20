// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/routing/navigator.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_searchbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/home/view_model/bloc/product_variant_bloc.dart';
import 'package:fluxfoot_user/features/home/view_model/home_bloc/home_bloc.dart';
import 'package:fluxfoot_user/features/home/views/screens/product_view.dart';
import 'package:fluxfoot_user/features/home/views/widgets/product_card_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: size * 0.01),
          child: SizedBox(
            width: 70,
            height: 60,
            child: ShakeX(
              delay: Duration(milliseconds: 900),
              duration: Duration(milliseconds: 900),
              child: Image.asset(
                'Flux_Foot/assets/images/splash/logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        action: [
          IconButton(onPressed: () {}, icon: FaIcon(FontAwesomeIcons.bell)),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size * 0.04,
          vertical: size * 0.02,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomSearchBarAdvanced(width: size, height: size),
              SizedBox(height: size * 0.04),
              Container(
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
                  ),
                ),
              ),
              SizedBox(height: size * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customText(
                    16,
                    'Search by brands',
                    fontWeight: FontWeight.w600,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: customText(15, 'View All'),
                  ),
                ],
              ),

              // ! Search By Brands
              BlocBuilder<HomeBloc, HomeState>(
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

                    if (brands.isEmpty) {
                      return Center(
                        child: customText(16, 'No active brands available.'),
                      );
                    }
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
                            );
                          },
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              SizedBox(height: size * 0.02),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customText(
                    16,
                    'Featured Product',
                    fontWeight: FontWeight.w600,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: customText(15, 'View All'),
                  ),
                ],
              ),

              // ! Featured Products
              BlocBuilder<HomeBloc, HomeState>(
                buildWhen: (previous, current) {
                  return previous != current;
                },
                builder: (context, state) {
                  if (state is HomeLoading || state is HomeInitial) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (state is HomeError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }

                  if (state is HomeDataLoaded) {
                    if (state.products.isEmpty) {
                      return Center(
                        child: customText(
                          16,
                          'No featured products available.',
                        ),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        state.products.sort(
                          (a, b) => b.createdAt.compareTo(a.createdAt),
                        );
                        final product = state.products[index];

                        return InkWell(
                          onTap: () => fadePush(
                            context,
                            BlocProvider(
                              create: (context) => ProductVariantBloc(product),
                              child: ProductView(product: product),
                            ),
                          ),
                          child: ProductCard(
                            productName: product.name,
                            regularPrice: product.regularPrice,
                            salePrice: product.salePrice,
                            description: product.description ?? '',
                            product: product,
                            productVariants: product.variants.first,
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              SizedBox(height: size * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
