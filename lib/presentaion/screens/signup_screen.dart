import 'package:flutter/material.dart';
import 'package:fluxfoot_user/presentaion/screens/home_screen.dart';
import 'package:fluxfoot_user/presentaion/screens/login_screen.dart';
import 'package:fluxfoot_user/presentaion/screens/login_signup_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      appBar: CustomAppBar(leading: customBackButton(context)),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.04,
          vertical: height * 0.02,
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  height - kToolbarHeight - MediaQuery.of(context).padding.top,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  SizedBox(height: height * 0.03),
                  Text(
                    'Sign Up',
                    style: GoogleFonts.openSans(
                      fontSize: width * 0.09,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Text(
                    "Please Register your account",
                    style: GoogleFonts.openSans(
                      fontSize: width * 0.048,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: height * 0.04),
                  CustomTextFormField(
                    label: 'Full Name',
                    hintText: 'Enter Name...',
                    prefIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 13, 0, 0),
                      child: FaIcon(FontAwesomeIcons.user, size: 20),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  CustomTextFormField(
                    label: 'E-mail Address',
                    hintText: 'Enter Email...',
                    prefIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 13, 0, 0),
                      child: FaIcon(FontAwesomeIcons.envelope, size: 20),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  CustomTextFormField(
                    label: 'Password',
                    prefIcon: Icon(Icons.lock_outline_rounded),
                    hintText: 'create Password...',
                    sufIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.remove_red_eye_rounded),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  CustomTextFormField(
                    label: 'Password',
                    prefIcon: Icon(Icons.lock_outline_rounded),
                    hintText: 'confirm Password...',
                    sufIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.remove_red_eye_rounded),
                    ),
                  ),
                  SizedBox(height: height * 0.01),

                  SizedBox(height: height * 0.03),
                  CustomButton(ontap: () {}, text: 'Login'),
                  SizedBox(height: height * 0.02),
                  AuthCheckBox(
                    mainAxis: MainAxisAlignment.center,
                    prefText: 'Already have an account?.',
                    sufWidget: TextButton(
                      onPressed: () {
                        fadePush(context, HomeScreen());
                      },
                      child: Text(
                        'Login',
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF8C00),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.02),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
