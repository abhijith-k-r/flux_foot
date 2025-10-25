import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customText(
  double size,
  String text, {
  FontWeight? fontWeight,
  Color? appColor,
  TextDecoration? textDecoration,
}) {

  return Text(
    text,
    style: GoogleFonts.openSans(
      color: appColor ?? AppColors.textBlack,
      fontSize: size,
      fontWeight: fontWeight,
      decoration: textDecoration,
    ),
    overflow: TextOverflow.ellipsis,
  );
}
