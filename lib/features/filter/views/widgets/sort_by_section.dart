// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/features/filter/view_model/bloc/filter_bloc.dart';
import 'package:fluxfoot_user/features/filter/views/widgets/sort_option.dart';

class SortBySection extends StatelessWidget {
  const SortBySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Sort By',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textWite,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocBuilder<FilterBloc, FilterState>(
            builder: (context, state) {
              return Column(
                children: [
                  SortOptionHelper(
                    title: 'Newest First',
                    value: SortOption.newestFirst,
                    groupValue: state.selectedSort,
                  ),
                  const SizedBox(height: 12),
                  SortOptionHelper(
                    title: 'Price: Low to High',
                    value: SortOption.priceLowToHigh,
                    groupValue: state.selectedSort,
                  ),
                  const SizedBox(height: 12),
                  SortOptionHelper(
                    title: 'Price: High to Low',
                    value: SortOption.priceHighToLow,
                    groupValue: state.selectedSort,
                  ),
                  const SizedBox(height: 12),
                  SortOptionHelper(
                    title: 'Popularity',
                    value: SortOption.popularity,
                    groupValue: state.selectedSort,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}


