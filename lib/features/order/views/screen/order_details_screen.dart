import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_backbutton.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/checkout/models/order_model.dart';
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
                        ? Image.network(order.productImage, width: 70, height: 70, fit: BoxFit.cover)
                        : Container(width: 70, height: 70, color: Colors.grey.shade300, child: const Icon(Icons.image)),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(order.productName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("Order ID: ${order.id.substring(0, 10).toUpperCase()}", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                        const SizedBox(height: 5),
                        Text("₹ ${order.totalAmount}", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text("Order Progress", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            // Real-Time Vertical Tracker Widget
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('orders').doc(order.id).snapshots(),
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
                    const Text("Delivery Address", style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(
                      "${order.shippingAddress['addressLine1'] ?? ''}, ${order.shippingAddress['city'] ?? ''}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
