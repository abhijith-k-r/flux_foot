import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_backbutton.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/home/views/widgets/perticularbrand_tabar_widget.dart';

class MyOrders extends StatelessWidget {
  const MyOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: CustomAppBar(
          leading: customBackButton(context),
          title: Center(
            child: customText(
              size * 0.065,
              'My Orders',
              fontWeight: FontWeight.w600,
            ),
          ),
          action: [
            IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.bell)),
            SizedBox(width: size * 0.01),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size * 0.04,
            vertical: size * 0.02,
          ),
          child: Column(
            children: [
              // ! Custom Tab Bar (Category & Products)
              buildCustomTabBar(
                context,
                size,
                title1: 'Ongoing',
                title2: 'Completed',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
