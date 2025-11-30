import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';
import 'package:fluxfoot_user/features/wishlists/view_model/bloc/favorites_bloc.dart';

// ! FAvorite Button
Widget buildCustomFavoriteButton(ProductModel product) {
  return BlocBuilder<FavoritesBloc, FavoritesState>(
    builder: (context, state) {
      final isFavorite = state.favoriteIds.contains(product.id);
      return IconButton(
        onPressed: () {
          context.read<FavoritesBloc>().add(
            ToggleFavoriteEvent(productModel: product, isFavorites: isFavorite),
          );
        },
        icon: Icon(
          isFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
          color: isFavorite
              ? AppColors.iconOrangeAccent
              : AppColors.outLineOrang,
        ),
      );
    },
  );
}
