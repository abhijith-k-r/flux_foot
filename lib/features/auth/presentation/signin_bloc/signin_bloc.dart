// ignore_for_file: unused_local_variable

import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/firebase/auth/auth_repository.dart';
import 'package:fluxfoot_user/core/firebase/auth/firebase_auth_service.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final BaseAuthRepository _authRepository;
  SigninBloc({required BaseAuthRepository authRepository})
    : _authRepository = authRepository,
      super(SigninState()) {
    on<EmailChanged>(
      (event, emit) => emit(
        state.copyWith(
          email: event.email,
          errorMessage: null,
          isSuccess: false,
        ),
      ),
    );

    on<PasswordChanged>(
      (event, emit) => emit(
        state.copyWith(
          password: event.password,
          errorMessage: null,
          isSuccess: false,
        ),
      ),
    );

    on<TogglePasswordVisibility>(
      (event, emit) =>
          emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible)),
    );

    on<SigninSubmitted>(_onSignInSubmitted);

    on<SigninReset>((evnt, emit) => emit(SigninState()));

    on<GoogleSigninSubmitted>(_onGoogleSigninSubmitted);

    on<ToggleRememberMe>(
      (event, emit) => emit(state.copyWith(isRemember: !state.isRemember)),
    );
  }

  Future<void> _onSignInSubmitted(
    SigninSubmitted event,
    Emitter<SigninState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        isSuccess: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );

    log('Attempting sign-in with email: ${state.email.trim()}');
    log('Attempting sign-in with password: ${state.password.trim()}');

    try {
      await _authRepository.signIn(
        email: state.email.trim(),
        password: state.password.trim(),
      );
      emit(
        state.copyWith(isLoading: false, isSuccess: true, errorMessage: null),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Sign-in failed. Please try again.';
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        message = 'Invalid email or password.';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email format.';
      } else if (e.code == 'user-disabled') {
        message = 'This account has been disabled.';
      }
      log('Firebase Sign-in Error: ${e.code} - ${e.message}');
    } catch (e) {
      String error = (e is Exception)
          ? 'Sign-in failed. please check your network or try again.'
          : e.toString();
      log('Sign in Error: $error');
      emit(
        state.copyWith(isLoading: false, isSuccess: false, errorMessage: error),
      );
    }
  }

  Future<void> _onGoogleSigninSubmitted(
    GoogleSigninSubmitted event,
    Emitter<SigninState> emeit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final user = await _authRepository.googleHandleSignIn();

      if (user != null) {
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            errorMessage:
                FirebaseAuthService.error ??
                'Google Sign-In cancelled or failed. ',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: 'An unexpected error occurred during Google Sign-In.',
        ),
      );
    }
  }
}
