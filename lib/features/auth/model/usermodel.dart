class UserModel {
  final String uid;
  final String? imageUrl;
  final String name;
  final String email;
  final String phone;
  final String? dob;

  UserModel({
    required this.uid,
    this.imageUrl,
    required this.name,
    required this.email,
    required this.phone,
    this.dob,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      imageUrl: map['imageUrl'] as String?,
      dob: map['dob'] as String?,
    );
  }

  UserModel copyWith({String? uid,
    String? imageUrl,
    String? name,
    String? email,
    String? phone,
    String? dob,}){
      return UserModel(
      uid: uid ?? this.uid,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dob: dob ?? this.dob,
    );
    }
}
