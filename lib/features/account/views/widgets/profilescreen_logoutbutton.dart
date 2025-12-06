// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/routing/navigator.dart';
import 'package:fluxfoot_user/core/widgets/custom_button.dart';
import 'package:fluxfoot_user/features/account/views/widgets/logout_dialog.dart';
import 'package:fluxfoot_user/features/auth/view_model/auth_bloc/auth_bloc.dart';
import 'package:fluxfoot_user/features/auth/view_model/auth_bloc/auth_event.dart';
import 'package:fluxfoot_user/features/auth/view_model/auth_bloc/auth_state.dart';
import 'package:fluxfoot_user/features/auth/views/screens/sign_in_screen.dart';

// !  Logout Button
Widget builldLogOtButton(double size) {
  return BlocListener<AuthBloc, AuthState>(
    listener: (context, state) {
      if (state is AuthUnauthenticated) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
              SnackBar(
                content: const Text(
                  'Account Log Out successfully! Redirecting...',
                ),
                backgroundColor: AppColors.sucessGreen,
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            )
            .closed
            .then((reason) {
              Future.delayed(const Duration(milliseconds: 500), () {
                fadePushAndRemoveUntil(context, SignInScreen());
              });
            });
      } else if (state is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: AppColors.bgRed,
          ),
        );
      }
    },
    child: BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return CustomButton(
          widget: Icon(
            CupertinoIcons.person_crop_circle_badge_exclam,
            color: AppColors.iconRed,
          ),
          text: 'LogOut Account',
          fontSize: size * 0.05,
          spacing: size * 0.05,
          fontWeight: FontWeight.bold,
          showTextAndWidget: true,
          ontap: () async {
            final confirmed = await showLogoutDialog(context);
            if (confirmed == true) {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            }
          },
        ).fadeInUp();
      },
    ),
  );
}
