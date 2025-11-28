import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/routing/navigator.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_backbutton.dart';
import 'package:fluxfoot_user/core/widgets/custom_searchbar_withfilter.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/filter/view_model/bloc/filter_bloc.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';
import 'package:fluxfoot_user/features/home/view_model/bloc/product_variant_bloc.dart';
import 'package:fluxfoot_user/features/home/view_model/home_bloc/home_bloc.dart';
import 'package:fluxfoot_user/features/home/views/screens/perticular_categories.dart';
import 'package:fluxfoot_user/features/home/views/screens/product_view.dart';
import 'package:fluxfoot_user/features/home/views/widgets/product_card_widget.dart';
import 'package:fluxfoot_user/features/home/views/widgets/show_cart_count.dart';

class PerticularBrand extends StatelessWidget {
  final String title;
  const PerticularBrand({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
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

                // Get unique categories from filtered products
                final categories = filteredProducts
                    .map((p) => p.category)
                    .toSet()
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ! Custom Tab Bar (Category & Products)
                    buildCustomTabBar(
                      context,
                      size,
                      categories.length,
                      filteredProducts.length,
                    ),

                    SizedBox(height: 10),
                    Expanded(
                      child: TabBarView(
                        children: [
                          buildCategoriesTab(categories, size),
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

  // ! Custom Tab Bar Widget
  Widget buildCustomTabBar(
    BuildContext context,
    double size,
    int categoryCount,
    int productCount,
  ) {
    return Container(
      height: size * 0.12,
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TabBar(
        indicator: BoxDecoration(
          color: AppColors.bgOrange,
          borderRadius: BorderRadius.circular(15),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customText(
                  size * 0.04,
                  'Category',
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(width: size * 0.02),
                Container(
                  padding: EdgeInsets.all(size * 0.015),
                  decoration: BoxDecoration(
                    color: AppColors.bgBlack,
                    shape: BoxShape.circle,
                  ),
                  child: customText(
                    size * 0.03,
                    categoryCount.toString(),
                    appColor: AppColors.textWite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customText(
                  size * 0.04,
                  'Products',
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(width: size * 0.02),
                Container(
                  padding: EdgeInsets.all(size * 0.015),
                  decoration: BoxDecoration(
                    color: AppColors.bgBlack,
                    shape: BoxShape.circle,
                  ),
                  child: customText(
                    size * 0.03,
                    productCount.toString(),
                    appColor: AppColors.textWite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ! Categories Tab Content
  Widget buildCategoriesTab(List<String> categories, double size) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // ! Custom SearchBar
          CustomSearchBarWithFilter(width: size, height: size * 1.2),

          BlocBuilder<FilterBloc, FilterState>(
            builder: (context, filterState) {
              final List<String> allCategories = List<String>.from(categories)
                ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

              final query = filterState.searchQuery.toLowerCase().trim();
              List<String> visibleCategory = query.isEmpty
                  ? allCategories
                  : allCategories.where((category) {
                      return category.toLowerCase().contains(query);
                    }).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(15, '${visibleCategory.length} Category Found'),
                  SizedBox(height: 10),

                  if (visibleCategory.isEmpty)
                    Center(child: customText(16, 'No Category available.'))
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: visibleCategory.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.only(bottom: size * 0.03),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: size * 0.04,
                              vertical: size * 0.02,
                            ),
                            title: customText(
                              16,
                              visibleCategory[index].toString(),
                              fontWeight: FontWeight.w500,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey,
                            ),
                            onTap: () {
                              fadePush(
                                context,
                                PerticularCategories(
                                  title: visibleCategory[index].toString(),
                                ),
                              );
                            },
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
          CustomSearchBarWithFilter(width: size, height: size * 1.2),
          BlocBuilder<FilterBloc, FilterState>(
            builder: (context, filterState) {
              final List<ProductModel> allBrandProducts =
                  List<ProductModel>.from(filteredProducts)
                    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

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
                    Center(
                      child: customText(16, 'No $title products available.'),
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
}
