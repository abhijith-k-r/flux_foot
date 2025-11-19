part of 'product_variant_bloc.dart';

abstract class ProductVariantEvent extends Equatable {
  const ProductVariantEvent();

  @override
  List<Object> get props => [];
}

class SelectColorVariant extends ProductVariantEvent {
  final ColorvariantModel variant;
  const SelectColorVariant(this.variant);

  @override
  List<Object> get props => [variant];
}

class SelectSizeVariant extends ProductVariantEvent {
  final SizeQuantityVariant size;
  const SelectSizeVariant(this.size);

  @override
  List<Object> get props => [size];

}
