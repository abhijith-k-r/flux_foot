part of 'signin_bloc.dart';

abstract class SigninEvent extends Equatable {
  const SigninEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends SigninEvent {
  final String email;

  const EmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class PasswordChanged extends SigninEvent {
  final String password;

  const PasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class TogglePasswordVisibility extends SigninEvent {}

class SigninSubmitted extends SigninEvent {
  const SigninSubmitted();
}

class AutoValidateModeChanged extends SigninEvent {
  final AutovalidateMode autovalidateMode;

  const AutoValidateModeChanged(this.autovalidateMode);
}

class SigninReset extends SigninEvent {}

class ToggleRememberMe extends SigninEvent {}

// ! for google auth
class GoogleSigninSubmitted extends SigninEvent {}
