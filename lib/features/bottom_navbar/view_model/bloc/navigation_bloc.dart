import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  final PageController pageController;

  NavigationBloc({PageController? pageController})
    : pageController = pageController ?? PageController(),
      super(const NavigationState()) {
    on<NavigationTabChanged>(_onNavigationTabChanged);
  }

  void _onNavigationTabChanged(
    NavigationTabChanged event,
    Emitter<NavigationState> emit,
  ) {
    emit(state.copyWith(selectedIndex: event.tabIndex));
    pageController.jumpToPage(event.tabIndex);
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
