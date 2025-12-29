import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String userId;
  final String sellerId;
  final double totalAmount;
  final String paymentType; // 'Razorpay' or 'COD'
  final String
  status; // 'Pending', 'Placed', 'Shipped', 'Delivered', 'Return_Requested', 'Refunded'
  final String? paymentId;

  OrderModel({
    required this.id,
    required this.userId,
    required this.sellerId,
    required this.totalAmount,
    required this.paymentType,
    this.status = 'Pending',
    this.paymentId,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'sellerId': sellerId,
    'totalAmount': totalAmount,
    'paymentType': paymentType,
    'status': status,
    'paymentId': paymentId,
    'timestamp': FieldValue.serverTimestamp(),
  };

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) => OrderModel(
    id: id,
    userId: map['userId'],
    sellerId: map['sellerId'],
    totalAmount: map['totalAmount'].toDouble(),
    paymentType: map['paymentType'],
    status: map['status'],
    paymentId: map['paymentId'],
  );
}
