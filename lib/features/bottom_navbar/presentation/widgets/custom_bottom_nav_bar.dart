import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import '../bloc/navigation_bloc.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({Key? key}) : super(key: key);

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
              title: const Text('Abc'),
              backgroundColor: Colors.red,
              selectedIcon: const Icon(Icons.read_more),
            ),
            BottomBarItem(
              icon: const Icon(Icons.safety_divider),
              title: const Text('Safety'),
              backgroundColor: Colors.orange,
            ),
            BottomBarItem(
              icon: const Icon(Icons.cabin),
              title: const Text('Cabin'),
              backgroundColor: Colors.purple,
            ),
          ],
          fabLocation: StylishBarFabLocation.end,
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
