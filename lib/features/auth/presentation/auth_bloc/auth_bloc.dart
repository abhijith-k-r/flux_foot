import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/firebase/auth/auth_repository.dart';
import 'package:fluxfoot_user/features/auth/presentation/auth_bloc/auth_event.dart';
import 'package:fluxfoot_user/features/auth/presentation/auth_bloc/auth_state.dart';




class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final BaseAuthRepository _authRepository;
  late final StreamSubscription<String?> _userSubscription;

  AuthBloc({required BaseAuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthInitial()) {
    _userSubscription = _authRepository.user.listen(
      (userId) => add(AuthUserChanged(userId)),
    );

    on<AuthUserChanged>((event, emit) {
      if (event.userId != null) {
        emit(AuthAuthenticated(event.userId!));
      } else {
        if (state is! AuthInitial) {
          emit(AuthUnauthenticated());
        }
      }
    });

    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      await _authRepository.signOut();
    } catch (e) {
      emit(const AuthError('Logout failed. Please try again.'));
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
