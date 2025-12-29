import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/widgets/shimmer_widgets.dart';
import 'package:fluxfoot_user/features/home/views/widgets/perticularbrand_tabar_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

// ! Circle Avatar For Use Profile
class UserProfileImage extends StatelessWidget {
  const UserProfileImage({
    super.key,
    required this.size,
    this.radius,
    this.imageUrl,
  });

  final double size;
  final double? radius;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.outLineOrang),
        ),
        child: LiquidGlassLayer(
          settings: iosGlassSettings,
          child: LiquidGlass(
            shape: LiquidRoundedSuperellipse(borderRadius: radius!),
            child: GlassGlow(
              child: SizedBox(
                width: radius! * 2,
                height: radius! * 2,
                child: ClipOval(
                  child: (imageUrl != null && imageUrl!.isNotEmpty)
                      ? Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: ShimmerWrapper(
                                child: CircleAvatar(radius: radius! * 2),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              CupertinoIcons.person,
                              size: size * 0.15,
                              color: AppColors.iconBlack,
                            );
                          },
                        )
                      : Icon(
                          CupertinoIcons.person,
                          size: size * 0.15,
                          color: AppColors.iconBlack,
                        ),
                ),
              ),
            ),
          ),
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
