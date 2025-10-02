import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
  @override
  List<Object?> get props => [];
}

class UserProfileRequested extends UserEvent {
  final String uid;
  const UserProfileRequested(this.uid);
  @override
  List<Object?> get props => [uid];
}
