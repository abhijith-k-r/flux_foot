import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/firebase/auth/auth_repository.dart';
import 'package:fluxfoot_user/features/auth/presentation/bloc/user_event.dart';
import 'package:fluxfoot_user/features/auth/presentation/bloc/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final BaseAuthRepository _authRepository;
  UserBloc({required BaseAuthRepository authRepository})
    : _authRepository = authRepository,
      super(UserInitial()) {
    on<UserProfileRequested>(_onUserProfileRequested);
  }

  Future<void> _onUserProfileRequested(
    UserProfileRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final userModel = await _authRepository.fetchUserDetails(event.uid);
      emit(UseerLoaded(userModel));
      debugPrint('User Fetched');
    } catch (e) {
      emit(UserError('Failed to load user profile: $e'));
    }
  }
}
