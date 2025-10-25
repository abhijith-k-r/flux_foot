import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/features/onboarding/views/screens/onboardin_screen.dart';
import 'package:fluxfoot_user/features/auth/view_model/auth_bloc/auth_state.dart';
import 'package:fluxfoot_user/features/auth/view_model/auth_bloc/auth_bloc.dart';
import 'package:fluxfoot_user/features/onboarding/view_model/onboarding_service.dart';
import 'package:fluxfoot_user/features/auth/views/screens/sign_in_screen.dart';
import 'package:fluxfoot_user/features/onboarding/views/screens/splash_screen.dart';
import 'package:fluxfoot_user/features/bottom_navbar/views/screen/main_screen.dart';

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
    log('AuthWrapper initState: Initializing onboarding check');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => current is AuthUnauthenticated,
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          log('AuthUnauthenticated: Resetting onboarding check');
          setState(() {
            _onboardingCheck = OnboardingService().hasCompletedOnboarding();
          });
        }
      },
      child: FutureBuilder<bool>(
        future: _onboardingCheck,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            log('FutureBuilder: Rendering SplashScreen');
            return SplashScreen();
          }

          final bool onboardingComplete = snapshot.data ?? false;
          log('FutureBuilder: onboardingComplete=$onboardingComplete');

          if (!onboardingComplete) {
            log('FutureBuilder: Rendering OnboardinScreen');
            return const OnboardinScreen();
          }

          return BlocBuilder<AuthBloc, AuthState>(
            buildWhen: (previous, current) {
              log('BlocBuilder: previous=$previous, current=$current');
              return true; 
            },
            builder: (context, state) {
              log('AuthBloc state: $state');
              if (state is AuthAuthenticated) {
                log('BlocBuilder: Rendering LoginSignUpScreen');
                return const MainScreen();
              } else if (state is AuthUnauthenticated) {
                return  SignInScreen();
              } else if (state is AuthError) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                });
                log(
                  'BlocBuilder: Rendering LoginSignUpScreen with error=${state.message}',
                );
                return  SignInScreen();
              } else {
                log(
                  'BlocBuilder: Rendering CircularProgressIndicator for state=$state',
                );
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
            },
          );
        },
      ),
    );
  }
}
