// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';

class TransparentBackgroundScreen extends StatelessWidget {
  final String imageUrl;
  const TransparentBackgroundScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5.0,
              sigmaY: 5.0,
            ), // Adjust blur strength here
            child: Container(color: AppColors.bgBlack.withOpacity(0.3)),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.black45,
          // AppColors.t,
          body: Stack(
            children: [
              InteractiveViewer(
                minScale: 0.5,
                maxScale: 5.0,
                constrained: false,
                boundaryMargin: const EdgeInsets.all(double.infinity),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Image.network(
                      imageUrl,
                      height: 300,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                            child: Icon(Icons.broken_image,
                                color: Colors.white, size: 50),
                          ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 25,
                top: 45,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(CupertinoIcons.xmark, color: AppColors.iconWhite),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ! Helper Funcrion to navigat
void navigateToTransparentScreen(BuildContext context, String imageUrl) {
  Navigator.push(
    context,
    PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, animation, secondaryAnimation) {
        return TransparentBackgroundScreen(imageUrl: imageUrl);
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  );
}
