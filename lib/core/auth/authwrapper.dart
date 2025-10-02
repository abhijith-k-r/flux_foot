import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/auth/onboardin_screen.dart';
import 'package:fluxfoot_user/core/auth/onboarding_service.dart';
import 'package:fluxfoot_user/features/auth/presentation/auth_bloc/auth_state.dart';
import 'package:fluxfoot_user/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:fluxfoot_user/features/auth/presentation/screens/login_signup_screen.dart';
import 'package:fluxfoot_user/features/auth/presentation/screens/splash_screen.dart';
import 'package:fluxfoot_user/features/bottom_navbar/presentation/screen/main_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late Future<bool> _onboardingCheck;
  @override
  void initState() {
    _onboardingCheck = OnboardingService().hasCompletedOnboarding();
    super.initState();
  }

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
            } else if (state is AuthUnauthenticated || state is AuthInitial) {
              return const LoginSignUpScreen();
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
