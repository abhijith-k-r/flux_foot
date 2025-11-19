part of 'home_bloc.dart';

abstract class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

// ! Holds both products and brands once loading is complete
final class HomeDataLoaded extends HomeState {
  final List<ProductModel> products;
  final List<BrandModel> brands;

  HomeDataLoaded({required this.products, required this.brands});
}

final class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
