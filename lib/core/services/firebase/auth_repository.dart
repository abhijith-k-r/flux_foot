import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluxfoot_user/features/auth/model/usermodel.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<void> updateUserDetails({
    required String uid,
    String? name,
    String? phone,
    String? dob,
    String? imageUrl,
  });

  Future<String> uploadProfileImage(String uid, XFile imageFile);
}
