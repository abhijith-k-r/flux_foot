import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/features/filter/view_model/bloc/filter_bloc.dart';
import 'package:fluxfoot_user/features/filter/views/screens/filter_bottomsheet.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSearchBarWithFilter extends StatelessWidget {
  const CustomSearchBarWithFilter({
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
        LiquidGlassLayer(
          child: Row(
            spacing: width * 0.03,
            children: [
              LiquidGlass(
                shape: LiquidRoundedSuperellipse(borderRadius: 15),
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
                            onChanged: (value) {
                              context.read<FilterBloc>().add(
                                UpdateSearchQuery(value),
                              );
                            },
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

                        //! QR Scanner Button with Interactive Glow
                        LiquidGlass(
                          shape: LiquidRoundedSuperellipse(borderRadius: 5),
                          child: GlassGlow(
                            glowColor: Colors.white24,
                            glowRadius: 1.0,
                            child: SizedBox(
                              width: width * 0.1,
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
                ),
              ),

              //! Filter Section
              LiquidGlass(
                shape: LiquidRoundedSuperellipse(borderRadius: 15),
                child: GlassGlow(
                  glowColor: Colors.white24,
                  glowRadius: 1.0,
                  child: SizedBox(
                    width: width * 0.099,
                    height: height * 0.099,
                    child: IconButton(
                      onPressed: () {
                        FilterBottomSheet.show(context);
                      },
                      icon: Icon(
                        CupertinoIcons.slider_horizontal_3,
                        color: AppColors.iconBlack,
                        size: 20,
                      ),
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
