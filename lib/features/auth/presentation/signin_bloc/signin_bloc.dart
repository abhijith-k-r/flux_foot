// ignore_for_file: unused_local_variable

import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/firebase/auth/auth_repository.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final BaseAuthRepository _authRepository;
  SigninBloc({required BaseAuthRepository authRepository})
    : _authRepository = authRepository,
      super(SigninState()) {
    on<EmailChanged>(
      (event, emit) =>
          emit(state.copyWith(email: event.email, errorMessage: null)),
    );

    on<PasswordChanged>(
      (event, emit) =>
          emit(state.copyWith(password: event.password, errorMessage: null)),
    );

    on<TogglePasswordVisibility>(
      (event, emit) =>
          emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible)),
    );

    on<SigninSubmitted>(_onSignInSubmitted);
  }

  Future<void> _onSignInSubmitted(
    SigninSubmitted event,
    Emitter<SigninState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, isSuccess: false));

    try {
      await _authRepository.signIn(
        email: state.email.trim(),
        password: state.password.trim(),
      );
      emit(
        state.copyWith(isLoading: false, errorMessage: null, isSuccess: true),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Sign-in failed. Please try again.';
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        message = 'Invalid email or password.';
      }
      log('Firebase Sign-in Error: ${e.code} - ${e.message}');
    } catch (e) {
      String error = (e is Exception)
          ? 'Sign-in failed. please check your network or try again.'
          : e.toString();
      log('Sign in Error: $error');
      emit(state.copyWith(errorMessage: error));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
