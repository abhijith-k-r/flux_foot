// ! Custom Search BAr
import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key, required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: width * 0.03,
      children: [
        Container(
          width: width * 0.79,
          height: height * 0.099,
          decoration: BoxDecoration(
            color: AppColors.bgWhite,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
              hintText: 'Search...',
              hintStyle: GoogleFonts.openSans(),
            ),
          ),
        ),

        Container(
          width: width * 0.099,
          height: height * 0.099,
          decoration: BoxDecoration(
            color: AppColors.bgWhite,
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.qr_code_scanner_sharp),
          ),
        ),
      ],
    );
  }
}
