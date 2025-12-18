part of 'filter_bloc.dart';

class FilterState {
  final SortOption selectedSort;
  final List<String> selectedCategories;
  final double minPrice;
  final double maxPrice;
  final String searchQuery;
  final bool isListeningForSpeech;

  FilterState({
    this.selectedSort = SortOption.newestFirst,
    this.selectedCategories = const [],
    this.minPrice = 0.0,
    this.maxPrice = 10000.0,
    this.searchQuery = '',
    this.isListeningForSpeech = false
  });

  FilterState copyWith({ 
    SortOption? selectedSort,
    List<String>? selectedCategory,
    double? minPrice,
    double? maxPrice,
    bool? isListeningForSpeech,
    String? searchQuery,
  }) {
    return FilterState(
      selectedSort: selectedSort ?? this.selectedSort,
      selectedCategories: selectedCategory ?? selectedCategories,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      isListeningForSpeech: isListeningForSpeech ?? this.isListeningForSpeech,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
