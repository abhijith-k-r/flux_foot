import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/firebase/auth/auth_repository.dart';
import 'package:fluxfoot_user/features/auth/model/usermodel.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService implements BaseAuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  static String? error;

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
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint('Error during Firebase signOut: $e');
      rethrow;
    }
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

  // ! Google Sign In
  @override
  Future<User?> googleHandleSignIn() async {
    try {
      await _googleSignIn.initialize(
        serverClientId:
            "207851949341-v3c0of4infl3i9lsckjptddbf9g4uadu.apps.googleusercontent.com",
      );

      final account = await _googleSignIn.authenticate();

      final auth = account.authentication;
      final credential = GoogleAuthProvider.credential(idToken: auth.idToken);
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      final user = userCredential.user;

      if (user != null) {
        final String uid = user.uid;

        final docRef = _firestore.collection('users').doc(uid);
        final doc = await docRef.get();

        if (!doc.exists) {
          await docRef.set({
            'uid': uid,
            'name': user.displayName ?? 'Google User',
            'email': user.email ?? '',
            'phone': user.phoneNumber ?? '',
            'status': 'verified',
            'createdAt': Timestamp.now(),
          });
        }
      }
      return user;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        error = 'Sign-in Cancelled by user';
      } else {
        error = 'Error (${e.code}): ${e.description}';
        log(error.toString());
        return null;
      }
    } catch (e) {
      error = 'Unexpected error: $e';
      log(error.toString());
    }
    return null;
  }
}
