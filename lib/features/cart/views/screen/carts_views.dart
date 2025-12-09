import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/cart/view_model/bloc/cart_bloc.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';



class CartsViews extends StatelessWidget {
  const CartsViews({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        title: customText(
          size,
          'Shopping Cart',
          style: GoogleFonts.rozhaOne(fontSize: size * 0.07),
        ),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text('Error: ${state.error}'));
          }

          final cartProducts = state.cartProducts;

          if (cartProducts.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'Flux_Foot/assets/images/lottie/Carrinho De Compras.json',
                ),
                SizedBox(height: 20),
                customText(size * 0.05, 'No Cart Added yet!'),
              ],
            );
          }

          // Calculate totals
          double subtotal = 0;
          for (var product in cartProducts) {
            final salePrice = product.salePrice;
            final regularPrice = product.regularPrice;
            final price = salePrice > 0 ? salePrice : regularPrice;
            final quantity = product.quantity;
            subtotal += price * quantity;
          }

          double discount = subtotal * 0.1; // 10% discount
          double shippingFee = 0; // Free shipping
          double total = subtotal - discount + shippingFee;

          return Column(
            children: [
              // Cart Items List
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(size * 0.04),
                  itemCount: cartProducts.length,
                  itemBuilder: (context, index) {
                    final product = cartProducts[index];
                    return _CartItemCard(product: product, size: size);
                  },
                ),
              ),

              // Bottom Checkout Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(size * 0.04),
                child: Column(
                  children: [
                    _PriceRow(
                      label: 'Subtotal (${cartProducts.length} items)',
                      value: '₹${subtotal.toStringAsFixed(2)}',
                    ),
                    SizedBox(height: 8),
                    _PriceRow(
                      label: 'Discount',
                      value: '₹${discount.toStringAsFixed(2)}',
                    ),
                    SizedBox(height: 8),
                    _PriceRow(
                      label: 'Shipping fee',
                      value: '₹${shippingFee.toStringAsFixed(2)}',
                    ),
                    Divider(height: 24, thickness: 1),
                    _PriceRow(
                      label: 'Total',
                      value: '₹${total.toStringAsFixed(2)}',
                      isBold: true,
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                         
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.bgOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Make a Purchase',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final ProductModel product;
  final double size;

  const _CartItemCard({required this.product, required this.size});

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
        variantSize = variant.sizes.first.toString();
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
          color: Colors.red[400],
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
        context.read<CartBloc>().add(
          RemoveFromCartEvent(product: product),
        );

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
          color: Colors.white,
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
            // Product Image
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

            // Product Details
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
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _QuantityButton(
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
                            _QuantityButton(
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

            // Delete Icon (visible, triggers swipe behavior)
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

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(padding: EdgeInsets.all(8), child: Icon(icon, size: 18)),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? Colors.black : Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// End of file
