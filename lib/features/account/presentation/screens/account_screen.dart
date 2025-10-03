import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluxfoot_user/features/account/presentation/screens/profile_screen.dart';
import 'package:fluxfoot_user/features/auth/presentation/screens/login_screen.dart';
import 'package:fluxfoot_user/features/auth/presentation/screens/login_signup_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'Account',
          style: GoogleFonts.rozhaOne(
            fontWeight: FontWeight.w500,
            fontSize: size * 0.08,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: size * 0.03,
        children: [
          UserProfileImage(size: size, radius: size * 0.2).fadeInDownBig(),
          SizedBox(height: size * 0.1),
          AccountContent(
            size: size,
            icon: Icons.person_outline_rounded,
            title: 'Personal Information',
            subtitle: 'Updat your details',
            ontap: () {
              fadePush(context, ProfileScreen());
            },
          ).fadeInRight(from: 50),
          AccountContent(
            size: size,
            icon: Icons.location_on_outlined,
            title: 'Shipping Addresses',
            subtitle: 'check Addresses',
            // ontap: ()=> fadePush(context, profilesc),
          ).fadeInRightBig(from: 100),
          AccountContent(
            size: size,
            icon: Icons.card_giftcard,
            title: 'Order History',
            subtitle: 'view all purchases',
            // ontap: ()=> fadePush(context, profilesc),
          ).fadeInRight(from: 150),
          AccountContent(
            size: size,
            icon: Icons.settings,
            title: 'Settings',
            subtitle: 'further details',
            // ontap: ()=> fadePush(context, profilesc),
          ).fadeInRightBig(from: 200),
        ],
      ),
    );
  }
}

// ! Circle Avatar For Use Profile
class UserProfileImage extends StatelessWidget {
  const UserProfileImage({super.key, required this.size, this.radius});

  final double size;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.orange),
        ),
        child: CircleAvatar(
          radius: radius,
          backgroundColor: Colors.white,
          child: Icon(
            CupertinoIcons.person,
            size: size * 0.15,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class AccountContent extends StatelessWidget {
  const AccountContent({
    super.key,
    required this.size,
    required this.title,
    required this.subtitle,
    this.ontap,
    // this.leading,
    required this.icon,
  });

  final double size;
  final String title;
  final String subtitle;
  final Function()? ontap;
  // final Widget? leading;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: size * 0.04, right: size * 0.04),
      child: ListTile(
        selectedColor: Colors.amber,
        leading: Icon(icon, size: size * 0.1, color: Colors.orangeAccent),
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
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Colors.orange),
        ),
      ),
    );
  }
}
