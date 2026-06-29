//! --- NEW: The logic function that updates Firestore for returns ---
// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void handleReturnOrder(BuildContext context, String orderId) {
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
