import 'package:flutter/material.dart';
import 'package:fluxfoot_user/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:fluxfoot_user/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginSignUpScreen extends StatelessWidget {
  const LoginSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'Flux_Foot/assets/images/splash/logo.png',
                    width: 90,
                    height: 60,
                  ),
                  Text('FLUXFOOT', style: GoogleFonts.rozhaOne(fontSize: 20)),
                ],
              ),
            ),

            Center(
              child: Column(
                children: [
                  CustomButton(
                    ontap: () {
                      fadePush(context, SignInScreen());
                    },
                    text: 'Login',
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    ontap: () {
                      fadePush(context, SignUpScreen());
                    },
                    text: 'Sign up',
                  ),
                  SizedBox(height: 20),
                  dividerOr(),
                  SizedBox(height: 20),
                  GoogleAuth(ontap: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
          color: Colors.white,
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

dividerOr() {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: Row(
      children: [
        Expanded(child: Divider(thickness: 1, color: Colors.black)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('or', style: TextStyle(fontSize: 20)),
        ),
        Expanded(child: Divider(thickness: 1, color: Colors.black)),
      ],
    ),
  );
}

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

// ! Fade Push
void fadePush(BuildContext context, Widget page) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  );
}

// ! Fade Push ReplaceMent
void fadePUshReplaceMent(BuildContext context, Widget page) {
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  );
}

// ! Fade push And RemoveUntil
void fadePushAndRemoveUntil(BuildContext context, Widget page) {
  Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
    (Route<dynamic> route) => false,
  );
}
