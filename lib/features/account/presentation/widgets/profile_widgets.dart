// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

// ! User Name
class ProfileName extends StatelessWidget {
  const ProfileName({super.key, required this.size, required this.name});

  final double size;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Hey, $name',
      style: GoogleFonts.openSans(
        fontWeight: FontWeight.bold,
        fontSize: size * 0.055,
      ),
    );
  }
}

// ! User Details Showing List Tile
class ProfileDetails extends StatelessWidget {
  const ProfileDetails({
    super.key,
    required this.size,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final double size;
  final String title;
  final String subtitle;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: size * 0.03, right: size * 0.03),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors. bgWhite,
        ),
        child: ListTile(
          title: Row(
            spacing: size * 0.02,
            children: [
              Text(
                title,

                style: GoogleFonts.rozhaOne(
                  fontSize: size * 0.045,
                  color: AppColors. textGrey,
                  letterSpacing: 3,
                  wordSpacing: 10,
                ),
              ),
              icon,
            ],
          ),
          subtitle: Text(
            subtitle,
            style: GoogleFonts.openSans(
              fontSize: size * 0.05,
              color: AppColors. textBlack,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}


