import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/services/firebase/user_product_repository.dart';
import 'package:fluxfoot_user/features/filter/view_model/bloc/filter_bloc.dart';
import 'package:fluxfoot_user/features/home/models/brands_model.dart';
import 'package:fluxfoot_user/features/home/models/product_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserProductRepository _productRepository;
  StreamSubscription? _productSubscription;
  StreamSubscription? _brandsSubscription;

  HomeBloc(this._productRepository) : super(HomeInitial()) {
    on<LoadFeaturedProducts>(_onLoadFeaturedProducts);
    on<UpdateFeaturedProducts>(_onUpdateFeaturedProducts);

    on<FilterProducts>(_onFilterProducts);

    on<LoadBrands>(_onLoadBrands);
    on<UpdateBrands>(_onUpdateBrands);
  }

  void _onLoadFeaturedProducts(
    LoadFeaturedProducts event,
    Emitter<HomeState> emit,
  ) {
    if (state is HomeInitial) {
      emit(HomeLoading());
    }

    _productSubscription?.cancel();

    _productSubscription = _productRepository.streamActivePoducts().listen(
      (productList) {
        add(UpdateFeaturedProducts(productList));
      },
      onError: (e) {
        emit(HomeError('Failed to load products: $e'));
      },
    );
  }

  void _onUpdateFeaturedProducts(
    UpdateFeaturedProducts event,
    Emitter<HomeState> emit,
  ) {
    final currentState = state;
    final List<BrandModel> currentBrands = currentState is HomeDataLoaded
        ? currentState.brands
        : [];

    emit(
      HomeDataLoaded(
        products: event.products,
        originalProducts: event.products,
        filteredProducts: event.products,
        brands: currentBrands,
      ),
    );
  }

  // ! For BRANDS
  void _onLoadBrands(LoadBrands event, Emitter<HomeState> emit) {
    if (state is HomeInitial) {
      emit(HomeLoading());
    }

    _brandsSubscription?.cancel();

    _brandsSubscription = _productRepository.streamActiveBrands().listen(
      (brandList) {
        add(UpdateBrands(brandList));
      },
      onError: (e) {
        emit(HomeError('Failed to load brands: $e'));
      },
    );
  }

  void _onUpdateBrands(UpdateBrands event, Emitter<HomeState> emit) {
    final currentState = state;
    final List<ProductModel> currentProducts = currentState is HomeDataLoaded
        ? currentState.products
        : [];

    emit(HomeDataLoaded(products: currentProducts, brands: event.brands));
  }

  void _onFilterProducts(FilterProducts event, Emitter<HomeState> emit) {
    final currentState = state;
    if (currentState is! HomeDataLoaded) return;

    List<ProductModel> filteredProducts = List.from(
      currentState.originalProducts,
    );
    final filterState = event.filterState;

    // ! 1. Filter by Search Query
    final query = filterState.searchQuery.toLowerCase().trim();
    if (query.isNotEmpty) {
      filteredProducts = filteredProducts.where((product) {
        return product.name.toLowerCase().trim().contains(query);
      }).toList();
    }

    // ! 2. Filter by Category
    final category = filterState.selectedCategories;
    if (category.isNotEmpty) {
      filteredProducts = filteredProducts.where((product) {
        // Assuming 'product.category' is a String field in ProductModel
        return category.contains(product.category);
      }).toList();
    }

    // ! 3. Filter by Price Range
    filteredProducts = filteredProducts.where((product) {
      final price = product.salePrice;
      return price >= filterState.minPrice && price <= filterState.maxPrice;
    }).toList();

    // ! 4. Sort the filtered results
    switch (filterState.selectedSort) {
      case SortOption.priceLowToHigh:
        filteredProducts.sort((a, b) => (a.salePrice).compareTo(b.salePrice));
        break;

      case SortOption.priceHighToLow:
        filteredProducts.sort((a, b) => (b.salePrice).compareTo((a.salePrice)));
        break;

      case SortOption.newestFirst:
        filteredProducts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;

      case SortOption.popularity:
        break;
    }

    emit(
      HomeDataLoaded(
        products: currentState.products,
        originalProducts: currentState.originalProducts,
        brands: currentState.brands,
        filteredProducts: filteredProducts,
      ),
    );
  }

  @override
  Future<void> close() {
    _productSubscription?.cancel();
    _brandsSubscription?.cancel();
    return super.close();
  }
}
