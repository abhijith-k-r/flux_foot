import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluxfoot_user/core/firebase/auth/auth_repository.dart';
import 'package:fluxfoot_user/features/auth/model/usermodel.dart';

class FirebaseAuthService implements BaseAuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAuthService(this._firebaseAuth);

  @override
  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      if (userCredential.user != null) {
        final String uid = userCredential.user!.uid;

        await _firestore.collection('users').doc(uid).set({
          'uid': uid,
          'name': name.trim(),
          'email': email.trim(),
          'password': password.trim(),
          'phone': phone.trim(),
          'status': 'pending',
          'createdAt': Timestamp.now(),
        });
      }
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      log('Eroor in FirebaseAuthServie.SigUpUse: $e');
      throw Exception(
        'A problem occurred during account creation or data storage.',
      );
    }
  }

  @override
  Stream<String?> get user {
    return _firebaseAuth.authStateChanges().map((user) {
      return user?.uid;
    });
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      log('Eroor in FirebaseAuthServie.SigInUse: $e');
      throw Exception('A problem occurred during account SignIn .');
    }
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future<UserModel> fetchUserDetails(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists || doc.data() == null) {
        log('User data document not found for UID: $uid');
        throw Exception('User profile data not found.');
      }
      return UserModel.fromMap(doc.data()!);
    } on FirebaseException catch (e) {
      log('Firebase Error fetching user details: ${e.message}');
      rethrow;
    } catch (e) {
      log('General Error fetching user details: $e');
      throw Exception('Failed to retrieve user profile data.');
    }
  }
}
