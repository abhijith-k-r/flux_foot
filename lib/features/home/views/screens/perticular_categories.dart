import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_backbutton.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/home/views/widgets/show_cart_count.dart';

class PerticularCategories extends StatelessWidget {
  final String title;
  const PerticularCategories({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
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

      
    );
  }
}
