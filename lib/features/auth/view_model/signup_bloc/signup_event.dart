import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class NameChanged extends SignupEvent {
  final String name;

  const NameChanged(this.name);

  @override
  List<Object> get props => [name];
}

class EmailChanged extends SignupEvent {
  final String email;

  const EmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class PasswordChanged extends SignupEvent {
  final String password;

  const PasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class ConfirmPasswordChanged extends SignupEvent {
  final String confirmpassword;

  const ConfirmPasswordChanged(this.confirmpassword);

  @override
  List<Object> get props => [confirmpassword];
}

class PhoneChanged extends SignupEvent {
  final String phone;

  const PhoneChanged(this.phone);

  @override
  List<Object> get props => [phone];
}



// Events for UI actions

class TogglePasswordVisibility extends SignupEvent {}

class ToggleConfirmPasswordVisibility extends SignupEvent {}

class SignupSubmitted extends SignupEvent {
  final BuildContext context;

  const SignupSubmitted(this.context);

  @override
  List<Object> get props => [context];
}

class AutoValidateModeChanged extends SignupEvent {
  final AutovalidateMode autovalidateMode;

  const AutoValidateModeChanged(this.autovalidateMode);
}
