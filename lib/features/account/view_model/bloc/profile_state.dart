part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, loaded, updating, error }

class ProfileState {
  final ProfileStatus status;
  final UserModel? user;
  final String? error;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.error,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserModel? user,
    String? error,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}
