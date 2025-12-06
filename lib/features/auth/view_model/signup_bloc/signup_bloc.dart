// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/services/firebase/auth_repository.dart';
import 'package:fluxfoot_user/features/auth/view_model/signup_bloc/signup_event.dart';
import 'package:fluxfoot_user/features/auth/view_model/signup_bloc/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final BaseAuthRepository _authRepository;

  SignupBloc({required BaseAuthRepository authRepository})
    : _authRepository = authRepository,

      super(const SignupState()) {
    on<NameChanged>(
      (evnt, emit) => emit(state.copyWith(name: evnt.name, errorMessage: null)),
    );

    on<EmailChanged>(
      (event, emit) =>
          emit(state.copyWith(email: event.email, errorMessage: null)),
    );

    on<PasswordChanged>(
      (event, emit) =>
          emit(state.copyWith(password: event.password, errorMessage: null)),
    );

    on<ConfirmPasswordChanged>(
      (event, emit) => emit(
        state.copyWith(
          confirmPassword: event.confirmpassword,

          errorMessage: null,
        ),
      ),
    );

    on<PhoneChanged>(
      (event, emit) =>
          emit(state.copyWith(phone: event.phone, errorMessage: null)),
    );

    on<TogglePasswordVisibility>(
      (event, emit) =>
          emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible)),
    );

    on<ToggleConfirmPasswordVisibility>(
      (event, emit) => emit(
        state.copyWith(
          isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
        ),
      ),
    );

    on<SignupSubmitted>(_onSignupSubmitted);

    on<AutoValidateModeChanged>(
      (event, emit) =>
          emit(state.copyWith(autovalidateMode: event.autovalidateMode)),
    );
  }

  Future<void> _onSignupSubmitted(
    SignupSubmitted event,

    Emitter<SignupState> emit,
  ) async {
    if (state.password != state.confirmPassword) {
      emit(state.copyWith(errorMessage: 'Password do not match'));

      ScaffoldMessenger.of(event.context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),

          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      await _authRepository.signUpUser(
        name: state.name.trim(),

        email: state.email.trim(),

        password: state.password.trim(),

        phone: state.phone.trim(),
      );

      emit(
        state.copyWith(isLoading: false, errorMessage: null, isSuccess: true),
      );

      ScaffoldMessenger.of(event.context).showSnackBar(
        const SnackBar(
          content: Text('Sign-up successful!'),

          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      log('FirebaseAuthException: ${e.code} - ${e.message}');

      emit(
        state.copyWith(
          errorMessage: e.message ?? 'An unknown Firebase error occurred',
        ),
      );
    } catch (e) {
      String error = (e is Exception)
          ? 'Sign-up failed. Please check your network or try again.'
          : e.toString();

      log('General Error: $error');

      emit(state.copyWith(errorMessage: error));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
