// lib/features/chat/models/message_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String text;
  final DateTime timestamp;
  final String type; // 'text', 'image'
  final bool isRead;

  final String? id; // Document ID from Firestore

  MessageModel({
    this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.type = 'text',
    this.isRead = false,
  });

  Map<String, dynamic> toMap() => {
    'senderId': senderId,
    'text': text,
    'timestamp': FieldValue.serverTimestamp(),
    'type': type,
    'isRead': isRead,
  };

  factory MessageModel.fromMap(Map<String, dynamic> map, String id) => MessageModel(
    id: id,
    senderId: map['senderId'] ?? '',
    text: map['text'] ?? '',
    timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    type: map['type'] ?? 'text',
    isRead: map['isRead'] ?? false,
  );
}
