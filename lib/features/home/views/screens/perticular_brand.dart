import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_backbutton.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/filter/view_model/bloc/filter_bloc.dart';
import 'package:fluxfoot_user/features/home/view_model/home_bloc/home_bloc.dart';
import 'package:fluxfoot_user/features/home/views/widgets/perticularbrand_categorytab_widget.dart';
import 'package:fluxfoot_user/features/home/views/widgets/perticularbrand_producttab_widget.dart';
import 'package:fluxfoot_user/features/home/views/widgets/perticularbrand_tabar_widget.dart';
import 'package:fluxfoot_user/features/home/views/widgets/show_cart_count.dart';

class PerticularBrand extends StatelessWidget {
  final String title;
  const PerticularBrand({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: CustomAppBar(
          leading: customBackButton(context),
          title: Center(
            child: customText(size * 0.065, title, fontWeight: FontWeight.w600),
          ),
          action: [
            // ! Showing Carted Items Count
            showCartCountBox(size),
            SizedBox(width: size * 0.01),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size * 0.04,
            vertical: size * 0.02,
          ),
          child: BlocBuilder<HomeBloc, HomeState>(
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
                final filteredProducts = state.products
                    .where((product) => product.brand == title)
                    .toList();

                filteredProducts.sort(
                  (a, b) => b.createdAt.compareTo(a.createdAt),
                );

                //! Get unique categories from filtered products
                final categories = filteredProducts
                    .map((p) => p.category)
                    .toSet()
                    .toList();

                final Map<String, int> categoryCount = {};
                for (final category in categories) {
                  final count = categories
                      .where((prduct) => prduct == category)
                      .length;

                  categoryCount[category] = count;
                }

                // ! Category Images
                final Map<String, String> categoryImagaes = {};
                for (final product in filteredProducts) {
                  final categoryName = product.category;

                  if (!categoryImagaes.containsKey(categoryName)) {
                    final validImage = product.images.firstWhere(
                      (url) => url.isNotEmpty,
                      orElse: () => '',
                    );

                    if (validImage.isNotEmpty) {
                      categoryImagaes[categoryName] = validImage;
                    }
                  }
                }
                final sortedCategory = [...categories];
                // ! Comparing to show based on Category Counts
                sortedCategory.sort(
                  (a, b) => categoryCount[b]!.compareTo(categoryCount[a]!),
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ! Custom Tab Bar (Category & Products)
                    buildCustomTabBar(
                      context,
                      size,
                      sortedCategory.length,
                      filteredProducts.length,
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // ! Custom Category Tab Bar(showing as Listview)
                          buildCategoriesTab(
                            sortedCategory,
                            size,
                            categoryCount,
                            categoryImagaes,
                            filteredProducts,
                          ),
                          // ! Custom Product Tab Bar (Showing as Gridview)
                          BlocProvider(
                            create: (_) => FilterBloc(),
                            child: buildProductsTab(
                              filteredProducts,
                              context,
                              size,
                              title,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
