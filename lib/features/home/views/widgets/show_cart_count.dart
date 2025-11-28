import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/core/widgets/custom_text.dart';
import 'package:fluxfoot_user/features/cart/view_model/bloc/cart_bloc.dart';

Widget showCartCountBox(double size) {
    return Padding(
            padding: EdgeInsets.all(size * 0.02),
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                final cartProducts = state.cartProducts;
                return Stack(
                  children: [
                    Positioned(
                      child: Container(
                        width: size * 0.093,
                        height: size * 0.093,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(1),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.bgWhite,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Icon(
                              cartProducts.isNotEmpty
                                  ? CupertinoIcons.cart_fill
                                  : CupertinoIcons.cart,
                              color: AppColors.iconBlack,
                              size: size * 0.045,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      top: -3,
                      right: 2,
                      child: Container(
                        padding: EdgeInsets.all(size * 0.010),
                        decoration: BoxDecoration(
                          color: cartProducts.isNotEmpty
                              ? AppColors.bgOrangeAccent
                              : AppColors.bgBlack,
                          shape: BoxShape.circle,
                        ),
                        child: customText(
                          size * 0.03,
                          cartProducts.length.toString(),
                          appColor: AppColors.textWite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
  }

