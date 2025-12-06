part of 'profile_bloc.dart';

abstract class ProfileEvent {
  const ProfileEvent();
}


class ProfileLoadRequested extends ProfileEvent {}

class ProfileUpdateRequested extends ProfileEvent {
  final String name;
  final String phone;
  final String dob;
  final XFile? imageFile;
  final bool removeImage;

  const ProfileUpdateRequested({
    required this.name,
    required this.phone,
    required this.dob,
    this.imageFile,
    this.removeImage = false,
  });
}
