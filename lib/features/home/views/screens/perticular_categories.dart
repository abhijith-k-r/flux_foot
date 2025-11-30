import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_backbutton.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';
import 'package:fluxfoot_user/features/home/views/widgets/perticularcategory_products_widget.dart';
import 'package:fluxfoot_user/features/home/views/widgets/show_cart_count.dart';

// ! Perticular Brand Under Category under Products.
class PerticularCategories extends StatelessWidget {
  final List<ProductModel> brandProducts;
  final String categoryName;
  const PerticularCategories({
    super.key,
    required this.brandProducts,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        leading: customBackButton(context),
        title: Center(
          child: customText(
            size * 0.065,
            categoryName,
            fontWeight: FontWeight.w600,
          ),
        ),
        action: [
          // ! Showing Carted Items Count
          showCartCountBox(size),
          SizedBox(width: size * 0.01),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size * 0.04),
        child: buildCategoryProducts(
          context,
          size,
          brandProducts,
          categoryName,
        ),
      ),
    );
  }
}


