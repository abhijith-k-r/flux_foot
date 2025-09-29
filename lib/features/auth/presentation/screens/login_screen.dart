// ignore_for_file: unnecessary_null_comparison, dead_code
import 'package:flutter/material.dart';
import 'package:fluxfoot_user/features/auth/presentation/screens/login_signup_screen.dart';
import 'package:fluxfoot_user/features/auth/presentation/widgets/form_validators.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                    'Login',
                    style: GoogleFonts.openSans(
                      fontSize: width * 0.09,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Text(
                    'Please login to your account',
                    style: GoogleFonts.openSans(
                      fontSize: width * 0.048,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: height * 0.04),
                  CustomTextFormField(
                    label: 'E-mail Address',
                    hintText: 'Enter Email...',
                    validator: FormValidators.validateEmail,
                    prefIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 13, 0, 0),
                      child: FaIcon(FontAwesomeIcons.envelope, size: 20),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  CustomTextFormField(
                    label: 'Password',
                    prefIcon: Icon(Icons.lock_outline_rounded),
                    hintText: 'Enter Password...',
                    validator: FormValidators.validatePassword,
                    sufIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.remove_red_eye_rounded),
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  AuthCheckBox(
                    mainAxis: MainAxisAlignment.spaceBetween,
                    checkBox: Checkbox(
                      activeColor: Color(0xFFFF8C00),
                      value: true,
                      onChanged: (value) {},
                    ),
                    prefText: 'Remember me',
                    sufWidget: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot password?',
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  CustomButton(ontap: () {}, text: 'Login'),
                  SizedBox(height: height * 0.02),
                  dividerOr(),
                  SizedBox(height: height * 0.02),
                  GoogleAuth(ontap: () {}),
                  SizedBox(height: height * 0.03),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthCheckBox extends StatelessWidget {
  final MainAxisAlignment mainAxis;
  final Widget? checkBox;
  final String prefText;
  final TextButton? sufWidget;
  final TextStyle? style;

  const AuthCheckBox({
    super.key,
    required this.mainAxis,
    this.checkBox,
    required this.prefText,
    this.sufWidget,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxis,
      children: [
        Row(
          children: [
            if (checkBox != null) checkBox!,
            Text(prefText, style: style),
          ],
        ),
        sufWidget!,
      ],
    );
  }
}

// ! Custom Text Form Field

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String hintText;
  final Widget? prefIcon;
  final Widget? sufIcon;
  final double borderRadius;
  final TextEditingController? controller;
  final bool obscureText;
  final Function validator;

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.hintText,
    this.prefIcon,
    this.sufIcon,
    this.borderRadius = 15,
    this.controller,
    this.obscureText = false,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.openSans()),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscureText,

          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(color: Colors.black),
            ),
            prefixIcon: prefIcon,
            hintText: hintText,
            hintStyle: GoogleFonts.openSans(),
            suffixIcon: sufIcon,
          ),
        ),
      ],
    );
  }
}

// ! Custom App_Bar

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget leading;
  final Widget title;
  final List<Widget> action;
  const CustomAppBar({
    super.key,
    this.leading = const SizedBox.shrink(),
    this.title = const SizedBox(),
    this.action = const [],
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFFE0E0E0),
      leading: leading,
      title: title,
      actions: action,
    );
  }
}

// ! Custom Back Button

Padding customBackButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: GestureDetector(
      onTap: () => Navigator.pop(context),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.arrow_back_ios_new),
        ),
      ),
    ),
  );
}
