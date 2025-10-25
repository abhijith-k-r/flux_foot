import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

// ! Custom Button
class CustomButton extends StatelessWidget {
  final VoidCallback? ontap;
  final double width;
  final double heith;
  final double borderRadius;
  final Color backColor;
  final String text;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final Widget? widget;
  final bool showTextAndWidget;
  final double spacing;
  const CustomButton({
    super.key,
    required this.ontap,
    this.width = 360,
    this.heith = 50,
    this.borderRadius = 15,
    this.backColor = Colors.black,
    this.text = 'Button',
    this.textColor = Colors.white,
    this.fontSize = 25,
    this.fontWeight = FontWeight.w600,
    this.widget,
    this.showTextAndWidget = false,
    this.spacing = 10,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        width: width,
        height: heith,
        decoration: BoxDecoration(
          color: backColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: showTextAndWidget
              ? Row(
                  spacing: spacing,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget != null) ?widget,
                    Text(
                      text,
                      style: GoogleFonts.openSans(
                        color: textColor,
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                      ),
                    ),
                  ],
                )
              : widget ??
                    Text(
                      text,
                      style: GoogleFonts.openSans(
                        color: textColor,
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                      ),
                    ),
        ),
      ),
    );
  }
}


// ! Google User Sign In Button
class GoogleAuth extends StatelessWidget {
  final VoidCallback? ontap;
  const GoogleAuth({super.key, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        width: 360,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.bgWhite,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 50,
          children: [
            Image.asset(
              'Flux_Foot/assets/images/icons/google_Icon.png',
              height: 40,
              width: 40,
            ),

            Text(
              'Signup  with Google',
              style: GoogleFonts.openSans(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
