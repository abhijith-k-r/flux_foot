import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/routing/navigator.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_snackbar.dart';
import 'package:fluxfoot_user/features/auth/view_model/signup_bloc/signup_bloc.dart';
import 'package:fluxfoot_user/features/auth/view_model/signup_bloc/signup_state.dart';
import 'package:fluxfoot_user/features/auth/views/widgets/sign_up_widgets.dart';
import 'package:fluxfoot_user/features/auth/views/widgets/signup_textform_widgets.dart';
import 'package:fluxfoot_user/features/bottom_navbar/views/screen/main_screen.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return BlocListener<SignupBloc, SignupState>(
      listenWhen: (previous, current) =>
          !previous.isSuccess && current.isSuccess,
      listener: (context, state) {
        if (state.errorMessage != null &&
            state.errorMessage!.isNotEmpty &&
            !state.isLoading &&
            !state.isSuccess) {
          customSnackBar(
            context,
            state.errorMessage!,
            Icons.error_outline,
            AppColors.bgRed,
          );
        }
        if (state.isSuccess && !state.isLoading) {
           customSnackBar(
            context,
            'Successfully Registered Account 💫',
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
                child: BlocBuilder<SignupBloc, SignupState>(
                  builder: (context, state) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ! Sign UP Screen Title
                          SignUpTitle(width: width),
                          SizedBox(height: height * 0.01),
                          // ! Sign UP Screen Sub Title
                          SignUPSubTitle(width: width),
                          SizedBox(height: height * 0.04),
                          // ! Name Input
                          const NameInputField(),
                          SizedBox(height: height * 0.02),
                          const EmailInputField(),
                          SizedBox(height: height * 0.02),
                          // ! Password
                          const PasswordInputField(),
                          SizedBox(height: height * 0.02),
                          // ! Confirm Password
                          const ConfirmPasswordInputField(),
                          SizedBox(height: height * 0.02),
                          const PhoneInputField(),
                          SizedBox(height: height * 0.03),
                          // ! S I G N UP B U T T O N
                          SignUPButton(formKey: _formKey, state: state),
                          SizedBox(height: height * 0.02),
                          // ! Already Have Account Navigate To Sign In Screen
                          const NavigateToSignIn(),
                          SizedBox(height: height * 0.02),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
