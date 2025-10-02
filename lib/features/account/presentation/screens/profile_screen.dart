// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/features/account/presentation/screens/account_screen.dart';
import 'package:fluxfoot_user/features/auth/presentation/auth_bloc/auth_event.dart';
import 'package:fluxfoot_user/features/auth/presentation/auth_bloc/auth_state.dart';
import 'package:fluxfoot_user/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:fluxfoot_user/features/auth/presentation/bloc/user_bloc.dart';
import 'package:fluxfoot_user/features/auth/presentation/bloc/user_state.dart';
import 'package:fluxfoot_user/features/auth/presentation/screens/login_screen.dart';
import 'package:fluxfoot_user/features/auth/presentation/screens/login_signup_screen.dart';
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
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, userState) {
            String name = 'Loading...';
            String email = 'Loading...';
            String phone = 'Loading...';
            String dob = '03-05-2004';

            if (userState is UserLoading) {
              name = 'Fetching profile...';
            } else if (userState is UseerLoaded) {
              name = userState.user.name;
              email = userState.user.email;
              phone = userState.user.phone;
            } else if (userState is UserError) {
              name = 'Error loading profile';
              email = userState.message;
            }
            return Column(
              spacing: size * 0.05,
              children: [
                SizedBox(height: size * 0.01),
                // ! Circle Avatar For User Profile
                UserProfileImage(size: size, radius: size * 0.15).fadeInDown(),
                // ! User name
                ProfileName(size: size, name: name).fadeInDownBig(),
                // ! Details
                ProfileDetails(
                  size: size,
                  title: 'NAME',
                  icon: Icon(Icons.person_2_rounded),
                  subtitle: name,
                ).fadeInLeft(),
                ProfileDetails(
                  size: size,
                  title: 'ACCOUNT INFORMATION',
                  icon: Icon(CupertinoIcons.person_alt_circle),
                  subtitle: email,
                ).fadeInRight(),
                ProfileDetails(
                  size: size,
                  title: 'PHONE NUMBER',
                  icon: Icon(CupertinoIcons.phone),
                  subtitle: phone,
                ).fadeInLeft(),
                ProfileDetails(
                  size: size,
                  title: 'D O B',
                  icon: Icon(Icons.cake),
                  subtitle: '03/05/2004',
                ).fadeInRight(),

                CustomButton(
                  backColor: Colors.orange,
                  widget: Icon(Icons.edit, color: Colors.white),
                  text: 'Edit Profile',
                  fontSize: size * 0.05,
                  spacing: size * 0.05,
                  fontWeight: FontWeight.bold,
                  showTextAndWidget: true,
                  ontap: () {},
                ).fadeInUpBig(),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthUnauthenticated) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Account deleted successfully! Redirecting...',
                              ),
                              backgroundColor: Colors.red,
                              duration: Duration(
                                seconds: 2,
                              ), // Keep SnackBar visible briefly
                            ),
                          )
                          .closed
                          .then((reason) {
                            Future.delayed(Duration(milliseconds: 500), () {
                              fadePUshReplaceMent(context, LoginSignUpScreen());
                            });
                          });
                    } else if (state is AuthError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    final bool isLoading = state is AuthLoading;
                    return CustomButton(
                      widget: isLoading
                          ? CircularProgressIndicator()
                          : Icon(
                              CupertinoIcons.person_crop_circle_badge_exclam,
                              color: Colors.red,
                            ),
                      text: 'Delete Account',
                      fontSize: size * 0.05,
                      spacing: size * 0.05,
                      fontWeight: FontWeight.bold,
                      showTextAndWidget: true,
                      ontap: isLoading
                          ? null
                          : () {
                              context.read<AuthBloc>().add(
                                AuthLogoutRequested(),
                              );
                            },
                    );
                  },
                ).fadeInUp(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ProfileName extends StatelessWidget {
  const ProfileName({super.key, required this.size, required this.name});

  final double size;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Hey, $name',
      style: GoogleFonts.openSans(
        fontWeight: FontWeight.bold,
        fontSize: size * 0.055,
      ),
    );
  }
}

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({
    super.key,
    required this.size,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final double size;
  final String title;
  final String subtitle;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: size * 0.03, right: size * 0.03),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: ListTile(
          title: Row(
            spacing: size * 0.02,
            children: [
              Text(
                title,

                style: GoogleFonts.rozhaOne(
                  fontSize: size * 0.045,
                  color: const Color.fromARGB(221, 46, 46, 46),
                  letterSpacing: 3,
                  wordSpacing: 10,
                ),
              ),
              icon,
            ],
          ),
          subtitle: Text(
            subtitle,
            style: GoogleFonts.openSans(
              fontSize: size * 0.05,
              color: Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
