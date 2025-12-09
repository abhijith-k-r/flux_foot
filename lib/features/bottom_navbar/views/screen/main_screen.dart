import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/features/account/views/screens/account_screen.dart';
import 'package:fluxfoot_user/features/bottom_navbar/view_model/bloc/navigation_bloc.dart';
import 'package:fluxfoot_user/features/bottom_navbar/views/widgets/custom_bottom_nav_bar.dart';
import 'package:fluxfoot_user/features/cart/views/screen/carts_views.dart';
import 'package:fluxfoot_user/features/home/views/screens/home_screen.dart';
import 'package:fluxfoot_user/features/wishlists/views/screens/favorite_view.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationBloc(),
      child: Builder(
        builder: (context) {
          final navigationBloc = context.read<NavigationBloc>();

          return Scaffold(
            body: PageView(
              controller: navigationBloc.pageController,
              onPageChanged: (index) {
                navigationBloc.add(NavigationTabChanged(index));
              },
              children: const [
                HomeScreen(),
                CartsViews(),
                Favourites(),
                AccountScreen(),
              ],
            ),
            bottomNavigationBar: const CustomBottomNavBar(),
          );
        },
      ),
    );
  }
}
