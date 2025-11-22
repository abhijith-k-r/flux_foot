import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customText(
  double size ,
  String text, {
  FontWeight? fontWeight,
  Color? appColor,
  TextDecoration? textDecoration,
  TextOverflow? overflow,
  int? maxLines,
  TextStyle? style,
}) {
  return Text(
    text,
    style:
        style ??
        GoogleFonts.openSans(
          color: appColor ?? AppColors.textBlack,
          fontSize: size ,
          fontWeight: fontWeight,
          decoration: textDecoration,
        ),
    overflow: overflow ?? TextOverflow.ellipsis,
  );
}
