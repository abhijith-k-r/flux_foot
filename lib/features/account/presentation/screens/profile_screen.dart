// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/routing/navigator.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_backbutton.dart';
import 'package:fluxfoot_user/core/widgets/custom_button.dart';
import 'package:fluxfoot_user/core/widgets/custom_snackbar.dart';
import 'package:fluxfoot_user/features/account/presentation/widgets/account_widgets.dart';
import 'package:fluxfoot_user/features/account/presentation/widgets/logout_dialog.dart';
import 'package:fluxfoot_user/features/account/presentation/widgets/profile_widgets.dart';
import 'package:fluxfoot_user/features/auth/view_model/auth_bloc/auth_bloc.dart';
import 'package:fluxfoot_user/features/auth/view_model/auth_bloc/auth_event.dart';
import 'package:fluxfoot_user/features/auth/view_model/auth_bloc/auth_state.dart';
import 'package:fluxfoot_user/features/auth/views/screens/sign_in_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(
        leading: customBackButton(context),
        title: Center(
          child: Text(
            'Profile',
            style: GoogleFonts.openSans(
              fontWeight: FontWeight.w600,
              fontSize: size * 0.065,
            ),
          ),
        ),
        action: [SizedBox(width: size * 0.2)],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text("Loading..."));
                }
                final docData = snapshot.data?.data();

                if (docData == null || docData is! Map<String, dynamic>) {
                  return const Center(
                    child: Text("Profile data not found or empty."),
                  );
                }
                final Map<String, dynamic> data = docData;
                return Column(
                  spacing: size * 0.05,
                  children: [
                    SizedBox(height: size * 0.01),
                    // ! Circle Avatar For User Profile
                    UserProfileImage(
                      size: size,
                      radius: size * 0.15,
                      data: data['imageUrl'],
                    ).fadeInDown(),
                    // ! User name
                    ProfileName(size: size, name: data['name']).fadeInDownBig(),
                    // !User Name Details
                    ProfileDetails(
                      size: size,
                      title: 'NAME',
                      icon: Icon(Icons.person_2_rounded),
                      subtitle: data['name'],
                    ).fadeInLeft(),
                    // ! User Email Details
                    ProfileDetails(
                      size: size,
                      title: 'ACCOUNT INFORMATION',
                      icon: Icon(CupertinoIcons.person_alt_circle),
                      subtitle: data['email'],
                    ).fadeInRight(),
                    // ! User Phone Details
                    ProfileDetails(
                      size: size,
                      title: 'PHONE NUMBER',
                      icon: Icon(CupertinoIcons.phone),
                      subtitle: data['phone'] ?? '+91 (000-0000-000)',
                    ).fadeInLeft(),
                    // ! User D/O/D Details
                    ProfileDetails(
                      size: size,
                      title: 'D O B',
                      icon: Icon(Icons.cake),
                      subtitle: data['dob'] ?? '00/00/0000',
                    ).fadeInRight(),
                    // ! User Edit Button
                    CustomButton(
                      backColor: AppColors.bgOrange,
                      widget: Icon(Icons.edit, color: AppColors.iconWhite),
                      text: 'Edit Profile',
                      fontSize: size * 0.05,
                      spacing: size * 0.05,
                      fontWeight: FontWeight.bold,
                      showTextAndWidget: true,
                      ontap: () {
                        customSnackBar(
                          context,
                          'Suii evadey',
                          Icons.sms_failed,
                          Colors.lightGreen,
                        );
                      },
                    ).fadeInUpBig(),
                    // ! User Log Out Button
                    BlocListener<AuthBloc, AuthState>(
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
                                Future.delayed(
                                  const Duration(milliseconds: 500),
                                  () {
                                    fadePushAndRemoveUntil(
                                      context,
                                      SignInScreen(),
                                    );
                                  },
                                );
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
                              // Add async and await
                              final confirmed = await showLogoutDialog(context);
                              if (confirmed == true) {
                                context.read<AuthBloc>().add(
                                  const AuthLogoutRequested(),
                                );
                              }
                            },
                          ).fadeInUp();
                        },
                      ),
                    ),
                  ],
                );
              },
        ),
      ),
    );
  }
}
