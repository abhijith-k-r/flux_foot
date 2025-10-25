import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/routing/navigator.dart';
import 'package:fluxfoot_user/core/widgets/custom_button.dart';
import 'package:fluxfoot_user/features/auth/view_model/signup_bloc/signup_bloc.dart';
import 'package:fluxfoot_user/features/auth/view_model/signup_bloc/signup_event.dart';
import 'package:fluxfoot_user/features/auth/view_model/signup_bloc/signup_state.dart';
import 'package:fluxfoot_user/features/auth/views/screens/sign_in_screen.dart';
import 'package:fluxfoot_user/features/auth/views/widgets/auth_widgets.dart';
import 'package:fluxfoot_user/features/bottom_navbar/views/screen/main_screen.dart';
import 'package:google_fonts/google_fonts.dart';



// ! Divider With Or 
dividerOr() {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: Row(
      children: [
        Expanded(child: Divider(thickness: 1, color: Colors.black)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('or', style: TextStyle(fontSize: 20)),
        ),
        Expanded(child: Divider(thickness: 1, color: Colors.black)),
      ],
    ),
  );
}

// ! From Sign Up Screen to Sign In Screen 
class NavigateToSignIn extends StatelessWidget {
  const NavigateToSignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthCheckBox(
      mainAxis: MainAxisAlignment.center,
      prefText: 'Already have an account?.',
      sufWidget: TextButton(
        onPressed: () {
          fadePush(context, SignInScreen());
        },
        child: Text(
          'Login',
          style: GoogleFonts.openSans(
            fontWeight: FontWeight.bold,
            color: AppColors.activeOrange,
          ),
        ),
      ),
    );
  }
}

// ! Sign UP Button
class SignUPButton extends StatelessWidget {
  const SignUPButton({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.state,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final SignupState state;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      ontap: state.isLoading
          ? () {}
          : () {
              if (_formKey.currentState!.validate()) {
                context.read<SignupBloc>().add(SignupSubmitted(context));
                fadePUshReplaceMent(context, MainScreen());
              }
            },
      text: state.isLoading ? 'Processing...' : 'Sign Up',
    );
  }
}
// ! Sign UP Screen Title TEXT
class SignUPSubTitle extends StatelessWidget {
  const SignUPSubTitle({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Text(
      "Please Register your account",
      style: GoogleFonts.openSans(
        fontSize: width * 0.048,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
// ! Sign UP Screen Sub Title TEXT
class SignUpTitle extends StatelessWidget {
  const SignUpTitle({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Sign Up',
      style: GoogleFonts.openSans(
        fontSize: width * 0.09,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
