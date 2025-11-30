// carousel_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';

class CarouselCubit extends Cubit<int> {
  // Initial state is index 0
  CarouselCubit() : super(0);

  // Method to update the current index
  void updateIndex(int newIndex) {
    if (newIndex != state) {
      emit(newIndex);
    }
  }
}
