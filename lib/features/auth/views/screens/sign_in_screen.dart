
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/routing/navigator.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_snackbar.dart';
import 'package:fluxfoot_user/features/auth/views/screens/sign_up_screen.dart';
import 'package:fluxfoot_user/features/auth/view_model/signin_bloc/signin_bloc.dart';
import 'package:fluxfoot_user/features/auth/views/widgets/auth_widgets.dart';
import 'package:fluxfoot_user/features/auth/views/widgets/sign_in_widgets.dart';
import 'package:fluxfoot_user/features/auth/views/widgets/sign_up_widgets.dart';
import 'package:fluxfoot_user/features/bottom_navbar/views/screen/main_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return BlocListener<SigninBloc, SigninState>(
      listenWhen: (previous, current) =>
          previous.isSuccess != current.isSuccess ||
          previous.isLoading != current.isLoading ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null &&
            state.errorMessage!.isNotEmpty &&
            !state.isLoading &&
            !state.isSuccess) {
          customSnackBar(
            context,
            state.errorMessage!,
            CupertinoIcons.xmark_circle_fill,
            AppColors.bgRed,
          );
        }
        if (state.isSuccess && !state.isLoading) {
          customSnackBar(
            context,
            'Successfully Sign in 💫',
            CupertinoIcons.check_mark_circled_solid,
            AppColors.sucessGreen,
          );
          fadePUshReplaceMent(context, MainScreen());
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.04,
            vertical: height * 0.02,
          ),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    height -
                    kToolbarHeight -
                    MediaQuery.of(context).padding.top,
              ),
              child: IntrinsicHeight(
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.03),
                      // ! Login Screen Title
                      LoginTitle(width: width),
                      SizedBox(height: height * 0.01),
                      // ! Login Screen Sub Title
                      LoginScreenSubtitle(width: width),
                      SizedBox(height: height * 0.04),
                      // ! Email Text Form Field
                      SignInEmailTextform(),
                      SizedBox(height: height * 0.02),
                      // ! Password Text Form Fiel
                      SigninPasswordTexform(),
                      SizedBox(height: height * 0.01),
                      // ! Remember Me and Forgot Button
                      RememberForgot(),
                      SizedBox(height: height * 0.03),
                      // !Bloc Wraped Sign in Submitted Button
                      SignInSubmittedButton(formkey: _formkey),
                      SizedBox(height: height * 0.02),
                      dividerOr(),
                      SizedBox(height: height * 0.02),
                      // ! Google Sign In
                      GoogleUserSignin(),
                      SizedBox(height: height * 0.03),
                      AuthCheckBox(
                        mainAxis: MainAxisAlignment.center,
                        prefText: 'Register your account.',
                        sufWidget: TextButton(
                          onPressed: () {
                            fadePush(context, SignUpScreen());
                          },
                          child: Text(
                            'SignUp',
                            style: GoogleFonts.openSans(
                              fontWeight: FontWeight.bold,
                              color: AppColors.activeOrange,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

