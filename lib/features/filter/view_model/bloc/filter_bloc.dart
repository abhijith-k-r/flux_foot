import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  FilterBloc({double globalMin = 0.0, double globalMax = 10000.0})
    : super(FilterState(minPrice: globalMin, maxPrice: globalMax)) {
    on<ChangeSortOption>(_onChangedSortOption);
    on<ToggleCategory>(_onToggleCategory);
    on<UpdatePriceRange>(_onUpdatePriceRange);
    on<ResetFilters>(_onResetFilters);
    on<ApplyFilters>(_onApplyFilters);
    on<UpdateSearchQuery>(_onUpdateSearchQuery);

    on<StartListening>(_onStartListening);
    on<StopListening>(_onStopListening);
    on<SetListeningStatus>(_onSetListeningStatus);

    _initializeSpeech();
  }

  void _onChangedSortOption(ChangeSortOption event, Emitter<FilterState> emit) {
    emit(state.copyWith(selectedSort: event.option));
  }

  void _onToggleCategory(ToggleCategory event, Emitter<FilterState> emit) {
    final category = event.category;
    final currentCategories = List<String>.from(state.selectedCategories);

    if (currentCategories.contains(category)) {
      currentCategories.remove(category);
    } else {
      currentCategories.add(category);
    }
    emit(state.copyWith(selectedCategory: currentCategories));
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

  Future<void> _initializeSpeech() async {
    final availabe = await _speech.initialize();

    if (!availabe) {
      log('Error From InitialSpeech');
    }
  }

  void _onSetListeningStatus(
    SetListeningStatus event,
    Emitter<FilterState> emit,
  ) {
    emit(state.copyWith(isListeningForSpeech: event.isListening));
  }

  void _onStartListening(
    StartListening event,
    Emitter<FilterState> emit,
  ) async {
    if (!_speech.isAvailable) {
      final available = await _speech.initialize();
      if (!available) return;
    }

    if (_speech.isListening) return;

    add(SetListeningStatus(true));

    await _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          add(StopListening(result.recognizedWords));
        }
      },
      listenOptions: stt.SpeechListenOptions(
        cancelOnError: true,
        onDevice: true,
        partialResults: true,
      ),
    );
  }

  void _onStopListening(StopListening event, Emitter<FilterState> emit) {
    if (_speech.isListening) {
      _speech.stop();
    }

    add(SetListeningStatus(false));

    if (event.finalQuery.isNotEmpty) {
      emit(
        state.copyWith(
          searchQuery: event.finalQuery,
          isListeningForSpeech: false,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _speech.stop();
    return super.close();
  }
}
