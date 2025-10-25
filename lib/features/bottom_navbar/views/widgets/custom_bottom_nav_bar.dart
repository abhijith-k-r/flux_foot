import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import '../../view_model/bloc/navigation_bloc.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return StylishBottomBar(
          option: DotBarOptions(
            dotStyle: DotStyle.tile,
            gradient: LinearGradient(
              colors: [AppColors. btnDeepPurple, AppColors. btnPink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          items: [
            BottomBarItem(
              icon: const Icon(Icons.home_filled),
              title: const Text('Home'),
              backgroundColor: AppColors. iconRedAccent,
              selectedIcon: const Icon(Icons.read_more),
            ),
            BottomBarItem(
              icon: const Icon(Icons.shopping_cart_outlined),
              title: const Text('Carts'),
              backgroundColor: AppColors. iconOrangeAccent,
            ),
            BottomBarItem(
              icon: const Icon(Icons.favorite_border),
              title: const Text('Favorites'),
              backgroundColor: AppColors. iconPurple,
            ),

            BottomBarItem(
              icon: const Icon(Icons.person_outline_rounded),
              title: const Text('Account'),
              backgroundColor: AppColors. iconOrange,
            ),
          ],
          hasNotch: true,
          currentIndex: state.selectedIndex,
          onTap: (index) {
            context.read<NavigationBloc>().add(NavigationTabChanged(index));
          },
        );
      },
    );
  }
}
