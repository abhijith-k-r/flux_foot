import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/features/auth/domain/usecases/form_validator.dart';
import 'package:fluxfoot_user/features/auth/presentation/screens/forgot_password.dart';
import 'package:fluxfoot_user/features/auth/presentation/screens/login_screen.dart';
import 'package:fluxfoot_user/features/auth/presentation/screens/login_signup_screen.dart';
import 'package:fluxfoot_user/features/auth/presentation/signin_bloc/signin_bloc.dart';
import 'package:fluxfoot_user/features/bottom_navbar/presentation/screen/main_screen.dart';
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
          !previous.isSuccess && current.isSuccess,
      listener: (context, state) {
        if (state.errorMessage != null &&
            state.errorMessage!.isNotEmpty &&
            !state.isLoading &&
            !state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state.isSuccess && !state.isLoading) {
          fadePUshReplaceMent(context, MainScreen());
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(leading: customBackButton(context)),
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
                      Text(
                        'Login',
                        style: GoogleFonts.openSans(
                          fontSize: width * 0.09,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Text(
                        'Please login to your account',
                        style: GoogleFonts.openSans(
                          fontSize: width * 0.048,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: height * 0.04),

                      // ! Email Text Form Field
                      SignInEmailTextform(),
                      SizedBox(height: height * 0.02),
                      // ! Password Text Form Fiel
                      SigninPasswordTexform(),
                      SizedBox(height: height * 0.01),
                      BlocBuilder<SigninBloc, SigninState>(
                        builder: (context, state) {
                          return AuthCheckBox(
                            mainAxis: MainAxisAlignment.spaceBetween,
                            checkBox: Checkbox(
                              activeColor: Color(0xFFFF8C00),
                              value: state.isRemember,
                              onChanged: (_) {
                                context.read<SigninBloc>().add(
                                  ToggleRememberMe(),
                                );
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
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: height * 0.03),
                      BlocBuilder<SigninBloc, SigninState>(
                        builder: (context, state) {
                          return CustomButton(
                            ontap: state.isLoading
                                ? () {}
                                : () {
                                    if (_formkey.currentState!.validate()) {
                                      context.read<SigninBloc>().add(
                                        SigninSubmitted(),
                                      );
                                    }
                                  },
                            text: 'Sign In',
                          );
                        },
                      ),
                      SizedBox(height: height * 0.02),
                      dividerOr(),
                      SizedBox(height: height * 0.02),
                      // ! Google Sign In
                      GoogleUserSignin(),

                      SizedBox(height: height * 0.03),
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

// ! For Sign In
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

// ! For Sign In Password

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
