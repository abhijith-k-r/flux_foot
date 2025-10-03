import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluxfoot_user/features/auth/model/usermodel.dart';

abstract class BaseAuthRepository {
  Future<void> signIn({required String email, required String password});

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
    required String phone,
  });

  Stream<String?> get user;
  Future<void> signOut();

  Future<UserModel> fetchUserDetails(String uid);

  Future<User?> googleHandleSignIn();
}
