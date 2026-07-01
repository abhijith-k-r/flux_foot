// ignore_for_file: deprecated_member_use


import 'package:flutter/material.dart';

import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_backbutton.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/home/views/widgets/perticularbrand_tabar_widget.dart';
import 'package:fluxfoot_user/features/order/views/widgets/myorders_orders_list.dart';

class MyOrders extends StatelessWidget {
  const MyOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: CustomAppBar(
          leading: customBackButton(context),
          title: Center(
            child: customText(
              size.width * 0.065,                                  
              'My Orders',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.04,
            vertical: size.width * 0.02,
          ),
          child: Column(
            children: [
              // Custom Tab Bar
              buildCustomTabBar(
                context,
                size.width,
                title1: 'Ongoing',
                title2: 'Completed',
              ),
              const SizedBox(height: 16),

              // THE TAB BAR VIEW THAT ACTUALLY SHOWS DATA
              Expanded(
                child: TabBarView(
                  children: [
                    // Tab 1: Ongoing
                    buildOrderList(context, isOngoing: true),
                    // Tab 2: Completed
                    buildOrderList(context, isOngoing: false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
