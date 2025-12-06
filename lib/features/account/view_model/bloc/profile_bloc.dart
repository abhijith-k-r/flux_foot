import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluxfoot_user/features/auth/model/usermodel.dart';
import 'package:fluxfoot_user/core/services/firebase/auth_repository.dart';
import 'package:image_picker/image_picker.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final BaseAuthRepository _authRepository;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  ProfileBloc({required BaseAuthRepository authRepository})
    : _authRepository = authRepository,
      super(ProfileState()) {
    on<ProfileUpdateRequested>(_onUpdateRequested);
    on<ProfileLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      return emit(
        state.copyWith(
          status: ProfileStatus.error,
          error: 'User not logged in.',
        ),
      );
    }
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      final userModel = await _authRepository.fetchUserDetails(uid);
      emit(state.copyWith(status: ProfileStatus.loaded, user: userModel));
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          error: 'Failed to fetch profile: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) return;

    emit(state.copyWith(status: ProfileStatus.updating));
    try {
      String? imageUrl;

      if (event.removeImage) {
        imageUrl = ''; 
      } else if (event.imageFile != null) {
        imageUrl = await _authRepository.uploadProfileImage(
          uid,
          event.imageFile!,
        );
      }

      
      await _authRepository.updateUserDetails(
        uid: uid,
        name: event.name,
        phone: event.phone,
        dob: event.dob,
        imageUrl: imageUrl, 
      );

      final updatedUser = await _authRepository.fetchUserDetails(uid);
      emit(state.copyWith(status: ProfileStatus.loaded, user: updatedUser));
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          error: 'Failed to update profile: ${e.toString()}',
        ),
      );
      emit(state.copyWith(status: ProfileStatus.loaded));
    }
  }
}
