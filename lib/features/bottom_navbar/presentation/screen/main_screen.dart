import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/features/bottom_navbar/presentation/bloc/navigation_bloc.dart';
import 'package:fluxfoot_user/features/bottom_navbar/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:fluxfoot_user/features/home/presentation/screens/home_screen.dart';

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
                Center(child: Text('Safety Screen')),
                Center(child: Text('Cabin Screen')),
              ],
            ),
            bottomNavigationBar: const CustomBottomNavBar(),
          );
        },
      ),
    );
  }
}
