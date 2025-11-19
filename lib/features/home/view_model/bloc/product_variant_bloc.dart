import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/features/home/models/color_variant.model.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';
import 'package:fluxfoot_user/features/home/models/size_quantity_model.dart';

part 'product_variant_event.dart';
part 'product_variant_state.dart';

class ProductVariantBloc
    extends Bloc<ProductVariantEvent, ProductVariantState> {
  ProductVariantBloc(ProductModel product)
    : super(_initializeInitialState(product)) {
    on<SelectColorVariant>(_onSelectColorVariant);
    on<SelectSizeVariant>(_onSelectedSizeVariant);
  }

  static ProductVariantState _initializeInitialState(ProductModel product) {
    final initialVariant = product.variants.isNotEmpty
        ? product.variants.first
        : ColorvariantModel(colorName: 'colorName');

    final initialSize = initialVariant.sizes.isNotEmpty
        ? initialVariant.sizes.first
        : null;

    return ProductVariantState(
      product: product,
      selectedVariant: initialVariant,
      selectedSize: initialSize,
    );
  }

  void _onSelectColorVariant(
    SelectColorVariant event,
    Emitter<ProductVariantState> emit,
  ) {
    final newVariant = event.variant;
    final newSize = newVariant.sizes.isNotEmpty ? newVariant.sizes.first : null;

    emit(state.copyWith(selectedVariant: newVariant, selectedSize: newSize));
  }

  void _onSelectedSizeVariant(
    SelectSizeVariant event,
    Emitter<ProductVariantState> emit,
  ) {
    emit(state.copyWith(selectedSize: event.size));
  }
}
