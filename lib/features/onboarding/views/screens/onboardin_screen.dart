// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluxfoot_user/features/onboarding/view_model/onboarding_service.dart';
import 'package:fluxfoot_user/core/routing/navigator.dart';
import 'package:fluxfoot_user/features/auth/views/screens/sign_in_screen.dart';

class OnboardinScreen extends StatelessWidget {
  const OnboardinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            _completeOnboarding(context);
          },
          child: Text('Next'),
        ),
      ),
    );
  }

  void _completeOnboarding(BuildContext context) async {
    await OnboardingService().completeOnboarding();
    fadePUshReplaceMent(context, SignInScreen());
  }
}
