import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SignupState extends Equatable {
  final AutovalidateMode autovalidateMode;

  final String name;

  final String email;

  final String password;

  final String confirmPassword;

  final String phone;

  final String? errorMessage;

  final bool isLoading;

  final bool isSuccess;

  final bool isPasswordVisible;

  final bool isConfirmPasswordVisible;

  const SignupState({
    this.autovalidateMode = AutovalidateMode.disabled,

    this.name = '',

    this.email = '',

    this.password = '',

    this.confirmPassword = '',

    this.phone = '',

    this.errorMessage,

    this.isLoading = false,

    this.isSuccess = false,

    this.isPasswordVisible = false,

    this.isConfirmPasswordVisible = false,
  });

  // CopyWith method for creating new states based on the old one

  SignupState copyWith({
    AutovalidateMode? autovalidateMode,

    String? name,

    String? email,

    String? password,

    String? confirmPassword,

    String? phone,

    String? errorMessage,

    bool? isLoading,

    bool? isSuccess,

    bool? isPasswordVisible,

    bool? isConfirmPasswordVisible,
  }) {
    return SignupState(
      autovalidateMode: autovalidateMode ?? this.autovalidateMode,

      name: name ?? this.name,

      email: email ?? this.email,

      password: password ?? this.password,

      confirmPassword: confirmPassword ?? this.confirmPassword,

      phone: phone ?? this.phone,

      errorMessage: errorMessage,

      isLoading: isLoading ?? this.isLoading,

      isSuccess: isSuccess ?? this.isSuccess,

      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,

      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
    );
  }

  @override
  List<Object> get props => [
    autovalidateMode,

    name,

    email,

    password,

    confirmPassword,

    phone,

    ?errorMessage,

    isLoading,

    isSuccess,

    isPasswordVisible,

    isConfirmPasswordVisible,
  ];
}
