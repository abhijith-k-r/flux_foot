import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/features/auth/view_model/firebase/auth_repository.dart';
import 'package:fluxfoot_user/features/auth/view_model/auth_bloc/auth_event.dart';
import 'package:fluxfoot_user/features/auth/view_model/auth_bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final BaseAuthRepository _authRepository;
  late final StreamSubscription<String?> _userSubscription;

  AuthBloc({required BaseAuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthInitial()) {
    on<AuthUserChanged>((event, emit) {
      log('AuthUserChanged: userId=${event.userId}, currentState=$state');
      if (event.userId != null) {
        emit(AuthAuthenticated(event.userId!));
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<AuthLogoutRequested>(_onLogoutRequested);

    on<AuthStatusCheckRequested>((event, emit) {
      final user = FirebaseAuth.instance.currentUser;
      log('AuthStatusCheckRequested: userId=${user?.uid}, currentState=$state');
      if (user != null) {
        emit(AuthAuthenticated(user.uid));
      } else {
        emit(AuthUnauthenticated());
      }
    });

    _userSubscription = _authRepository.user.listen(
      (userId) {
        log('User stream emitted: userId=$userId');
        add(AuthUserChanged(userId));
      },
      onError: (error) {
        log('User stream error: $error');
        add(AuthUserChanged(null));
      },
    );

    add(AuthStatusCheckRequested());
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      await _authRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      log('Logout error: $e');
      emit(const AuthError('Logout failed. Please try again.'));
      emit(AuthUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    log('Closing AuthBloc, cancelling user subscription');
    _userSubscription.cancel();
    return super.close();
  }
}
