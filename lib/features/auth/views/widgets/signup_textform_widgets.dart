import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/features/auth/view_model/usecases/form_validator.dart';
import 'package:fluxfoot_user/features/auth/view_model/signup_bloc/signup_bloc.dart';
import 'package:fluxfoot_user/features/auth/view_model/signup_bloc/signup_event.dart';
import 'package:fluxfoot_user/features/auth/view_model/signup_bloc/signup_state.dart';

//! TEXTFORM FIELD FOR SIGNUP SCREEN
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
    return BlocSelector<
      SignupBloc,
      SignupState,
      (AutovalidateMode, bool, String)
    >(
      selector: (state) => (
        state.autovalidateMode,
        state.isConfirmPasswordVisible,
        state.password,
      ),
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
              validator: (value) =>
                  widget.validateConfirmPassword(value, password),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                hintText: 'confirm Password...',
                suffixIcon: IconButton(
                  icon: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
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
