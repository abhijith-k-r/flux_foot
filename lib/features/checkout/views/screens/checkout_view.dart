// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_snackbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/address/views/screens/shipping_address_view.dart';
import 'package:fluxfoot_user/features/checkout/view_model/bloc/checkout_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = Color(0xFFEE8C2B);
    final size = MediaQuery.of(context).size.width;

    return BlocListener<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
        if (state.status == CheckoutStatus.noAddress) {
          customSnackBar(
            context,
            "Please select a shipping address",
            CupertinoIcons.location_solid,
            AppColors.bgOrangeAccent,
          );
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          leading: const BackButton(),
          title: customText(
            size * 0.065,
            'Checkout',
            fontWeight: FontWeight.w600,
          ),
        ),

        body: BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (context, state) {
            if (state.status == CheckoutStatus.loading) {
              return Center(
                child: LoadingAnimationWidget.hexagonDots(
                  color: AppColors.bgOrangeAccent,
                  size: size * 0.2,
                ),
              );
            }
            if (state.status == CheckoutStatus.failure) {
              return Center(child: Text("Error: ${state.errorMessage}"));
            }
            final products = state.products;
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Items Section
                      if (products.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 16),
                          child: Text(
                            'Items (${products.length})',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // ! Product items
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            // Safely get variant info
                            String imageUrl = '';
                            if (product.images.isNotEmpty) {
                              imageUrl = product.images.first;
                            }
                            String variantSubtitle = '';
                            if (product.variants.isNotEmpty) {
                              variantSubtitle =
                                  product.variants.first.colorName;
                            }
                            String size = '';
                            if (product.variants.isNotEmpty) {
                              size = product.variants.first.sizes.first.size;
                            }
                            return buildProductItem(
                              isDark: isDark,
                              imageUrl: imageUrl,
                              title: product.name,
                              subtitle: variantSubtitle,
                              quantity: product.quantity,
                              price: '₹${product.salePrice.toStringAsFixed(2)}',
                              size: size,
                            );
                          },
                          separatorBuilder: (_, __) =>
                              SizedBox(height: size * 0.01),
                        ),
                        SizedBox(height: size * 0.04),
                      ],

                      // ! Shipping Address (Dynamic)
                      buildInfoCard(
                        isDark: isDark,
                        icon: Icons.local_shipping_outlined,
                        title: 'Shipping Address',
                        content: state.selectedAddress != null
                            ? '${state.selectedAddress!.fullName}\n'
                                  '${state.selectedAddress!.houseNo}, ${state.selectedAddress!.roadAreaColony}\n'
                                  '${state.selectedAddress!.city}, ${state.selectedAddress!.state} - ${state.selectedAddress!.pinCode}'
                            : 'No Address Selected',
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ShippingAddressView(),
                            ),
                          ).then((_) {
                            if (state.products.isNotEmpty || state.total > 0) {
                              context.read<CheckoutBloc>().add(
                                LoadCheckoutData(
                                  products: products,
                                  totalAmount: state.total,
                                ),
                              );
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      // ! Payment Method
                      buildPaymentCard(isDark: isDark, onEdit: () {}),
                      const SizedBox(height: 24),
                      // ! Cost Breakdown (Dynamic)
                      buildCostBreakdown(
                        isDark: isDark,
                        subtotal: state.subtotal,
                        discount: state.discount,
                        shipping: state.shipping,
                        total: state.total,
                      ),
                    ],
                  ),
                ),
                // ! Bottom Bar
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF221910).withOpacity(0.95)
                          : Colors.white.withOpacity(0.95),
                      border: Border(
                        top: BorderSide(
                          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    child: ElevatedButton(
                      onPressed: () {
                        if (state.selectedAddress == null) {
                          customSnackBar(
                            context,
                            "Please select a shipping address",
                            CupertinoIcons.exclamationmark_circle,
                            AppColors.bgRed,
                          );
                        } else {
                          context.read<CheckoutBloc>().add(
                            const PlaceOrderEvent(paymentMethod: 'Razorpay'),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                        shadowColor: primaryColor.withOpacity(0.3),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Place Order',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(
                            '₹${state.total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Helper Widget: Product Item
  Widget buildProductItem({
    required bool isDark,
    required String imageUrl,
    required String title,
    required String subtitle,
    required int quantity,
    required String price,
    required String size,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.bgGrey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.bgBlack.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: isDark ? Colors.grey[700] : Colors.grey[100],
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Size: $size  • Color: $subtitle',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Qty: $quantity',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget: Info Card (Address)
  Widget buildInfoCard({
    required bool isDark,
    required IconData icon,
    required String title,
    required String content,
    required VoidCallback onEdit,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.bgGrey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: Colors.grey[400]),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: onEdit,
                child: Row(
                  children: [
                    Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.bgOrange,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: AppColors.iconOrangeAccent,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.5,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget: Payment Card
  Widget buildPaymentCard({
    required bool isDark,
    required VoidCallback onEdit,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.credit_card, size: 20, color: AppColors.bgGrey),
                  const SizedBox(width: 8),
                  Text(
                    'Payment Method',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              InkWell(
                onTap: onEdit,
                child: Row(
                  children: [
                    Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.bgOrange,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: AppColors.iconOrangeAccent,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 48,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Image.asset(
                    'Flux_Foot/assets/images/icons/razorPay.png',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Razorpay',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper Widget: Cost Breakdown
  Widget buildCostBreakdown({
    required bool isDark,
    required double subtotal,
    required double discount,
    required double shipping,
    required double total,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.grey[700]!.withOpacity(0.5)
              : Colors.grey[100]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          buildCostRow(
            isDark: isDark,
            label: 'Subtotal',
            value: '₹${subtotal.toStringAsFixed(2)}',
            isRegular: true,
          ),
          const SizedBox(height: 12),
          buildCostRow(
            isDark: isDark,
            label: 'Discount',
            value: '- ₹${discount.toStringAsFixed(2)}',
            isDiscount: true,
          ),
          const SizedBox(height: 12),
          buildCostRow(
            isDark: isDark,
            label: 'Shipping',
            value: shipping == 0 ? "Free" : '₹${shipping.toStringAsFixed(2)}',
            isRegular: true,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Divider(
              height: 1,
              color: isDark ? Colors.grey[700] : Colors.grey[100],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                '₹${total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCostRow({
    required bool isDark,
    required String label,
    required String value,
    bool isRegular = false,
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDiscount
                ? AppColors.bgOrange
                : isDark
                ? Colors.white
                : Colors.black87,
          ),
        ),
      ],
    );
  }
}
