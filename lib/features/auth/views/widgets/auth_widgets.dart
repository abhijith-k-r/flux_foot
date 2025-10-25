
import 'package:flutter/material.dart';

// ! Auth Check Box Like Row 
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




