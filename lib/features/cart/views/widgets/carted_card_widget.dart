// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/features/cart/view_model/bloc/cart_bloc.dart';
import 'package:fluxfoot_user/features/cart/views/widgets/cart_quantity_button.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';

// ! Carted Items as Card
class CartItemCard extends StatelessWidget {
  final ProductModel product;
  final double size;

  const CartItemCard({super.key, required this.product, required this.size});

  @override
  Widget build(BuildContext context) {
    // Parse prices safely
    final salePrice = product.salePrice;
    final regularPrice = product.regularPrice;
    final price = salePrice > 0 ? salePrice : regularPrice;
    final quantity = product.quantity;

    // Get variant info if available
    String variantSize = 'N/A';
    String variantColor = 'N/A';
    String? variantImage;

    if (product.variants.isNotEmpty) {
      final variant = product.variants.first;
      if (variant.sizes.isNotEmpty) {
        variantSize = variant.sizes.first.size;
      }
      variantColor = variant.colorName;
      // Get image
      if (variant.imageUrls.isNotEmpty) {
        variantImage = variant.imageUrls.first;
      }
    }

    // Get image URL
    final imageUrl =
        variantImage ??
        (product.images.isNotEmpty ? product.images.first : null);

    return Dismissible(
      key: Key(product.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.delete_outline, color: Colors.white, size: 32),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Remove Item'),
              content: Text('Remove ${product.name} from cart?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('REMOVE', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        context.read<CartBloc>().add(RemoveFromCartEvent(product: product));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} removed from cart'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.bgWhite,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ! Product Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image,
                            size: 40,
                            color: Colors.grey,
                          );
                        },
                      ),
                    )
                  : Icon(Icons.shopping_bag, size: 40, color: Colors.grey),
            ),
            SizedBox(width: 12),

            // ! Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Size: $variantSize • Color: $variantColor',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Quantity Controls
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors.bgGrey.withOpacity(0.3),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            QuantityButton(
                              icon: Icons.remove,
                              onTap: () {
                                if (quantity > 1) {
                                  context.read<CartBloc>().add(
                                    UpdateCartQuantityEvent(
                                      product: product,
                                      quantity: quantity - 1,
                                    ),
                                  );
                                } else {
                                  context.read<CartBloc>().add(
                                    RemoveFromCartEvent(product: product),
                                  );
                                }
                              },
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                '$quantity',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            QuantityButton(
                              icon: Icons.add,
                              onTap: () {
                                context.read<CartBloc>().add(
                                  UpdateCartQuantityEvent(
                                    product: product,
                                    quantity: quantity + 1,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      // Price
                      Text(
                        '₹${(price * quantity).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ! Delete Icon (visible, triggers swipe behavior)
            SizedBox(width: 4),
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red[300]),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Remove Item'),
                      content: Text('Remove ${product.name} from cart?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(
                            'REMOVE',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );

                if (confirm == true) {
                  context.read<CartBloc>().add(
                    RemoveFromCartEvent(product: product),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} removed from cart'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}
