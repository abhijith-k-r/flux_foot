// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/filter/view_model/bloc/filter_bloc.dart';
import 'package:fluxfoot_user/features/home/view_model/home_bloc/home_bloc.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    // final isDark = Theme.of(context).brightness == Brightness.dark;
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
          // ! Reset Custom Button
          Expanded(
            child: InkWell(
              onTap: () {
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
              splashColor: AppColors.bgWhite.withOpacity(0.5),
              highlightColor: AppColors.bgWhite.withOpacity(0.2),
              child: LiquidGlassLayer(
                child: LiquidGlass(
                  shape: LiquidRoundedSuperellipse(borderRadius: 10),
                  child: GlassGlow(
                    child: Container(
                      foregroundDecoration: BoxDecoration(
                        color: AppColors.bgWhite.withOpacity(0.3),
                      ),
                      height: size * 0.13,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.bgWhite),
                      ),

                      child: Center(
                        child: customText(
                          size * 0.04,
                          'Apply Filters',
                          appColor: AppColors.textWite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // ! Apply Filter Button
          Expanded(
            child: InkWell(
              onTap: () async {
                final currentFilterState = filterBloc.state;
                homeBloc.add(FilterProducts(currentFilterState));
                await Future.delayed(Duration(seconds: 1));
                Navigator.pop(context);
              },
              splashColor: AppColors.outLineOrang.withOpacity(0.5),
              highlightColor: AppColors.outLineOrang.withOpacity(0.2),
              child: LiquidGlassLayer(
                child: LiquidGlass(
                  shape: LiquidRoundedSuperellipse(borderRadius: 10),
                  child: GlassGlow(
                    child: Container(
                      foregroundDecoration: BoxDecoration(
                        color: AppColors.bgOrangeAccent.withOpacity(0.3),
                      ),
                      height: size * 0.13,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.outLineOrang),
                      ),

                      child: Center(
                        child: customText(
                          size * 0.04,
                          'Apply Filters',
                          appColor: AppColors.textWite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
