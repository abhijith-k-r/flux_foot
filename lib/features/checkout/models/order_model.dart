import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String userId;
  final String sellerId;
  final String productId;
  final String productName;
  final String productImage;
  final int quantity;
  final double totalAmount;
  final String paymentType; 
  final String status; 
  final String? paymentId;
  final Map<String, dynamic> shippingAddress;
  final DateTime? timestamp;

  OrderModel({
    required this.id,
    required this.userId,
    required this.sellerId,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.totalAmount,
    required this.paymentType,
    this.status = 'Placed',
    this.paymentId,
    required this.shippingAddress,
    this.timestamp,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'sellerId': sellerId,
    'productId': productId,
    'productName': productName,
    'productImage': productImage,
    'quantity': quantity,
    'totalAmount': totalAmount,
    'paymentType': paymentType,
    'status': status,
    'paymentId': paymentId,
    'shippingAddress': shippingAddress,
    'timestamp': FieldValue.serverTimestamp(),
  };

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) => OrderModel(
    id: id,
    userId: map['userId'] ?? '',
    sellerId: map['sellerId'] ?? '',
    productId: map['productId'] ?? '',
    productName: map['productName'] ?? 'Unknown Product',
    productImage: map['productImage'] ?? '',
    quantity: map['quantity'] ?? 1,
    totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
    paymentType: map['paymentType'] ?? 'COD',
    status: map['status'] ?? 'Placed',
    paymentId: map['paymentId'],
    shippingAddress: Map<String, dynamic>.from(map['shippingAddress'] ?? {}),
    timestamp: (map['timestamp'] as Timestamp?)?.toDate(),
  );
}
