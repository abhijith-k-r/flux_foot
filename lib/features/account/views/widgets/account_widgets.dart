import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

// ! Circle Avatar For Use Profile
class UserProfileImage extends StatelessWidget {
  const UserProfileImage({
    super.key,
    required this.size,
    this.radius,
    this.data,
  });

  final double size;
  final double? radius;
  final Map<String, dynamic>? data;

  @override
  Widget build(BuildContext context) {
    final ImageProvider? bgImage =
        (data != null &&
            data!['imageUrl'] != null &&
            (data!['imageUrl'] as String).isNotEmpty)
        ? NetworkImage(data!['imageUrl'] as String)
        : null;
    return Center(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.outLineOrang),
        ),
        child: CircleAvatar(
          radius: radius,
          backgroundColor: AppColors.bgWhite,

          child: bgImage == null
              ? Icon(
                  CupertinoIcons.person,
                  size: size * 0.15,
                  color: AppColors.iconBlack,
                )
              : null,
        ),
      ),
    );
  }
}

// ! Account Details List Tile
class AccountContent extends StatelessWidget {
  const AccountContent({
    super.key,
    required this.size,
    required this.title,
    required this.subtitle,
    this.ontap,
    required this.icon,
  });

  final double size;
  final String title;
  final String subtitle;
  final Function()? ontap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: size * 0.04, right: size * 0.04),
      child: ListTile(
        leading: Icon(
          icon,
          size: size * 0.1,
          color: AppColors.iconOrangeAccent,
        ),
        title: Text(
          title,
          style: GoogleFonts.openSans(
            fontWeight: FontWeight.w600,
            fontSize: size * 0.045,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(subtitle, style: GoogleFonts.openSans()),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: ontap,
        tileColor: AppColors.bgWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: AppColors.outLineOrang),
        ),
      ),
    );
  }
}
