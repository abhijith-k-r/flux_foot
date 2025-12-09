import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/features/filter/view_model/bloc/filter_bloc.dart';
import 'package:fluxfoot_user/features/filter/views/widgets/action_buttons.dart';
import 'package:fluxfoot_user/features/filter/views/widgets/category_section.dart';
import 'package:fluxfoot_user/features/filter/views/widgets/price_range_section.dart';
import 'package:fluxfoot_user/features/filter/views/widgets/sort_by_section.dart';
import 'package:fluxfoot_user/features/home/view_model/home_bloc/home_bloc.dart';
import 'package:fluxfoot_user/features/home/views/widgets/perticularbrand_tabar_widget.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  static void show(BuildContext context) {
    final HomeState homeState = context.read<HomeBloc>().state;

    double globalMinPrice = 0.0;
    double globalMaxPrice = 5000.0;

    if (homeState is HomeDataLoaded && homeState.products.isNotEmpty) {
      globalMaxPrice = 
        homeState.products
            .reduce((a, b) => (a.salePrice) > (b.salePrice) ? a : b)
            .salePrice
      ;

      globalMinPrice = homeState.products
          .reduce((a, b) => (a.salePrice) < (b.salePrice) ? a : b)
          .salePrice;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(
        create: (context) =>
            FilterBloc(globalMin: globalMinPrice, globalMax: globalMaxPrice),
        child: const FilterBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LiquidGlassLayer(
      settings: iosGlassSettings,
      child: LiquidGlass(
        shape: LiquidRoundedSuperellipse(borderRadius: 15),
        child: GlassGlow(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              color: Colors.black38,
            ),
            child: Column(
              children: [
                //! Handle
                Container(
                  height: 20,
                  alignment: Alignment.center,
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[700] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                //! App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 48),
                      Expanded(
                        child: Text(
                          'Filters & Sort',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textWite,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close, color: AppColors.iconWhite),
                      ),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 100),
                    children: const [
                      SortBySection(),
                      CategorySection(),
                      PriceRangeSection(),
                    ],
                  ),
                ),
                //! Action Buttons
                const ActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
