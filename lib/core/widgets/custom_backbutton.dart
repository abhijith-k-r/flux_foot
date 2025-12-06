// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/routing/navigator.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

// ! Custom Back Button
Padding customBackButton(BuildContext context) {
  final size = MediaQuery.of(context).size.width;
  return Padding(
    padding: EdgeInsets.all(size * 0.027),
    child: GestureDetector(
      onTap: () => Navigator.pop(context),
      child: LiquidGlassLayer(
        child: LiquidGlass(
          shape: LiquidRoundedSuperellipse(borderRadius: 10),
          child: GlassGlow(
            child: SizedBox(
              child: Container(
                decoration: BoxDecoration(
                  // color: AppColors.bgWhite,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.arrow_back_ios_new, color: AppColors.bgGrey),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}


// ! Custom Forword Button
Padding customForwordButton(BuildContext context, Widget page, {Color? color}) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: GestureDetector(
      onTap: () {
        fadePush(context, page);
      },
      child: SizedBox(
        width: 40,
        height: 40,
        child: Container(
          decoration: BoxDecoration(
            color: color ?? AppColors.bgWhite,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.arrow_forward_ios),
        ),
      ),
    ),
  );
}

