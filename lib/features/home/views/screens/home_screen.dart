// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_searchbar.dart';
import 'package:fluxfoot_user/features/filter/view_model/bloc/filter_bloc.dart';
import 'package:fluxfoot_user/features/home/views/widgets/homescreen_content_widget.dart';
import 'package:fluxfoot_user/features/home/views/widgets/homescreen_search_result_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: size * 0.01),
          child: SizedBox(
            width: 70,
            height: 60,
            child: ShakeX(
              delay: const Duration(milliseconds: 900),
              duration: const Duration(milliseconds: 900),
              child: Image.asset(
                'Flux_Foot/assets/images/splash/logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        action: [
          IconButton(
            onPressed: () {},
            icon: const FaIcon(FontAwesomeIcons.bell),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size * 0.04,
          vertical: size * 0.02,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ! Custom Search Bar - This updates the FilterBloc
              CustomSearchBar(width: size, height: size * 1.2),
              SizedBox(height: size * 0.05),

              // ! BlocBuilder to switch between Home and Search Results
              BlocBuilder<FilterBloc, FilterState>(
                builder: (context, filterState) {
                  final query = filterState.searchQuery.trim().toLowerCase();

                  if (query.isNotEmpty) {
                    // !1. SHOW SEARCH RESULTS
                    return buildSearchResults(context, size, query);
                  } else {
                    // !2. SHOW NORMAL HOME CONTENT
                    return buildHomeContent(context, size);
                  }
                },
              ),
              SizedBox(height: size * 0.04),
            ],
          ),
        ),
      ),
    );
  }  

 

 
}



