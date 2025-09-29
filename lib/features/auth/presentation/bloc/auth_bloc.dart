import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/features/auth/domain/repositories/auth_repository.dart';
import 'package:fluxfoot_user/features/auth/domain/usecases/forgot_password.dart';
import 'package:fluxfoot_user/features/auth/domain/usecases/google_sign_in.dart';
import 'package:fluxfoot_user/features/auth/domain/usecases/sign_in.dart';
import 'package:fluxfoot_user/features/auth/domain/usecases/sign_up.dart';
import 'package:fluxfoot_user/features/auth/presentation/bloc/auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUp _signUp;
  final SignIn _signIn;
  final GoogleSignInUseCase _googleSignIn;
  final ForgotPassword _forgotPassword;
  final AuthRepository _authRepository;

  StreamSubscription? _authSubscription;

  AuthBloc({
    required SignUp signUp,
    required SignIn signIn,
    required GoogleSignInUseCase googleSignIn,
    required ForgotPassword forgotPassword,
    required AuthRepository authRepository,
  }) : _signUp = signUp,
       _signIn = signIn,
       _googleSignIn = googleSignIn,
       _forgotPassword = forgotPassword,
       _authRepository = authRepository,
       super(AuthInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
    on<SignInRequested>(_onSignInRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<AuthStatusChanged>(_onAuthStatusChanged);

    // Listen to auth state changes
    _authSubscription = _authRepository.authStateChanges.listen((user) {
      add(AuthStatusChanged(isAuthenticated: user != null, userId: user?.id));
    });
  }

  // ! Sign_UP Request
  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _signUp(
        name: event.name,
        email: event.email,
        password: event.password,
        phone: event.phone,
      );
      emit(
        const SignUpSuccess(
          message: 'Account created successfully! please Verify your email.',
        ),
      );
    } catch (e) {
      emit(AuthEroor(message: e.toString()));
    }
  }

  // ! Sign_IN Request

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _signIn(email: event.email, password: event.password);
      emit(
        AuthAuthenticated(
          userId: user.id,
          email: user.email,
          displayName: user.displayName,
          phone: user.phone,
        ),
      );
    } catch (e) {
      emit(AuthEroor(message: e.toString()));
    }
  }

  // ! GOOGLE SIGNIN REQUEST
  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await _googleSignIn();
      emit(
        AuthAuthenticated(
          userId: user.id,
          email: user.email,
          displayName: user.displayName,
          phone: user.phone,
        ),
      );
    } catch (e) {
      emit(AuthEroor(message: e.toString()));
    }
  }

  // ! FORGOT PASSWORD
  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _forgotPassword(email: event.email);
      emit(
        const ForgotPasswordSuccess(
          message: 'Password reset email sent successfully!',
        ),
      );
    } catch (e) {
      emit(AuthEroor(message: e.toString()));
    }
  }

  // ! sIGN OUT REQUESTED
  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      emit(AuthUnathenticated());
    } catch (e) {
      emit(AuthEroor(message: e.toString()));
    }
  }

  // ! STATUS CHANGED
  void _onAuthStatusChanged(AuthStatusChanged event, Emitter<AuthState> emit) {
    if (event.isAuthenticated && event.userId != null) {
      final currentUser = _authRepository.currentUser;
      if (currentUser != null) {
        emit(
          AuthAuthenticated(
            userId: currentUser.id,
            email: currentUser.email,
            displayName: currentUser.displayName,
            phone: currentUser.phone,
          ),
        );
      }
    } else {
      emit(AuthUnathenticated());
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
