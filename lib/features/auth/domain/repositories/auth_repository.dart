import 'package:fluxfoot_user/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
  });

  Future<User> signIn({required String email, required String password});

  Future<User> signInWithGoogle();

  Future<void> signOut();

  Future<void> sendPasswordResetEmail({required String email});

  Stream<User?> get authStateChanges;

  User? get currentUser;
}
