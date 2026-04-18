// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class OrderTrackerVertical extends StatelessWidget {
  final String currentStatus;
  final DateTime? orderDate;

  OrderTrackerVertical({super.key, required this.currentStatus, this.orderDate});

  // Define the status sequence
  final List<Map<String, dynamic>> statuses = [
    {'title': 'Order Placed', 'status': 'Placed', 'icon': Icons.receipt_long},
    {'title': 'Processing', 'status': 'Processing', 'icon': Icons.settings_suggest},
    {'title': 'Shipped', 'status': 'Shipped', 'icon': Icons.local_shipping},
    {'title': 'Delivered', 'status': 'Delivered', 'icon': Icons.home_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    // If order is cancelled, show a different view or mark all red
    bool isCancelled = currentStatus == 'Cancelled';
    
    int currentIndex = statuses.indexWhere((s) => s['status'] == currentStatus);
    if (isCancelled) currentIndex = -1;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        children: List.generate(statuses.length, (index) {
          bool isCompleted = index <= currentIndex;
          bool isLast = index == statuses.length - 1;
          bool isActive = index == currentIndex;

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline Line and Icons
                Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isCompleted ? const Color(0xFFEE8C2B) : Colors.grey.shade200,
                        shape: BoxShape.circle,
                        boxShadow: isActive ? [
                          BoxShadow(color: const Color(0xFFEE8C2B).withOpacity(0.3), blurRadius: 10, spreadRadius: 2)
                        ] : [],
                      ),
                      child: Icon(
                        statuses[index]['icon'],
                        size: 16,
                        color: isCompleted ? Colors.white : Colors.grey.shade500,
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: isCompleted ? const Color(0xFFEE8C2B) : Colors.grey.shade300,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                // Status Text
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          statuses[index]['title'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isCompleted ? FontWeight.bold : FontWeight.w500,
                            color: isCompleted ? Colors.black87 : Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isCompleted 
                            ? "Your order has been ${statuses[index]['title'].toLowerCase()}."
                            : "Waiting to be ${statuses[index]['status'].toLowerCase()}...",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
