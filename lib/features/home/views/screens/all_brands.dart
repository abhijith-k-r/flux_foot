// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_backbutton.dart';
import 'package:fluxfoot_user/core/widgets/custom_searchbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/home/view_model/home_bloc/home_bloc.dart';
import 'package:fluxfoot_user/features/home/views/widgets/all_brands_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class AllBrands extends StatelessWidget {
  const AllBrands({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        leading: customBackButton(context),
        title: customText(
          25,
          'All Brands',
          style: GoogleFonts.rozhaOne(fontSize: 28),
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size * 0.04,
          vertical: size * 0.02,
        ),
        child: SingleChildScrollView(
          child: BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (previous, current) {
              return previous != current;
            },
            builder: (context, state) {
              if (state is HomeLoading || state is HomeInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is HomeError) {
                return Center(child: Text('Error: ${state.message}'));
              }

              if (state is HomeDataLoaded) {
                final brands = state.brands;
                final allProducts = state.products;

                if (brands.isEmpty) {
                  return Center(
                    child: customText(16, 'No active brands available.'),
                  );
                }
                // ! Counting Each BrandProducts Count.
                final Map<String, int> brandProductCounts = {};
                for (final brand in brands) {
                  final count = allProducts
                      .where((product) => product.brand == brand.name)
                      .length;
                  brandProductCounts[brand.name] = count;
                }

                final sortedBrands = [...brands];
                // ! Sorting Compare with brand Name
                sortedBrands.sort(
                  (a, b) => brandProductCounts[b.name]!.compareTo(
                    brandProductCounts[a.name]!,
                  ),
                );

                return Column(
                  children: [
                    // ! Custom SearchBar
                    CustomSearchBar(width: size, height: size * 1.3),
                    // ! Show All Brands as Gridview
                    buildAllBrands(sortedBrands, brandProductCounts, size),
                  ],
                );
              }
              return SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
