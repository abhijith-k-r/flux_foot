// ignore_for_file: use_build_context_synchronously


import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/features/onboarding/view_model/onboarding_service.dart';
import 'package:fluxfoot_user/core/routing/navigator.dart';
import 'package:fluxfoot_user/features/auth/views/screens/sign_in_screen.dart';

class OnboardinScreen extends StatelessWidget {
  const OnboardinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentGeometry.bottomEnd,
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'Flux_Foot/assets/images/splash/onboard.png',
              fit: BoxFit.cover,
            ),
          ),
          InkWell(
            onDoubleTap: () {
              _completeOnboarding(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(
                left: 200,
                top: 830,
                right: 20,
                bottom: 5,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.bgRed,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.bgWhite,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_forward,
                            color: AppColors.bgRed,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Get Started',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textWite,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
         
        ],
      ),
    );
  }

  void _completeOnboarding(BuildContext context) async {
    await OnboardingService().completeOnboarding();
    fadePUshReplaceMent(context, SignInScreen());
  }
}
