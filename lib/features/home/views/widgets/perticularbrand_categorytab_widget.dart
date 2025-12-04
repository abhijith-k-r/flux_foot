import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/widgets/custom_backbutton.dart';
import 'package:fluxfoot_user/core/widgets/custom_searchbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/filter/view_model/bloc/filter_bloc.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';
import 'package:fluxfoot_user/features/home/views/screens/perticular_categories.dart';
import 'package:lottie/lottie.dart';

// ! Categories Tab Content
Widget buildCategoriesTab(
  List<String> categories,
  double size,
  Map<String, int> categoryCount,
  Map<String, String> categoryImages,
  List<ProductModel> brandProducts,
) {
  return SingleChildScrollView(
    child: Column(
      children: [
        // ! Custom SearchBar
        CustomSearchBar(width: size, height: size * 1.2),

        BlocBuilder<FilterBloc, FilterState>(
          builder: (context, filterState) {
            List<String> allCategories = [...categories];

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
                  Column(
                    children: [
                      SizedBox(height: size * 0.3),
                      Lottie.asset(
                        'Flux_Foot/assets/images/lottie/Empty Cart.json',
                      ),
                      customText(size * 0.05, 'No Category Available.'),
                    ],
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: visibleCategory.length,
                    itemBuilder: (context, index) {
                      final category = visibleCategory[index];
                      final counts = categoryCount[category] ?? 0;

                      return Card(
                        color: AppColors.bgWhite,
                        child: ListTile(
                          leading: SizedBox(),
                          title: customText(
                            15,
                            category,
                            fontWeight: FontWeight.bold,
                          ),
                          subtitle: customText(
                            12,
                            '$counts Products',
                            fontWeight: FontWeight.w500,
                          ),
                          trailing: customForwordButton(
                            context,
                            PerticularCategories(
                              brandProducts: brandProducts,
                              categoryName: category,
                            ),
                            color: AppColors.bgGrey,
                          ),
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
