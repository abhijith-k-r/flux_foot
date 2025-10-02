
import 'package:equatable/equatable.dart';
import 'package:fluxfoot_user/features/auth/model/usermodel.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class UseerLoaded extends UserState {
  final UserModel user;
  const UseerLoaded(this.user);
  @override
  List<Object> get props => [user];
}

class UserError extends UserState {
  final String message;
  const UserError(this.message);
  @override
  List<Object> get props => [message];
}
