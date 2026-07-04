// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/widgets/custom_appbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_snackbar.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/address/model/address_model.dart';
import 'package:fluxfoot_user/features/address/views/screens/shipping_address_view.dart';
import 'package:fluxfoot_user/features/checkout/view_model/bloc/checkout_bloc.dart';
import 'package:fluxfoot_user/features/checkout/views/widgets/bottom_bar.dart';
import 'package:fluxfoot_user/features/checkout/views/widgets/cost_breakdown.dart';
import 'package:fluxfoot_user/features/checkout/views/widgets/info_card.dart';
import 'package:fluxfoot_user/features/checkout/views/widgets/payment_card.dart';
import 'package:fluxfoot_user/features/checkout/views/widgets/product_item.dart';
import 'package:fluxfoot_user/features/order/views/screen/order_success_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final stripeService = StripeRepository();

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
        } else if (state.status == CheckoutStatus.orderPlaced) {
          // Navigate to Success screen, which will auto-redirect to My Orders
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const OrderSuccessScreen()),
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
                            if (product.variants.isNotEmpty && product.variants.first.sizes.isNotEmpty) {
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
                        onEdit: () async {
                          final selectedAddress =
                              await Navigator.push<AddressModel>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ShippingAddressView(),
                                ),
                              );

                          // 2. If an address was actually selected, update the Bloc state immediately
                          if (selectedAddress != null && context.mounted) {
                            context.read<CheckoutBloc>().add(
                              SelectAddress(selectedAddress),
                            );
                          } else if (context.mounted) {
                            // Fallback refresh just in case
                            context.read<CheckoutBloc>().add(
                              LoadCheckoutData(
                                products: products,
                                totalAmount: state.total,
                              ),
                            );
                          }
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
                  child: BottomBarWidget(
                    isDark: isDark,
                    primaryColor: primaryColor,
                    state: state,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
