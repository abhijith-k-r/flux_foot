import 'package:equatable/equatable.dart';

// part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}


class AuthUserChanged extends AuthEvent {
  final String? userId;

  const AuthUserChanged(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
