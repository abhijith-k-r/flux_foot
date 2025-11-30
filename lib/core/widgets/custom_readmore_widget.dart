// ! Custom READ MORE TEXT
import 'dart:ui';

import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

customReadmoreText(String description) {
  return ReadMoreText(
    description,
    trimLines: 5,
    colorClickableText: AppColors.textBlack,
    trimMode: TrimMode.Line,
    trimCollapsedText: '...Read more',
    trimExpandedText: ' Less',
    style: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w500),
    moreStyle: GoogleFonts.openSans(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: AppColors.textBlack,
    ),
    lessStyle: GoogleFonts.openSans(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: AppColors.textBlack,
    ),
  );
}
