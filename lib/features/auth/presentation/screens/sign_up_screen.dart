import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/features/auth/domain/usecases/form_validator.dart';
import 'package:fluxfoot_user/features/auth/presentation/signup_bloc/signup_bloc.dart';
import 'package:fluxfoot_user/features/auth/presentation/signup_bloc/signup_event.dart';
import 'package:fluxfoot_user/features/auth/presentation/signup_bloc/signup_state.dart';
import 'package:fluxfoot_user/features/auth/presentation/screens/login_screen.dart';
import 'package:fluxfoot_user/features/auth/presentation/screens/login_signup_screen.dart';
import 'package:fluxfoot_user/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:fluxfoot_user/features/bottom_navbar/presentation/screen/main_screen.dart';
import 'package:google_fonts/google_fonts.dart';

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
                child: BlocBuilder<SignupBloc, SignupState>(
                  builder: (context, state) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: height * 0.03),
                          Text(
                            'Sign Up',
                            style: GoogleFonts.openSans(
                              fontSize: width * 0.09,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          Text(
                            "Please Register your account",
                            style: GoogleFonts.openSans(
                              fontSize: width * 0.048,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: height * 0.04),
                          // ! Name Input
                          const NameInputField(),
                          SizedBox(height: height * 0.02),
                          // ! Email
                          const EmailInputField(),
                          SizedBox(height: height * 0.02),
                          // ! Password
                          const PasswordInputField(),
                          SizedBox(height: height * 0.02),
                          // ! Confirm Password
                          const ConfirmPasswordInputField(),
                          SizedBox(height: height * 0.02),
                          // !Phone
                          const PhoneInputField(),
                          SizedBox(height: height * 0.03),
                          // ! S I G N UP B U T T O N
                          CustomButton(
                            ontap: state.isLoading
                                ? () {}
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<SignupBloc>().add(
                                        SignupSubmitted(context),
                                      );
                                      fadePUshReplaceMent(
                                        context,
                                        MainScreen(),
                                      );
                                    }
                                  },
                            text: state.isLoading ? 'Processing...' : 'Sign Up',
                          ),
                          SizedBox(height: height * 0.02),
                          AuthCheckBox(
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
                                  color: const Color(0xFFFF8C00),
                                ),
                              ),
                            ),
                          ),
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

// -----------------------------------------------------------------------------
// Input Field Widgets (Fixing Keyboard Flicker and Validation)
// -----------------------------------------------------------------------------

// 2. CONVERT NameInput to StatefulWidget to use TextEditingController
class NameInputField extends StatelessWidget with Validator {
  const NameInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SignupBloc, SignupState, AutovalidateMode>(
      selector: (state) => state.autovalidateMode,
      builder: (context, autovalidateMode) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            Text('Name'),
            TextFormField(
              autovalidateMode: autovalidateMode,
              validator: validateName,
              onChanged: (value) =>
                  context.read<SignupBloc>().add(NameChanged(value)),
              decoration: const InputDecoration(
                hintText: 'Enter your name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// 2. CONVERT EmailInputField to StatefulWidget
class EmailInputField extends StatelessWidget with Validator {
  const EmailInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SignupBloc, SignupState, AutovalidateMode>(
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
                  context.read<SignupBloc>().add(EmailChanged(value)),
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

// ! PHONE INPUT TEXTFORM
class PhoneInputField extends StatelessWidget with Validator {
  const PhoneInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SignupBloc, SignupState, AutovalidateMode>(
      selector: (state) => state.autovalidateMode,
      builder: (context, autovalidateMode) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            Text('Phone Number'),
            TextFormField(
              autovalidateMode: autovalidateMode,
              onChanged: (value) =>
                  context.read<SignupBloc>().add(PhoneChanged(value)),
              validator: validatePhone,
              decoration: InputDecoration(
                prefixIcon: Icon(CupertinoIcons.phone),
                hintText: '+91 (0000000000)',
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

// typedef PasswordSelector = ({
//   String password,
//   bool isVisible,
//   AutovalidateMode autovalidateMode,
// });

class PasswordInputField extends StatefulWidget with Validator {
  const PasswordInputField({super.key});

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SignupBloc, SignupState, (AutovalidateMode, bool)>(
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
                  context.read<SignupBloc>().add(PasswordChanged(value)),
              obscureText: !isVisible,
              validator: widget.validatePassword,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline_rounded),
                hintText: 'create Password...',
                suffixIcon: IconButton(
                  icon: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => context.read<SignupBloc>().add(
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


class ConfirmPasswordInputField extends StatefulWidget with Validator {
  const ConfirmPasswordInputField({super.key});

  @override
  State<ConfirmPasswordInputField> createState() =>
      _ConfirmPasswordInputFieldState();
}

class _ConfirmPasswordInputFieldState extends State<ConfirmPasswordInputField> {
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SignupBloc, SignupState, (AutovalidateMode, bool, String)>(
      selector: (state) =>
          (state.autovalidateMode, state.isConfirmPasswordVisible,state.password ),
      builder: (context, selection) {
            final autovalidateMode = selection.$1;
        final isVisible = selection.$2;
        final password = selection.$3;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            Text('Password'),
            TextFormField(
              controller: _confirmPasswordController,
              autovalidateMode: autovalidateMode,
              onChanged: (value) =>
                  context.read<SignupBloc>().add(ConfirmPasswordChanged(value)),
              obscureText: isVisible,
              validator: (value) => widget.
                  validateConfirmPassword(value, password),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                hintText: 'confirm Password...',
                suffixIcon: IconButton(
                  icon: Icon(
                    isVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () => context.read<SignupBloc>().add(
                    ToggleConfirmPasswordVisibility(),
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
