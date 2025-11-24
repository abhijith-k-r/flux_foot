// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/features/filter/view_model/bloc/filter_bloc.dart';

class SortOptionHelper extends StatelessWidget {
  final String title;
  final SortOption value;
  final SortOption groupValue;

  const SortOptionHelper({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => context.read<FilterBloc>().add(ChangeSortOption(value)),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? AppColors.outLineOrang
                : (isDark ? Colors.grey[700]! : Colors.grey[200]!),
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? AppColors.outLineOrang.withOpacity(0.2)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.activeOrange
                      : (isDark ? Colors.grey[600]! : Colors.grey[300]!),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.activeOrange,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
