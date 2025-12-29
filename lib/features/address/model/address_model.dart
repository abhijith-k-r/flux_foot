import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  final String? id;
  final String fullName;
  final String phoneNumber;
  final String pinCode;
  final String district;
  final String state;
  final String city;
  final String houseNo;
  final String roadAreaColony;
  final String userId;
  final String label;
  final bool isSelected;
  final DateTime createdAt;
  AddressModel({
    this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.pinCode,
    required this.district,
    required this.state,
    required this.city,
    required this.houseNo,
    required this.roadAreaColony,
    required this.userId,
    required this.label,
    required this.isSelected,
    required this.createdAt,
  });

  Map<String, dynamic> toFireStore() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'pinCode': pinCode,
      'district': district,
      'state': state,
      'city': city,
      'houseNo': houseNo,
      'roadAreaColony': roadAreaColony,
      'userId': userId,
      'label': label,
      'isSelected':isSelected,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory AddressModel.fromFirestore(Map<String, dynamic> map, String id) {
    return AddressModel(
      id: id,
      fullName: map['fullName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      pinCode: map['pinCode'] ?? '',
      district: map['district'] ?? '',
      state: map['state'] ?? '',
      city: map['city'] ?? '',
      houseNo: map['houseNo'] ?? '',
      roadAreaColony: map['roadAreaColony'] ?? '',
      userId: map['userId'] ?? '',
      label: map['label'] ?? '',
      isSelected: map['isSelected'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
