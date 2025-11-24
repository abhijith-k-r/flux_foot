part of 'filter_bloc.dart';

abstract class FilterEvent {}

class ChangeSortOption extends FilterEvent {
  final SortOption option;
  ChangeSortOption(this.option);
}

class ToggleCategory extends FilterEvent {
  final String category;
  ToggleCategory(this.category);
}

class UpdatePriceRange extends FilterEvent {
  final double minPrice;
  final double maxPrice;
  UpdatePriceRange(this.minPrice, this.maxPrice);
}

class ResetFilters extends FilterEvent {}

class ApplyFilters extends FilterEvent {}

class UpdateSearchQuery extends FilterEvent {
  final String query;
  UpdateSearchQuery(this.query);
}

//! filter_state.dart
enum SortOption { newestFirst, priceLowToHigh, priceHighToLow, popularity }
