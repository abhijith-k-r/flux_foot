import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/auth/onboardin_screen.dart';
import 'package:fluxfoot_user/core/auth/onboarding_service.dart';
import 'package:fluxfoot_user/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fluxfoot_user/features/auth/presentation/screens/login_screen.dart';
import 'package:fluxfoot_user/features/auth/presentation/screens/splash_screen.dart';
import 'package:fluxfoot_user/features/bottom_navbar/presentation/screen/main_screen.dart';

class AuthWrapper extends StatelessWidget {
  AuthWrapper({super.key});

  final Future<bool> _onboardingCheck = OnboardingService()
      .hasCompletedOnboarding();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _onboardingCheck,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        }

        final bool onboardingComplete = snapshot.data ?? false;

        if (!onboardingComplete) {
          return const OnboardinScreen();
        }

        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return const MainScreen();
            } else if (state is AuthUnathenticated || state is AuthInitial) {
              return const LoginScreen();
            } else {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },
        );
      },
    );
  }
}
