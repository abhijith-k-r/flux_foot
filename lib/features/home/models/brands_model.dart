import 'package:cloud_firestore/cloud_firestore.dart';

class BrandModel {
  final String id;
  final String name;
  final String? logoUrl;
  final String? status;
  final DateTime createdAt;

  BrandModel({
    required this.id,
    required this.name,
    this.logoUrl,
    this.status,
    required this.createdAt,
  });

  factory BrandModel.fromFirestore(Map<String, dynamic> data, String id) {
    return BrandModel(
      id: id,
      name: data['name'] ?? '',
      logoUrl: data['logoUrl'] ?? '',
      status: data['status'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
