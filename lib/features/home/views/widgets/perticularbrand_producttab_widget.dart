import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/routing/navigator.dart';
import 'package:fluxfoot_user/core/widgets/custom_searchbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/filter/view_model/bloc/filter_bloc.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';
import 'package:fluxfoot_user/features/home/view_model/product_variant/product_variant_bloc.dart';
import 'package:fluxfoot_user/features/home/views/screens/product_view.dart';
import 'package:fluxfoot_user/features/home/views/widgets/product_card_widget.dart';
import 'package:lottie/lottie.dart';

// ! Products Tab Content
Widget buildProductsTab(
  List<ProductModel> filteredProducts,
  BuildContext context,
  double size,
  String title,
) {
  return SingleChildScrollView(
    child: Column(
      children: [
        // ! Custom SearchBar
        CustomSearchBar(width: size, height: size * 1.2),
        BlocBuilder<FilterBloc, FilterState>(
          builder: (context, filterState) {
            final List<ProductModel> allBrandProducts = List<ProductModel>.from(
              filteredProducts,
            )..sort((a, b) => b.createdAt.compareTo(a.createdAt));

            final query = filterState.searchQuery.toLowerCase().trim();
            final List<ProductModel> visibleProducts = query.isEmpty
                ? allBrandProducts
                : allBrandProducts.where((product) {
                    return product.name.toLowerCase().contains(query);
                  }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(15, '${visibleProducts.length} Products Found'),
                SizedBox(height: 10),

                if (visibleProducts.isEmpty)
                  Column(
                    children: [
                      SizedBox(height: size * 0.3),
                      Lottie.asset(
                        'Flux_Foot/assets/images/lottie/Empty Cart.json',
                      ),
                      customText(size * 0.05, '$title products Not Found!.'),
                    ],
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: visibleProducts.length,
                    itemBuilder: (context, index) {
                      final product = visibleProducts[index];

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
                          regularPrice: product.regularPrice.toString(),
                          salePrice: product.salePrice.toString(),
                          description: product.description ?? '',
                          product: product,
                          productVariants: product.variants.first,
                        ),
                      );
                    },
                  ),
              ],
            );
          },
        ),
      ],
    ),
  );
}
