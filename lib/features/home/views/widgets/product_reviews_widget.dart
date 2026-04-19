// Location: fluxfoot_user/lib/features/home/views/widgets/product_reviews_widget.dart

// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';

class ProductReviewsWidget extends StatelessWidget {
  final String productId;
  final String description;

  const ProductReviewsWidget({
    super.key,
    required this.productId,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reviews')
          .where('productId', isEqualTo: productId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.bgOrange),
          );
        }

        // We sort locally to entirely avoid missing Firebase Index Crashes
        final docs = snapshot.data!.docs.toList();
        docs.sort((a, b) {
          final aTime =
              (a.data() as Map<String, dynamic>)['timestamp'] as Timestamp?;
          final bTime =
              (b.data() as Map<String, dynamic>)['timestamp'] as Timestamp?;
          if (aTime == null || bTime == null) return 0;
          return bTime.compareTo(aTime);
        });

        int totalReviews = docs.length;
        double sumRating = 0;
        int r5 = 0, r4 = 0, r3 = 0, r2 = 0, r1 = 0;

        // Tally Data mathematically
        for (var doc in docs) {
          final data = doc.data() as Map<String, dynamic>;
          final double rating = (data['rating'] ?? 0.0).toDouble();
          sumRating += rating;
          if (rating >= 4.5) {
            r5++;
          } else if (rating >= 3.5)
            r4++;
          else if (rating >= 2.5)
            r3++;
          else if (rating >= 1.5)
            r2++;
          else
            r1++;
        }

        double avgRating = totalReviews > 0 ? (sumRating / totalReviews) : 0.0;
        String ratingLabel = "No Ratings";
        if (totalReviews > 0) {
          if (avgRating >= 4.5)
            ratingLabel = "Excellent";
          else if (avgRating >= 3.5)
            ratingLabel = "Very Good";
          else if (avgRating >= 2.5)
            ratingLabel = "Good";
          else
            ratingLabel = "Poor";
        }

        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // // Description Section
              // const Text(
              //   "Description",
              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              // ),
              // const SizedBox(height: 8),
              // RichText(
              //   text: TextSpan(
              //     style: const TextStyle(
              //       color: Colors.grey,
              //       fontSize: 14,
              //       height: 1.5,
              //     ),
              //     children: [
              //       TextSpan(text: description),
              //       const TextSpan(
              //         text: ' Read More....',
              //         style: TextStyle(
              //           color: Colors.black,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 30),

              if (totalReviews > 0) ...[
                // Aggregate Box Mirroring the Image
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ratingLabel,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              index < avgRating.round()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: AppColors.bgOrange,
                              size: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${sumRating.toStringAsFixed(0)} rating and\n$totalReviews reviews",
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        children: [
                          _buildProgressBar(
                            "5",
                            r5 / totalReviews,
                            r5.toString(),
                          ),
                          _buildProgressBar(
                            "4",
                            r4 / totalReviews,
                            r4.toString(),
                          ),
                          _buildProgressBar(
                            "3",
                            r3 / totalReviews,
                            r3.toString(),
                          ),
                          _buildProgressBar(
                            "2",
                            r2 / totalReviews,
                            r2.toString(),
                          ),
                          _buildProgressBar(
                            "1",
                            r1 / totalReviews,
                            r1.toString(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Review List Render Engine
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: totalReviews,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return _buildSingleReview(
                      data['rating'].toString(),
                      data['title'] ?? 'Review',
                      data['comment'] ?? '',
                      data['userName'] ?? 'Customer',
                    );
                  },
                ),
              ] else ...[
                const Center(child: Text("No reviews here yet. Be the first!")),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressBar(String star, double percentage, String count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text(
            star,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Icon(Icons.star, color: AppColors.bgOrange, size: 12),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage.isNaN ? 0 : percentage,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.bgOrange),
              minHeight: 6,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 30,
            child: Text(
              count,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleReview(
    String rating,
    String title,
    String subtitle,
    String user,
  ) {
    double parsedRating = double.tryParse(rating) ?? 5.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Row(
                children: List.generate(
                  parsedRating.round(),
                  (index) =>
                      Icon(Icons.star, color: AppColors.bgOrange, size: 16),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "$rating  • $title",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 18),
              const SizedBox(width: 8),
              Text(
                user,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
