// Location: fluxfoot_user/lib/features/home/views/widgets/review_manager.dart

// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/features/home/models/review_model.dart';

class ReviewManager {
  static Future<void> showReviewBottomSheet(
    BuildContext context,
    String productId,
    String productName,
  ) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to leave a review.')),
      );
      return;
    }

    // 1. Show quick loading to fetch previous reviews smoothly
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          Center(child: CircularProgressIndicator(color: AppColors.bgOrange)),
    );

    // 2. Fetch if user has existing review
    final query = await FirebaseFirestore.instance
        .collection('reviews')
        .where('productId', isEqualTo: productId)
        .where('userId', isEqualTo: userId)
        .get();

    Navigator.pop(context); // Close loading

    bool isEditing = query.docs.isNotEmpty;
    String? existingReviewId = isEditing ? query.docs.first.id : null;
    final data = isEditing ? query.docs.first.data() : null;

    int selectedRating = isEditing ? (data?['rating'] ?? 5.0).toInt() : 5;
    TextEditingController titleController = TextEditingController(
      text: isEditing ? data!['title'] : '',
    );
    TextEditingController commentController = TextEditingController(
      text: isEditing ? data!['comment'] : '',
    );

    // 3. Open the Input Bottom Sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEditing ? "Edit Your Review" : "Write a Review",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          iconSize: 40,
                          icon: Icon(
                            Icons.star_rounded,
                            color: index < selectedRating
                                ? AppColors.bgOrange
                                : Colors.grey.shade300,
                          ),
                          onPressed: () =>
                              setModalState(() => selectedRating = index + 1),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: "Review Title (e.g. Good Quality)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: commentController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Detailed Feedback",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.bgOrange,
                        ),
                        onPressed: () async {
                          String finalUserName = 'Customer';
                          final userDoc = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userId)
                              .get();
                          if (userDoc.exists &&
                              userDoc.data()?['name'] != null &&
                              userDoc
                                  .data()!['name']
                                  .toString()
                                  .trim()
                                  .isNotEmpty) {
                            finalUserName = userDoc.data()!['name'];
                          }
                          final newReview = ReviewModel(
                            id: existingReviewId ?? '',
                            productId: productId,
                            userId: userId,
                            userName: finalUserName,
                            rating: selectedRating.toDouble(),
                            title: titleController.text.trim(),
                            comment: commentController.text.trim(),
                            timestamp: DateTime.now(),
                          );

                          if (isEditing) {
                            await FirebaseFirestore.instance
                                .collection('reviews')
                                .doc(existingReviewId)
                                .update(newReview.toMap());
                          } else {
                            await FirebaseFirestore.instance
                                .collection('reviews')
                                .add(newReview.toMap());
                          }
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Review Saved!')),
                          );
                        },
                        child: Text(
                          isEditing ? "Update Review" : "Post Review",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (isEditing) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('reviews')
                                .doc(existingReviewId)
                                .delete();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Review Deleted!')),
                            );
                          },
                          child: const Text("Delete Review"),
                        ),
                      ),
                    ],
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
