// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/routing/navigator.dart';
import 'package:fluxfoot_user/features/home/views/widgets/perticularbrand_tabar_widget.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

// ! Custom Back Button
Padding customBackButton(BuildContext context) {
  final size = MediaQuery.of(context).size.width;
  return Padding(
    padding: EdgeInsets.all(size * 0.027),
    child: GestureDetector(
      onTap: () => Navigator.pop(context),
      child: LiquidGlassLayer(
        settings: iosGlassSettings,
        child: LiquidGlass(
          shape: LiquidRoundedSuperellipse(borderRadius: 10),
          child: GlassGlow(
            child: SizedBox(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(CupertinoIcons.back),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

// ! Custom Forword Button
customForwordButton(BuildContext context, Widget page, {Color? color}) {
  return IconButton(
    onPressed: () {
      fadePush(context, page);
    },
    icon: Icon(CupertinoIcons.forward),
  );
}
