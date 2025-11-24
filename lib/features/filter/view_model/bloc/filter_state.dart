part of 'filter_bloc.dart';

class FilterState {
  final SortOption selectedSort;
  final String selectedCategory;
  final double minPrice;
  final double maxPrice;
  final String searchQuery;

  FilterState({
    this.selectedSort = SortOption.newestFirst,
    this.selectedCategory = '',
    this.minPrice = 0.0,
    this.maxPrice = 10000.0,
    this.searchQuery = '',
  });

  FilterState copyWith({
    SortOption? selectedSort,
    String? selectedCategory,
    double? minPrice,
    double? maxPrice,
    String? searchQuery,
  }) {
    return FilterState(
      selectedSort: selectedSort ?? this.selectedSort,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
