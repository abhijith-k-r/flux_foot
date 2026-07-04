// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/features/checkout/models/order_model.dart';
import 'package:fluxfoot_user/features/order/views/screen/order_details_screen.dart';



Widget buildOrderList(BuildContext context, {required bool isOngoing}) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return const Center(child: Text("Please log in to see your orders."));
    }

    return StreamBuilder<QuerySnapshot>(
      // Listen to the user's orders instantly
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.bgOrange),
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No orders found.'));
        }

        // Filter the list based on the Tab we are in
        final allOrders = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return OrderModel.fromMap(data, doc.id);
        }).toList();

        final filteredOrders = allOrders.where((order) {
          // Hide corrupted tester data
          if (order.productName == 'Unknown Product' || order.productId.isEmpty) {
            return false;
          }

          final ongoingStatuses = ['Placed', 'Processing', 'Shipped', 'Paid'];
          if (isOngoing) {
            return ongoingStatuses.contains(order.status);
          } else {
            return !ongoingStatuses.contains(
              order.status,
            ); // Delivered, Cancelled
          }
        }).toList();

        if (filteredOrders.isEmpty) {
          return Center(
            child: Text(
              isOngoing ? 'No ongoing orders.' : 'No completed orders.',
            ),
          );
        }

        return ListView.builder(
          itemCount: filteredOrders.length,
          itemBuilder: (context, index) {
            final order = filteredOrders[index];
            return _buildOrderCard(context, order);
          },
        );
      },
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    const primaryColor = Color(0xFFEE8C2B);

    return InkWell(
      onTap: () {
        // NAVIGATE TO TRACKING SCREEN
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => OrderDetailsScreen(order: order)),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: order.productImage.isNotEmpty
                    ? Image.network(
                        order.productImage,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image),
                      ),
              ),
              const SizedBox(width: 16),
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: getStatusColor(order.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        order.status,
                        style: TextStyle(
                          color: getStatusColor(order.status),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹ ${order.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Placed':
      case 'Paid':
        return Colors.blue;
      case 'Processing':
        return Colors.orange;
      case 'Shipped':
        return Colors.amber;
      case 'Delivered':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
