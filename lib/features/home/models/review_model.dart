import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final double rating;
  final String title;
  final String comment;
  final DateTime timestamp;

  ReviewModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.title,
    required this.comment,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
    'productId': productId,
    'userId': userId,
    'userName': userName,
    'rating': rating,
    'title': title,
    'comment': comment,
    'timestamp': FieldValue.serverTimestamp(),
  };

  factory ReviewModel.fromMap(Map<String, dynamic> map, String id) =>
      ReviewModel(
        id: id,
        productId: map['productId'] ?? '',
        userId: map['userId'] ?? '',
        userName: map['userName'] ?? 'Anonymous',
        rating: (map['rating'] ?? 0.0).toDouble(),
        title: map['title'] ?? '',
        comment: map['comment'] ?? '',
        timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
}
