// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_backbutton.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/services/chat/chat_service.dart';
import 'package:fluxfoot_user/features/chat/model/message_model.dart';
import 'package:fluxfoot_user/features/checkout/models/order_model.dart';

class ChatScreen extends StatefulWidget {
  final OrderModel order;
  final String chatId;
  const ChatScreen({super.key, required this.order, required this.chatId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  final Color primaryColor = AppColors.bgOrangeAccent;

  final Color backgroundColor = const Color(0xFFF8F9FF);

  final Color sellerBubbleColor = const Color(0xFFE0E3E5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        leading: customBackButton(context),
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chats')
              .doc(widget.chatId)
              .snapshots(),
          builder: (context, snapshot) {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('sellers')
                  .doc(widget.order.sellerId)
                  .get(),
              builder: (context, sellerSnapshot) {
                String sellerName = "Seller";

                // Priority 1: From chat document
                if (snapshot.hasData && snapshot.data!.exists) {
                  final data = snapshot.data!.data() as Map<String, dynamic>?;
                  if (data?['sellerName'] != null) {
                    sellerName = data!['sellerName'];
                  } else if (sellerSnapshot.hasData &&
                      sellerSnapshot.data!.exists) {
                    // Priority 2: From sellers collection
                    final sellerData =
                        sellerSnapshot.data!.data() as Map<String, dynamic>?;
                    sellerName = sellerData?['store name'] ?? "Seller";
                  }
                } else if (sellerSnapshot.hasData &&
                    sellerSnapshot.data!.exists) {
                  final sellerData =
                      sellerSnapshot.data!.data() as Map<String, dynamic>?;
                  sellerName = sellerData?['store name'] ?? "Seller";
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Seller: $sellerName",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Order: #${widget.order.id.substring(0, 8).toUpperCase()} | ${widget.order.productName}",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),

      // AppBar(
      //   backgroundColor: Colors.black,
      //   elevation: 0,
      //   leading: customBackButton(context),
      //   title: StreamBuilder<DocumentSnapshot>(
      //     stream: FirebaseFirestore.instance
      //         .collection('chats')
      //         .doc(widget.chatId)
      //         .snapshots(),
      //     builder: (context, snapshot) {
      //       return FutureBuilder<DocumentSnapshot>(
      //         future: FirebaseFirestore.instance
      //             .collection('sellers')
      //             .doc(widget.order.sellerId)
      //             .get(),
      //         builder: (context, sellerSnapshot) {
      //           String sellerName = "Seller";

      //           // Priority 1: From chat document
      //           if (snapshot.hasData && snapshot.data!.exists) {
      //             final data = snapshot.data!.data() as Map<String, dynamic>?;
      //             if (data?['sellerName'] != null) {
      //               sellerName = data!['sellerName'];
      //             } else if (sellerSnapshot.hasData &&
      //                 sellerSnapshot.data!.exists) {
      //               // Priority 2: From sellers collection
      //               final sellerData =
      //                   sellerSnapshot.data!.data() as Map<String, dynamic>?;
      //               sellerName = sellerData?['store name'] ?? "Seller";
      //             }
      //           } else if (sellerSnapshot.hasData &&
      //               sellerSnapshot.data!.exists) {
      //             final sellerData =
      //                 sellerSnapshot.data!.data() as Map<String, dynamic>?;
      //             sellerName = sellerData?['store name'] ?? "Seller";
      //           }

      //           return Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Text(
      //                 "Seller: $sellerName",
      //                 style: TextStyle(
      //                   color: primaryColor,
      //                   fontSize: 15,
      //                   fontWeight: FontWeight.bold,
      //                 ),
      //               ),
      //               Text(
      //                 "Order: #${widget.order.id.substring(0, 8).toUpperCase()} | ${widget.order.productName}",
      //                 style: TextStyle(
      //                   color: Colors.grey.shade600,
      //                   fontSize: 11,
      //                 ),
      //                 overflow: TextOverflow.ellipsis,
      //               ),
      //             ],
      //           );
      //         },
      //       );
      //     },
      //   ),
      //   // actions: [
      //   //   Container(
      //   //     margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
      //   //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      //   //     decoration: BoxDecoration(
      //   //       color: Colors.green.shade100,
      //   //       borderRadius: BorderRadius.circular(20),
      //   //     ),
      //   //     child: Text(
      //   //       widget.order.status.toUpperCase(),
      //   //       style: TextStyle(
      //   //         color: Colors.green.shade800,
      //   //         fontSize: 10,
      //   //         fontWeight: FontWeight.bold,
      //   //       ),
      //   //     ),
      //   //   ),
      //   // ],
      // ),
      body: Column(
        children: [
          Expanded(
            child: _buildChatFeed(widget.chatId),

            //  ListView(
            //   padding: const EdgeInsets.all(16),
            //   children: [
            //     _buildProductContextCard(),
            //     const SizedBox(height: 24),
            //     _buildDateSeparator("Today"),
            //     const SizedBox(height: 24),
            //     _buildMessageBubble(
            //       "Hello! How can I help you with your order today?",
            //       "10:42 AM",
            //       context,
            //       isMe: false,
            //     ),
            //     _buildMessageBubble(
            //       "Hi, I just received my shoes but they seem to be the wrong size.",
            //       "10:44 AM",
            //       context,
            //       isMe: true,
            //     ),
            //     _buildMessageBubble(
            //       "I'm sorry to hear that. Could you please send a photo of the size tag?",
            //       "10:45 AM",
            //       context,
            //       isMe: false,
            //     ),
            //     _buildSuggestionChips(),
            //   ],
            // ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  final ChatService _chatService = ChatService();

  // 2. Update the ListView with a StreamBuilder
  Widget _buildChatFeed(String chatId) {
    return StreamBuilder<List<MessageModel>>(
      stream: _chatService.getMessages(chatId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final messages = snapshot.data ?? [];

        if (messages.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline, size: 50, color: Colors.grey),
                const SizedBox(height: 10),
                const Text("No messages yet. Send a message to start!"),
              ],
            ),
          );
        }

        return ListView.builder(
          reverse: true, // Start from bottom
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final msg = messages[index];
            return GestureDetector(
              onLongPress: msg.senderId == currentUserId
                  ? () => _showDeleteDialog(msg.id!)
                  : null,
              child: _buildMessageBubble(
                msg.text,
                DateFormat('hh:mm a').format(msg.timestamp),
                context,
                isMe: msg.senderId == currentUserId,
              ),
            );
          },
        );
      },
    );
  }

  // Widget _buildProductContextCard() {
  //   return Center(
  //     child: Container(
  //       padding: const EdgeInsets.all(12),
  //       decoration: BoxDecoration(
  //         color: AppColors.textWite,
  //         borderRadius: BorderRadius.circular(12),
  //         border: Border.all(color: Colors.grey.shade200),
  //         boxShadow: [
  //           BoxShadow(
  //             color: AppColors.bgBlack.withOpacity(0.05),
  //             blurRadius: 5,
  //           ),
  //         ],
  //       ),
  //       child: Row(
  //         children: [
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(8),
  //             child: Image.network(
  //               widget.order.productImage,
  //               width: 60,
  //               height: 60,
  //               fit: BoxFit.cover,
  //             ),
  //           ),
  //           const SizedBox(width: 12),
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   widget.order.productName,
  //                   style: const TextStyle(fontWeight: FontWeight.bold),
  //                 ),
  //                 Text(
  //                   "Size: 10.5 | ₹${widget.order.totalAmount}",
  //                   style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           TextButton(
  //             onPressed: () {},
  //             child: Text(
  //               "View",
  //               style: TextStyle(
  //                 color: primaryColor,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildMessageBubble(
    String text,
    String time,
    BuildContext context, {
    required bool isMe,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMe ? primaryColor : sellerBubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMe ? 16 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 16),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                time,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
              ),
              if (isMe) ...[
                const SizedBox(width: 4),
                Icon(Icons.done_all, size: 14, color: primaryColor),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildDateSeparator(String label) {
  //   return Center(
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  //       decoration: BoxDecoration(
  //         color: Colors.grey.shade100,
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       child: Text(
  //         label.toUpperCase(),
  //         style: TextStyle(
  //           color: Colors.grey.shade600,
  //           fontSize: 11,
  //           letterSpacing: 1.2,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildSuggestionChips() {
  //   return Wrap(
  //     spacing: 8,
  //     children: [_chipButton("Take Photo"), _chipButton("Upload from Gallery")],
  //   );
  // }

  // Widget _chipButton(String label) {
  //   return OutlinedButton(
  //     onPressed: () {},
  //     style: OutlinedButton.styleFrom(
  //       shape: StadiumBorder(),
  //       side: BorderSide(color: Colors.grey.shade300),
  //     ),
  //     child: Text(
  //       label,
  //       style: TextStyle(color: Colors.grey.shade800, fontSize: 13),
  //     ),
  //   );
  // }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {},
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: "Type a message...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () async {
                if (_messageController.text.trim().isNotEmpty) {
                  final newMessage = MessageModel(
                    senderId: currentUserId,
                    text: _messageController.text.trim(),
                    timestamp: DateTime.now(),
                  );
                  String text = _messageController.text;
                  _messageController.clear();

                  try {
                    // Fetch real names to save in chat doc
                    final userDoc = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(currentUserId)
                        .get();
                    final sellerDoc = await FirebaseFirestore.instance
                        .collection('sellers')
                        .doc(widget.order.sellerId)
                        .get();

                    String customerName = userDoc.data()?['name'] ?? "User";
                    String sellerName =
                        sellerDoc.data()?['store name'] ?? "Seller";

                    await _chatService.sendMessage(
                      chatId: widget.chatId,
                      message: newMessage,
                      sellerId: widget.order.sellerId,
                      userId: currentUserId,
                      productName: widget.order.productName,
                      customerName: customerName,
                      sellerName: sellerName,
                    );
                  } catch (e) {
                    _messageController.text = text;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error sending message: $e")),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(String messageId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Message?"),
        content: const Text("Are you sure you want to delete this message?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _chatService.deleteMessage(widget.chatId, messageId);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
