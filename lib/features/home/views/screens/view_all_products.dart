// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/routing/navigator.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_backbutton.dart';
import 'package:fluxfoot_user/core/widgets/custom_searchbar_withfilter.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';
import 'package:fluxfoot_user/features/home/view_model/product_variant/product_variant_bloc.dart';
import 'package:fluxfoot_user/features/home/view_model/home_bloc/home_bloc.dart';
import 'package:fluxfoot_user/features/home/views/screens/product_view.dart';
import 'package:fluxfoot_user/features/home/views/widgets/product_card_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

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
          child: Column(
            children: [
              // ! Custom Search Bar With Filter.
              CustomSearchBarWithFilter(width: size, height: size * 1.3),
              // !. PRODUCT/STATU
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading || state is HomeInitial) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (state is HomeError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }

                  if (state is HomeDataLoaded) {
                    final List<ProductModel> productsToDisplay =
                        state.filteredProducts;
                    if (productsToDisplay.isEmpty) {
                      return Column(
                        children: [
                          SizedBox(height: size * 0.3),
                          Lottie.asset(
                            'Flux_Foot/assets/images/lottie/Empty Cart.json',
                          ),
                          customText(
                            size * 0.05,
                            'No products match your filters!.',
                          ),
                        ],
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: size * 0.05,
                      children: [
                        // ! Products Count
                        customText(
                          15,
                          '${productsToDisplay.length} products Found',
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
                          itemCount: productsToDisplay.length,
                          itemBuilder: (context, index) {
                            final product = productsToDisplay[index];

                            return InkWell(
                              onTap: () => fadePush(
                                context,
                                BlocProvider(
                                  create: (context) =>
                                      ProductVariantBloc(product),
                                  // ! Card Product Detaled view..
                                  child: ProductView(product: product),
                                ),
                              ),
                              // ! Gridview Showing Product Cart
                              child: ProductCard(
                                productName: product.name,
                                regularPrice: product.regularPrice.toString(),
                                salePrice: product.salePrice.toString(),
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
                  }
                  return SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
