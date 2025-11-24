import 'package:bloc/bloc.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc({double globalMin = 0.0, double globalMax = 10000.0})
    : super(FilterState(minPrice: globalMin, maxPrice: globalMax)) {
    on<ChangeSortOption>(_onChangedSortOption);
    on<ToggleCategory>(_onToggleCategory);
    on<UpdatePriceRange>(_onUpdatePriceRange);
    on<ResetFilters>(_onResetFilters);
    on<ApplyFilters>(_onApplyFilters);
    on<UpdateSearchQuery>(_onUpdateSearchQuery);
  }

  void _onChangedSortOption(ChangeSortOption event, Emitter<FilterState> emit) {
    emit(state.copyWith(selectedSort: event.option));
  }

  void _onToggleCategory(ToggleCategory event, Emitter<FilterState> emit) {
    emit(state.copyWith(selectedCategory: event.category));
  }

  void _onUpdatePriceRange(UpdatePriceRange event, Emitter<FilterState> emit) {
    emit(state.copyWith(minPrice: event.minPrice, maxPrice: event.maxPrice));
  }

  void _onResetFilters(ResetFilters event, Emitter<FilterState> emit) {
    emit(FilterState());
  }

  void _onApplyFilters(ApplyFilters event, Emitter<FilterState> emit) {
    // Handle apply logic here (e.g., close bottom sheet, trigger filtering)
  }

  void _onUpdateSearchQuery(
    UpdateSearchQuery event,
    Emitter<FilterState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }
}
