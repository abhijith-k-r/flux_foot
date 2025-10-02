// ignore_for_file: unnecessary_null_comparison, dead_code
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final String? initialValue;
  final Function(String)? onchanged;
  final AutovalidateMode? autovalidateMode;
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
    this.initialValue,
    this.onchanged,
    this.autovalidateMode,
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
          initialValue: initialValue,
          onChanged: onchanged,
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