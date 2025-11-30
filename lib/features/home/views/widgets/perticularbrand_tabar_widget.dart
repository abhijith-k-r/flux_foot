import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';

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
      labelColor: AppColors.textWite,
      unselectedLabelColor: AppColors.textBlack,
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: Colors.transparent,
      tabs: [
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customText(size * 0.04, 'Category', fontWeight: FontWeight.w600),
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
              customText(size * 0.04, 'Products', fontWeight: FontWeight.w600),
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
