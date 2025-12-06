import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/features/filter/view_model/bloc/filter_bloc.dart';
import 'package:fluxfoot_user/features/home/view_model/home_bloc/home_bloc.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // final bgColor = isDark ? const Color(0xFF101622) : const Color(0xFFF5F6F8);

    final filterBloc = context.read<FilterBloc>();
    final homeBloc = context.read<HomeBloc>();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // border: Border(
        //   top: BorderSide(
        //     color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        //   ),
        // ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                filterBloc.add(ResetFilters());

                homeBloc.add(
                  FilterProducts(
                    filterBloc.state.copyWith(
                      selectedSort: SortOption.newestFirst,
                      selectedCategory: '',
                      minPrice: filterBloc.state.minPrice,
                      maxPrice: filterBloc.state.maxPrice,
                      searchQuery: '',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                foregroundColor: isDark ? Colors.white : Colors.grey[900],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Reset',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                final currentFilterState = filterBloc.state;
                homeBloc.add(FilterProducts(currentFilterState));
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.iconOrangeAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Apply Filters',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
