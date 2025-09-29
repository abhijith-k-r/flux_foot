import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluxfoot_user/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.photoURL,
    super.password,
    super.phone,
    required super.createdAt,
  });

  factory UserModel.fromFirebaseUser(
    firebase_auth.User firebaseUser, {
    String? disaplayName,
    String? phone,
    String? password,
  }) {
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email!,
      displayName: disaplayName ?? firebaseUser.displayName,
      photoURL: firebaseUser.photoURL,
      password: password ?? 'NO_PASSWORD_SUPPLIED',
      phone: phone,
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
    );
  }

  factory UserModel.fromjson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      displayName: json['displayName'],
      photoURL: json['photoURL'],
      password: json['password'],
      phone: json['phone'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'password': password,
      'phone': phone,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
