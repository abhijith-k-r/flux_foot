
//! --- Shimmer Loading Content (Skeleton) ---
import 'package:flutter/material.dart';
import 'package:fluxfoot_user/core/widgets/shimmer_widgets.dart';

Widget buildShimmerHomeContent(BuildContext context, double size) {
  return SingleChildScrollView(
    physics:
        const NeverScrollableScrollPhysics(), // Disable scrolling on shimmer
    child: Column(
      children: [
        // ! Main Banner Shimmer
        ShimmerPlaceholder(
          width: size * 0.99,
          height: size * 0.4,
          borderRadius: 25,
        ),
        SizedBox(height: size * 0.01),
        // ! Brand List Shimmer
        Column(
          children: [
            // Brand Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const ShimmerPlaceholder(
                  width: 120,
                  height: 20,
                ), // "Search by brands"
                const ShimmerPlaceholder(width: 60, height: 20), // "View All"
              ],
            ),
            SizedBox(height: size * 0.02),
            // Horizontal List of Brand Shimmers
            SizedBox(
              width: double.infinity,
              height: size * 0.19,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5, // Show 5 fake items
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(size * 0.02),
                    child: ShimmerBrandItem(size: size),
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(height: size * 0.03),
        // ! Featured Products Shimmer
        Column(
          children: [
            // Featured Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const ShimmerPlaceholder(
                  width: 140,
                  height: 20,
                ), // "Featured Product"
                const ShimmerPlaceholder(width: 60, height: 20), // "View All"
              ],
            ),
            SizedBox(height: size * 0.02),
            // Product Grid Shimmer
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 0.85,
              ),
              itemCount: 4, // Show 4 fake products
              itemBuilder: (context, index) {
                return ShimmerProductCard(size: size);
              },
            ),
          ],
        ),
      ],
    ),
  );
}
