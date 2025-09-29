part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String userId;
  final String email;
  final String? displayName;
  final String? phone;

  const AuthAuthenticated({
    required this.userId,
    required this.email,
    this.displayName,
    this.phone,
  });

  @override
  List<Object> get props => [userId, email, displayName ?? '', phone ?? ''];
}

class AuthUnathenticated extends AuthState {}

class AuthEroor extends AuthState {
  final String message;

  const AuthEroor({required this.message});

  @override
  List<Object> get props => [message];
}

class SignUpSuccess extends AuthState {
  final String message;

  const SignUpSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class ForgotPasswordSuccess extends AuthState {
  final String message;

  const ForgotPasswordSuccess({required this.message});

  @override
  List<Object> get props => [message];
}
