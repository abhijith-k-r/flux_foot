part of 'carousel_bloc.dart';

abstract class UserCarouselState {}

class CarouselInitial extends UserCarouselState {}

class CarouselLoading extends UserCarouselState {}

class CarouselLoaded extends UserCarouselState {
  final CarouselData data;

  CarouselLoaded(this.data);
}

class CarouselError extends UserCarouselState {
  final String message;
  CarouselError(this.message);
}
