import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/routing/navigator.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';
import 'package:fluxfoot_user/features/home/view_model/home_bloc/home_bloc.dart';
import 'package:fluxfoot_user/features/home/view_model/product_variant/product_variant_bloc.dart';
import 'package:fluxfoot_user/features/home/views/screens/product_view.dart';
import 'package:fluxfoot_user/features/home/views/widgets/product_card_widget.dart';

// !--- Helper Widget: Search Results View ---
Widget buildSearchResults(BuildContext context, double size, String query) {
  return BlocBuilder<HomeBloc, HomeState>(
    builder: (context, state) {
      if (state is HomeLoading || state is HomeInitial) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state is HomeError) {
        return Center(child: Text('Error: ${state.message}'));
      }

      if (state is HomeDataLoaded) {
        // !1. Filter the products based on the active search query
        List<ProductModel> filteredProducts = state.products.where((product) {
          return product.name.toLowerCase().trim().contains(query);
        }).toList();

        // !2. Sort the filtered products
        filteredProducts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        if (filteredProducts.isEmpty) {
          return Center(
            child: customText(16, 'No products found for "$query".'),
          );
        }

        // !3. Display the results in a grid
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customText(15, '${filteredProducts.length} results for "$query"'),
            SizedBox(height: size * 0.03),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
      }
      return const SizedBox.shrink();
    },
  );
}
