// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/routing/navigator.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_backbutton.dart';
import 'package:fluxfoot_user/core/widgets/custom_searchbar_withfilter.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/filter/view_model/bloc/filter_bloc.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';
import 'package:fluxfoot_user/features/home/view_model/bloc/product_variant_bloc.dart';
import 'package:fluxfoot_user/features/home/view_model/home_bloc/home_bloc.dart';
import 'package:fluxfoot_user/features/home/views/screens/product_view.dart';
import 'package:fluxfoot_user/features/home/views/widgets/product_card_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewAllProducts extends StatelessWidget {
  const ViewAllProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(
        leading: customBackButton(context),
        title: customText(
          25,
          'All Products',
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
                    child: customText(16, 'No featured products available.'),
                  );
                }

                return BlocBuilder<FilterBloc, FilterState>(
                  builder: (context, filterState) {
                    List<ProductModel> filteredProducts = state.products;

                    filteredProducts.sort(
                      (a, b) => b.createdAt.compareTo(a.createdAt),
                    );

                    final query = filterState.searchQuery.toLowerCase();
                    if (query.isNotEmpty) {
                      filteredProducts = filteredProducts.where((product) {
                        return product.name.toLowerCase().trim().contains(
                          query.toLowerCase().trim(),
                        );
                      }).toList();
                    }

                    return Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomSearchBarWithFilter(
                          width: size,
                          height: size * 1.3,
                        ),

                        customText(
                          15,
                          '${filteredProducts.length} products Found',
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                childAspectRatio: 0.85,
                              ),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];

                            return InkWell(
                              onTap: () => fadePush(
                                context,
                                BlocProvider(
                                  create: (context) =>
                                      ProductVariantBloc(product),
                                  child: ProductView(product: product),
                                ),
                              ),
                              child: ProductCard(
                                productName: product.name,
                                regularPrice: product.regularPrice,
                                salePrice: product.salePrice,
                                description: product.description ?? '',
                                product: product,
                                productVariants: product.variants.isNotEmpty
                                    ? product.variants.first
                                    : null,
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
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
