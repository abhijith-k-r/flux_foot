part of 'product_variant_bloc.dart';


class ProductVariantState {
  final ProductModel product;
  final ColorvariantModel selectedVariant;
  final SizeQuantityVariant? selectedSize;

  const ProductVariantState({
    required this.product,
    required this.selectedVariant,
    this.selectedSize,
  });

  List<String> get currentImages {
    if (selectedVariant.imageUrls.isNotEmpty) {
      return selectedVariant.imageUrls;
    }
    return product.images;
  }

  ProductVariantState copyWith({
    ColorvariantModel? selectedVariant,
    SizeQuantityVariant? selectedSize,
  }) {
    return ProductVariantState(
      product: product,
      selectedVariant: selectedVariant ?? this.selectedVariant,
      selectedSize: selectedSize,
    );
  }
}
