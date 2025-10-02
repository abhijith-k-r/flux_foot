import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import '../bloc/navigation_bloc.dart';

class CustomBottomNavBar extends StatelessWidget {
   const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return StylishBottomBar(
          option: DotBarOptions(
            dotStyle: DotStyle.tile,
            gradient: const LinearGradient(
              colors: [Colors.deepPurple, Colors.pink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          items: [
            BottomBarItem(
              icon: const Icon(Icons.home_filled),
              title: const Text('Home'),
              backgroundColor: Colors.redAccent,
              selectedIcon: const Icon(Icons.read_more),
            ),
            BottomBarItem(
              icon: const Icon(Icons.shopping_cart_outlined),
              title: const Text('Carts'),
              backgroundColor: Colors.orange,
            ),
            BottomBarItem(
              icon: const Icon(Icons.favorite_border),
              title: const Text('Favorites'),
              backgroundColor: Colors.purple,
            ),

            BottomBarItem(
              icon: const Icon(Icons.person_outline_rounded),
              title: const Text('Account'),
              backgroundColor: Colors.deepOrangeAccent,
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
