import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/services/firebase/auth_repository.dart';
import 'package:fluxfoot_user/features/auth/model/usermodel.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

const String cloudinaryCoudName = 'dryij9oei';
const String cloudinaryUploadPreset = 'sr_default';

class FirebaseAuthService implements BaseAuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  static String? error;

  static const String _isOnlineField = 'isOnline';

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
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (userCredential.user != null) {
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .update({_isOnlineField: true});
      }
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      log('Eroor in FirebaseAuthServie.SigInUse: $e');
      throw Exception('A problem occurred during account SignIn .');
    }
  }

  @override
  Future<void> signOut() async {
    final user = _firebaseAuth.currentUser;
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          _isOnlineField: false,
        });
      }
    } catch (e) {
      debugPrint('Error during Firebase signOut: $e');
      rethrow;
    }
  }

  @override
  Future<UserModel> fetchUserDetails(String uid) async {
    try {
      // ! Force fetching from server to avoid stale cache issues after update
      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .get(const GetOptions(source: Source.server));

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
            'isOnline': true,
            'createdAt': Timestamp.now(),
          });
        } else {
          await docRef.update({'isOnline': true});
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

  @override
  Future<void> updateUserDetails({
    required String uid,
    String? name,
    String? phone,
    String? dob,
    String? imageUrl,
  }) async {
    final Map<String, dynamic> updates = {};
    if (name != null && name.isNotEmpty) updates['name'] = name.trim();
    if (phone != null) updates['phone'] = phone.trim();
    if (dob != null) updates['dob'] = dob;
    if (imageUrl != null) updates['imageUrl'] = imageUrl;

    if (updates.isNotEmpty) {
      await _firestore.collection('users').doc(uid).update(updates);
    }
  }

  @override
  Future<String> uploadProfileImage(String uid, XFile imageFile) async {
    try {
      final url =
          'https://api.cloudinary.com/v1_1/$cloudinaryCoudName/image/upload';
      final imagePath = imageFile.path;
      final file = File(imagePath);

      final request = http.MultipartRequest('POST', Uri.parse(url))
        ..fields['upload_preset'] = cloudinaryUploadPreset
        ..fields['folder'] =
            'fluxfoot_user_profiles'; // ! Removed public_id to allow Cloudinary to generate a unique random ID for every upload

      final multipartFile = await http.MultipartFile.fromPath(
        'file',
        file.path,
      );
      request.files.add(multipartFile);

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final data = json.decode(responseBody);

      if (response.statusCode == 200 && data['secure_url'] != null) {
        final newImageUrl = data['secure_url'] as String;

        // ! Returning the new URL - The BLoC handles the Firestore update
        return newImageUrl;
      } else {
        log('Cloudinary Error: ${data['error']['message'] ?? 'Upload failed'}');
        throw Exception('Image upload failed on Cloudinary.');
      }
    } catch (e) {
      log('Cloudinary Upload Error: $e');
      throw Exception(
        'Failed to upload image. Check network and configuration.',
      );
    }
  }
}
