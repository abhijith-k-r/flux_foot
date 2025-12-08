// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/routing/navigator.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_backbutton.dart';
import 'package:fluxfoot_user/core/widgets/custom_button.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/account/view_model/bloc/profile_bloc.dart';
import 'package:fluxfoot_user/features/account/views/screens/edit_profile_screen.dart';
import 'package:fluxfoot_user/features/account/views/widgets/account_widgets.dart';
import 'package:fluxfoot_user/features/account/views/widgets/profile_widgets.dart';
import 'package:fluxfoot_user/features/account/views/widgets/profilescreen_logoutbutton.dart';
import 'package:fluxfoot_user/features/home/views/widgets/perticularbrand_tabar_widget.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(ProfileLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(
        leading: customBackButton(context),
        title: Center(
          child: customText(
            size * 0.065,
            'Profile',
            fontWeight: FontWeight.w600,
          ),
        ),
        action: [SizedBox(width: size * 0.2)],
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state.status == ProfileStatus.loading || state.user == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final user = state.user!;
            final data = {
              'name': user.name,
              'email': user.email,
              'phone': user.phone,
              'dob': user.dob,
              'imageUrl': user.imageUrl,
            };
            return Column(
              spacing: size * 0.05,
              children: [
                SizedBox(height: size * 0.01),
                // ! Circle Avatar For User Profile
                UserProfileImage(
                  size: size,
                  radius: size * 0.15,
                  imageUrl: data['imageUrl'],
                ).fadeInDown(),
                // ! User name
                ProfileName(
                  size: size,
                  name: data['name'] as String,
                ).fadeInDown(),
                // !User Name Details
                ProfileDetails(
                  size: size,
                  title: 'NAME',
                  icon: Icon(Icons.person_2_rounded),
                  subtitle: data['name'] as String,
                ).fadeInLeft(),
                // ! User Email Details
                ProfileDetails(
                  size: size,
                  title: 'ACCOUNT INFORMATION',
                  icon: Icon(CupertinoIcons.person_alt_circle),
                  subtitle: data['email'] as String,
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
                LiquidGlassLayer(
                  settings: iosGlassSettings,
                  child: LiquidGlass(
                    shape: LiquidRoundedSuperellipse(borderRadius: 15),
                    child: GlassGlow(
                      child: CustomButton(
                        backColor: Colors.transparent,
                        widget: Icon(Icons.edit, color: AppColors.iconBlack),
                        text: 'Edit Profile',
                        fontSize: size * 0.05,
                        spacing: size * 0.05,
                        fontWeight: FontWeight.bold,
                        showTextAndWidget: true,
                        textColor: AppColors.textBlack,
                        ontap: () {
                          fadePush(context, EditProfileScreen());
                        },
                      ).fadeInLeft(),
                    ),
                  ),
                ),
                // ! User Log Out Button
                builldLogOtButton(size).fadeInRight(),
              ],
            );
          },
        ),
      ),
    );
  }
}
