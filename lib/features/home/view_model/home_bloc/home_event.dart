part of 'home_bloc.dart';

abstract class HomeEvent {}

final class LoadFeaturedProducts extends HomeEvent {}

// ! Event to pass updated product list from the repository stream
final class UpdateFeaturedProducts extends HomeEvent {
  final List<ProductModel> products;

  UpdateFeaturedProducts(this.products);
}

// ! Triggered by the "Apply Filters" button
final class FilterProducts extends HomeEvent {
  final FilterState filterState;

  FilterProducts(this.filterState);
}

final class LoadBrands extends HomeEvent {}

final class UpdateBrands extends HomeEvent {
  final List<BrandModel> brands;

  UpdateBrands(this.brands);
}
