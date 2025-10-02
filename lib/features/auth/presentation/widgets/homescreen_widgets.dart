// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

// Updated ProductGridView without Scaffold (since it's already inside HomeScreen's Scaffold)
class ProductGridView extends StatelessWidget {
  const ProductGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return ProductCard(
          productName: getProductName(index),
          rating: getRating(index),
          price: getPrice(index),
          originalPrice: getOriginalPrice(index),
          color: getProductColor(index),
        );
      },
    );
  }
}

String getProductName(int index) {
  switch (index) {
    case 0:
      return "Adidas sports boots";
    case 1:
      return "Nike football";
    case 2:
      return "Puma shin pad";
    case 3:
      return "Reebok jersey";
    default:
      return "Product";
  }
}

double getRating(int index) {
  switch (index) {
    case 0:
      return 4.9;
    case 1:
      return 4.6;
    case 2:
      return 4.1;
    case 3:
      return 4.1;
    default:
      return 4.0;
  }
}

int getPrice(int index) {
  switch (index) {
    case 0:
      return 16;
    case 1:
      return 20;
    case 2:
      return 10;
    case 3:
      return 10;
    default:
      return 10;
  }
}

int getOriginalPrice(int index) {
  switch (index) {
    case 0:
      return 32;
    case 1:
      return 42;
    case 2:
      return 15;
    case 3:
      return 15;
    default:
      return 15;
  }
}

Color getProductColor(int index) {
  switch (index) {
    case 0:
      return Colors.blue;
    case 1:
      return Colors.black;
    case 2:
      return Colors.orange;
    case 3:
      return Colors.orange;
    default:
      return Colors.grey;
  }
}

class ProductCard extends StatelessWidget {
  final String productName;
  final double rating;
  final int price;
  final int originalPrice;
  final Color color;

  const ProductCard({
    super.key,
    required this.productName,
    required this.rating,
    required this.price,
    required this.originalPrice,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top section with image and heart icon
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  // Product Image (using CircleAvatar as requested)
                  Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: color.withOpacity(0.2),
                      child: Icon(getProductIcon(), size: 40, color: color),
                    ),
                  ),
                  // Heart icon
                  Positioned(
                    top: 0,
                    right: 0,
                    // child: Container(
                    //   padding: EdgeInsets.all(8),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     shape: BoxShape.circle,
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.grey.withOpacity(0.2),
                    //         spreadRadius: 1,
                    //         blurRadius: 4,
                    //         offset: Offset(0, 2),
                    //       ),
                    //     ],
                    //   ),
                    child: Icon(
                      Icons.favorite_border,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom section with product details
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Product name
                  Text(
                    productName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Rating
                  Row(
                    children: [
                      Text(
                        'rating ',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        rating.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  // Price section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            '\$$price',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '\$$originalPrice',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                      // Shopping cart icon
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.shopping_cart,
                          size: 16,
                          color: Colors.white
                          
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData getProductIcon() {
    if (productName.contains("boots")) return Icons.sports_soccer;
    if (productName.contains("football")) return Icons.sports_soccer;
    if (productName.contains("shin pad")) return Icons.security;
    if (productName.contains("jersey")) return Icons.sports;
    return Icons.shopping_bag;
  }
}
