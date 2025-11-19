// // ! Custom Search BAr
// import 'package:flutter/material.dart';
// import 'package:fluxfoot_user/core/constants/app_colors.dart';
// import 'package:google_fonts/google_fonts.dart';

// class CustomSearchBar extends StatelessWidget {
//   const CustomSearchBar({super.key, required this.width, required this.height});

//   final double width;
//   final double height;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       spacing: width * 0.03,
//       children: [
//         Container(
//           width: width * 0.79,
//           height: height * 0.099,
//           decoration: BoxDecoration(
//             color: AppColors.bgWhite,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: TextFormField(
//             decoration: InputDecoration(
//               border: InputBorder.none,
//               prefixIcon: Icon(Icons.search),
//               hintText: 'Search...',
//               hintStyle: GoogleFonts.openSans(),
//             ),
//           ),
//         ),

//         Container(
//           width: width * 0.099,
//           height: height * 0.099,
//           decoration: BoxDecoration(
//             color: AppColors.bgWhite,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: IconButton(
//             onPressed: () {},
//             icon: Icon(Icons.qr_code_scanner_sharp),
//           ),
//         ),
//       ],
//     );
//   }
// }

// ignore_for_file: depend_on_referenced_packages

// ! ============()=============
// ============================================
// OPTION 1: Using liquid_glass_renderer (Most Advanced)
// ============================================
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:google_fonts/google_fonts.dart';


class CustomSearchBarAdvanced extends StatelessWidget {
  const CustomSearchBarAdvanced({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Your background content (image, gradient, etc.)
        // The glass needs something behind it to blur
        
        // Glass Layer
        LiquidGlassLayer(
          child: Row(
            spacing: width * 0.03,
            children: [
              // Main Search Bar with Interactive Glow
              LiquidGlass(
                shape: LiquidRoundedSuperellipse(
                  borderRadius: 15,
                ),
                child: GlassGlow(
                  glowColor: Colors.white24,
                  glowRadius: 1.0,
                  child: Container(
                    width: width * 0.79,
                    height: height * 0.099,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.black54, size: 22),
                        SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            style: GoogleFonts.openSans(
                              color: Colors.black87,
                              fontSize: 15,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search...',
                              hintStyle: GoogleFonts.openSans(
                                color: Colors.black45,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // QR Scanner Button with Interactive Glow
              LiquidGlass(
                shape: LiquidRoundedSuperellipse(
                  borderRadius: 15,
                ),
                child: GlassGlow(
                  glowColor: Colors.white24,
                  glowRadius: 1.0,
                  child: Container(
                    width: width * 0.099,
                    height: height * 0.099,
                    child: Icon(
                      Icons.qr_code_scanner_sharp,
                      color: Colors.black54,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

