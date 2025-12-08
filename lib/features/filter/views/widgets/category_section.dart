import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/features/filter/view_model/bloc/filter_bloc.dart';
import 'package:fluxfoot_user/features/home/view_model/home_bloc/home_bloc.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  static const categories = [
    'Jerseys',
    'Boots',
    'Balls',
    'Accessories',
    'Gloves',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Category',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textWite,
            ),
          ),
        ),
        SizedBox(
          height: 40,
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, homeState) {
              if (homeState is HomeLoading || homeState is HomeInitial) {
                return Center(child: CircularProgressIndicator());
              }

              if (homeState is HomeError) {
                return Center(child: Text('Error: ${homeState.message}'));
              }

              if (homeState is HomeDataLoaded) {
                final categories = homeState.products
                    .map((p) => p.category)
                    .toSet()
                    .toList();

                // filteredProducts.sort(
                //   (a, b) => b.createdAt.compareTo(a.createdAt),
                // );

                if (categories.isEmpty) {
                  return const Center(
                    child: Text('No product categories found.'),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    // final isSelected = state.brands == category;
                    final isDark =
                        Theme.of(context).brightness == Brightness.dark;

                    return BlocSelector<FilterBloc, FilterState, String?>(
                      selector: (state) => state.selectedCategory,
                      builder: (context, selectedCategory) {
                        final isSelected = selectedCategory == category;
                        return ElevatedButton(
                          onPressed: () => context.read<FilterBloc>().add(
                            ToggleCategory(category),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected
                                ? AppColors.iconOrangeAccent
                                : (isDark
                                      ? Colors.grey[800]
                                      : Colors.grey[200]),
                            foregroundColor: isSelected
                                ? AppColors.textWite
                                : (isDark
                                      ? Colors.grey[300]
                                      : Colors.grey[700]),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            category,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
