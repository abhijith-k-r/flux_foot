import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/routing/navigator.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';
import 'package:fluxfoot_user/features/home/view_model/home_bloc/home_bloc.dart';
import 'package:fluxfoot_user/features/home/view_model/product_variant/product_variant_bloc.dart';
import 'package:fluxfoot_user/features/home/views/screens/product_view.dart';
import 'package:fluxfoot_user/features/home/views/widgets/product_card_widget.dart';
import 'package:lottie/lottie.dart';

// ! Extracting featured products logic into a separate widget for clarity
class FeaturedProductGrid extends StatelessWidget {
  const FeaturedProductGrid({super.key, required this.size});
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
          return Center(
            child: Text('Error loading products: ${state.message}'),
          );
        }

        if (state is HomeDataLoaded) {
          // !Sort products by creation date (newest first)
          state.products.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          if (state.products.isEmpty) {
            return Column(
              children: [
                Lottie.asset(
                  'Flux_Foot/assets/images/lottie/Empty Cart.json',
                  width: size * 0.3,
                ),
                customText(size * 0.04, 'No products match your filters!.'),
              ],
            );
          }

          // ! Limit to 4 products for the home screen view
          final List<ProductModel> featured = state.originalProducts
              .take(4)
              .toList();

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 0.85,
            ),
            itemCount: featured.length,
            itemBuilder: (context, index) {
              final product = featured[index];

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
                  productVariants: product.variants.isNotEmpty
                      ? product.variants.first
                      : null,
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
