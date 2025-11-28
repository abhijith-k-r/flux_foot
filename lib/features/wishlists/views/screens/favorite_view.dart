import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/routing/navigator.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_searchbar_withfilter.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/filter/view_model/bloc/filter_bloc.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';
import 'package:fluxfoot_user/features/home/view_model/bloc/product_variant_bloc.dart';
import 'package:fluxfoot_user/features/home/views/screens/product_view.dart';
import 'package:fluxfoot_user/features/home/views/widgets/product_card_widget.dart';
import 'package:fluxfoot_user/features/wishlists/view_model/bloc/favorites_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        title: customText(
          size,
          'Favarites',
          style: GoogleFonts.rozhaOne(fontSize: size * 0.08),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size * 0.04,
          vertical: size * 0.02,
        ),
        child: SingleChildScrollView(
          child: BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.error != null) {
                return Center(child: Text('Error: ${state.error}'));
              }

              final favoriteProducts = state.favoriteProducts;

              if (favoriteProducts.isEmpty) {
                return customText(size * 0.04, 'No favorites added yet!');
              }

              favoriteProducts.sort(
                (a, b) => b.createdAt.compareTo(a.createdAt),
              );

              return Column(
                children: [
                  // ! Custom SearchBar
                  CustomSearchBarWithFilter(width: size, height: size * 1.3),
                  BlocBuilder<FilterBloc, FilterState>(
                    builder: (context, filterState) {
                      List<ProductModel> filteredProducts =
                          state.favoriteProducts;

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
                          customText(
                            15,
                            '${filteredProducts.length} products Found',
                          ),
                          // ! Favorite Products As Gridview
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
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
