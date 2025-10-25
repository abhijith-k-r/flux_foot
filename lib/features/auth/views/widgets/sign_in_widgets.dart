import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/routing/navigator.dart';
import 'package:fluxfoot_user/core/widgets/custom_button.dart';
import 'package:fluxfoot_user/features/auth/view_model/usecases/form_validator.dart';
import 'package:fluxfoot_user/features/auth/views/screens/forgot_password.dart';
import 'package:fluxfoot_user/features/auth/view_model/signin_bloc/signin_bloc.dart';
import 'package:fluxfoot_user/features/auth/views/widgets/auth_widgets.dart';
import 'package:google_fonts/google_fonts.dart';

// ! Google Authentication
class GoogleUserSignin extends StatelessWidget {
  const GoogleUserSignin({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SigninBloc, SigninState>(
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
      builder: (context, state) {
        return GoogleAuth(
          ontap: state.isLoading
              ? () {}
              : () {
                  context.read<SigninBloc>().add(GoogleSigninSubmitted());
                },
        );
      },
    );
  }
}

// ! For Sign In Email Texform
class SignInEmailTextform extends StatelessWidget with Validator {
  const SignInEmailTextform({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SigninBloc, SigninState, AutovalidateMode>(
      selector: (state) => state.autovalidateMode,
      builder: (context, autovalidateMode) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            Text('E-mail Address'),
            TextFormField(
              autovalidateMode: autovalidateMode,
              validator: validateEmail,
              onChanged: (value) =>
                  context.read<SigninBloc>().add(EmailChanged(value)),
              decoration: InputDecoration(
                hintText: 'Enter Email...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                prefixIcon: Icon(CupertinoIcons.envelope),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ! For Sign In Password Text FormField
class SigninPasswordTexform extends StatefulWidget with Validator {
  const SigninPasswordTexform({super.key});

  @override
  State<SigninPasswordTexform> createState() => _SigninPasswordTexformState();
}

class _SigninPasswordTexformState extends State<SigninPasswordTexform> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SigninBloc, SigninState, (AutovalidateMode, bool)>(
      selector: (state) => (state.autovalidateMode, state.isPasswordVisible),

      builder: (context, selection) {
        final autovalidateMode = selection.$1;
        final isVisible = selection.$2;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            Text('Password'),
            TextFormField(
              controller: _passwordController,
              autovalidateMode: autovalidateMode,
              onChanged: (value) =>
                  context.read<SigninBloc>().add(PasswordChanged(value)),
              obscureText: !isVisible,
              validator: widget.validatePassword,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline_rounded),
                hintText: 'Enter Password...',
                suffixIcon: IconButton(
                  icon: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => context.read<SigninBloc>().add(
                    TogglePasswordVisibility(),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}



class RememberForgot extends StatelessWidget {
  const RememberForgot({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SigninBloc, SigninState>(
      builder: (context, state) {
        return AuthCheckBox(
          mainAxis: MainAxisAlignment.spaceBetween,
          checkBox: Checkbox(
            activeColor: AppColors. activeOrange,
            value: state.isRemember,
            onChanged: (_) {
              context.read<SigninBloc>().add(ToggleRememberMe());
            },
          ),
          prefText: 'Remember me',
          sufWidget: TextButton(
            onPressed: () {
              fadePush(context, ResetPasswordScreen());
            },
            child: Text(
              'Forgot password?',
              style: GoogleFonts.openSans(
                fontWeight: FontWeight.bold,
                color: AppColors. textBlack,
              ),
            ),
          ),
        );
      },
    );
  }
}

class SignInSubmittedButton extends StatelessWidget {
  const SignInSubmittedButton({
    super.key,
    required GlobalKey<FormState> formkey,
  }) : _formkey = formkey;

  final GlobalKey<FormState> _formkey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SigninBloc, SigninState>(
      builder: (context, state) {
        return CustomButton(
          ontap: state.isLoading
              ? () {}
              : () {
                  if (_formkey.currentState!.validate()) {
                    context.read<SigninBloc>().add(SigninSubmitted());
                  }
                },
          text: 'Sign In',
        );
      },
    );
  }
}

// ! Sub Title TEXT
class LoginScreenSubtitle extends StatelessWidget {
  const LoginScreenSubtitle({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Please login to your account',
      style: GoogleFonts.openSans(
        fontSize: width * 0.048,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

// ! Title TEXT
class LoginTitle extends StatelessWidget {
  const LoginTitle({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Login',
      style: GoogleFonts.openSans(
        fontSize: width * 0.09,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
