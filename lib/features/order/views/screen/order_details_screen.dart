// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_backbutton.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/checkout/models/order_model.dart';
import 'package:fluxfoot_user/features/home/views/widgets/review_manager.dart';
import 'package:fluxfoot_user/features/order/views/widgets/order_tracker_vertical.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final primaryColor = const Color(0xFFEE8C2B);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        leading: customBackButton(context),
        title: customText(
          size.width * 0.055,
          'Track Order',
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Brief Card
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: order.productImage.isNotEmpty
                        ? Image.network(
                            order.productImage,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 70,
                            height: 70,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image),
                          ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.productName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Order ID: ${order.id.substring(0, 10).toUpperCase()}",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "₹ ${order.totalAmount}",
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "Order Progress",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // Real-Time Vertical Tracker Widget
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .doc(order.id)
                  .snapshots(),
              builder: (context, snapshot) {
                String currentStatus = order.status; // fallback
                if (snapshot.hasData && snapshot.data!.exists) {
                  currentStatus = snapshot.data!.get('status');
                }
                return OrderTrackerVertical(currentStatus: currentStatus);
              },
            ),

            // Summary Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Delivery Address",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${order.shippingAddress['label'] ?? ''} ${order.shippingAddress['state'] ?? ''} ${order.shippingAddress['district'] ?? ''}  ${order.shippingAddress['city'] ?? ''}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // if (order.status == 'Delivered')
            //   Padding(
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 16.0,
            //       vertical: 8.0,
            //     ),
            //     child: Column(
            //       children: [
            //         SizedBox(
            //           width: double.infinity,
            //           child: ElevatedButton(
            //             style: ElevatedButton.styleFrom(
            //               backgroundColor: Colors.red.shade400,
            //             ),
            //             onPressed: () => _handleReturnOrder(context, order.id),
            //             child: const Text(
            //               'Return Product',
            //               style: TextStyle(color: Colors.white),
            //             ),
            //           ),
            //         ),
            //         const SizedBox(height: 8),
            //         SizedBox(
            //           width: double.infinity,
            //           child: OutlinedButton(
            //             onPressed: () {
            //               // TRIGGER THE RATING POPUP
            //               ReviewManager.showReviewBottomSheet(
            //                 context,
            //                 order.productId,
            //                 order.productName,
            //               );
            //             },
            //             child: const Text('Write a Review'),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // const SizedBox(height: 30),

                        // --- AUTHENTIC RETURN LIFECYCLE TRACKER ---
            if ([
              'Return Requested',
              'Return Approved',
              'Item Returned',
              'Refund Processed',
              'Return Rejected',
            ].contains(order.status))
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: order.status == 'Refund Processed'
                      ? Colors.green.shade50
                      : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: order.status == 'Refund Processed'
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      order.status == 'Refund Processed'
                          ? Icons.check_circle
                          : Icons.info,
                      color: order.status == 'Refund Processed'
                          ? Colors.green
                          : Colors.orange.shade800,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Return Status: ${order.status}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order.status == 'Return Requested'
                                ? "Waiting for Seller Approval"
                                : order.status == 'Return Approved'
                                ? "Approved! Please mail the item back."
                                : order.status == 'Return Rejected'
                                ? "The seller has declined this return."
                                : order.status == 'Item Returned'
                                ? "Seller successfully received the item back. Awaiting Admin Refund processing."
                                : "Your money has been successfully refunded to your original payment method!",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // --- DELIVERED ACTIONS ---
            if (order.status == 'Delivered')
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade400,
                        ),
                        onPressed: () => _handleReturnOrder(context, order.id),
                        child: const Text(
                          'Request Return Product',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          ReviewManager.showReviewBottomSheet(
                            context,
                            order.productId,
                            order.productName,
                          );
                        },
                        child: const Text('Write a Review'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // -- NEW: Dummy Help Button --
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.support_agent),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Opening Live Chat with Seller...'),
                            ),
                          );
                        },
                        label: const Text('Help! Chat with Seller'),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 30),

          ],
        ),
      ),
    );
  }

  // --- NEW: The logic function that updates Firestore for returns ---
  void _handleReturnOrder(BuildContext context, String orderId) {
    TextEditingController reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Return Product"),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(hintText: "Reason for return..."),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              if (reasonController.text.trim().isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('orders')
                    .doc(orderId)
                    .update({
                      'status': 'Return Requested',
                      'returnReason': reasonController.text.trim(),
                      'lastUpdated': FieldValue.serverTimestamp(),
                    });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Return request submitted!")),
                );
              }
            },
            child: const Text("Submit", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
