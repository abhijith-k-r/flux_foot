import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/routing/navigator.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_searchbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSearchBarAdvanced(width: size, height: size * 1.3),
                  customText(15, '${favoriteProducts.length} Products Found'),
                  SizedBox(height: size * 0.05),
                  // ! Favorites Products as Gridview
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: favoriteProducts.length,
                    itemBuilder: (context, index) {
                      final product = favoriteProducts[index];

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
        ),
      ),
    );
  }
}
