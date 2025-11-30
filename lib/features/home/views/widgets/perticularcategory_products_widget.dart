import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/routing/navigator.dart';
import 'package:fluxfoot_user/core/widgets/custom_searchbar_withfilter.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/filter/view_model/bloc/filter_bloc.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';
import 'package:fluxfoot_user/features/home/view_model/product_variant/product_variant_bloc.dart';
import 'package:fluxfoot_user/features/home/views/screens/product_view.dart';
import 'package:fluxfoot_user/features/home/views/widgets/product_card_widget.dart';

// ! Products under a specific Category (brand Under Category)
Widget buildCategoryProducts(
  BuildContext context,
  double size,
  List<ProductModel> brandProducts,
  String categoryName,
) {
  return SingleChildScrollView(
    child: Column(
      children: [
        SizedBox(height: size * 0.02),
        // ! Custom SearchBar
        CustomSearchBarWithFilter(width: size, height: size * 1.2),

        BlocBuilder<FilterBloc, FilterState>(
          builder: (context, filterState) {
            //! 1. Filter by Category (using the categoryName passed to this screen)
            final List<ProductModel> categoryProducts =
                brandProducts
                    .where((product) => product.category == categoryName)
                    .toList()
                  ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

            //! 2. Filter by search query (from FilterBloc)
            final query = filterState.searchQuery.toLowerCase().trim();
            final List<ProductModel> visibleProducts = query.isEmpty
                ? categoryProducts
                : categoryProducts.where((product) {
                    return product.name.toLowerCase().contains(query);
                  }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(15, '${visibleProducts.length} Products Found'),
                SizedBox(height: 10),

                if (visibleProducts.isEmpty)
                  Center(
                    child: customText(
                      16,
                      'No $categoryName products available.',
                    ),
                  )
                else
                  SizedBox(height: size * 0.02),
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
                        regularPrice: product.regularPrice,
                        salePrice: product.salePrice,
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
