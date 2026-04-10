import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models.dart';
import '../domain/search_state.dart';
import '../domain/bus_search_use_case.dart';
import '../domain/input_validator.dart';

class SearchNotifier extends StateNotifier<SearchState> {
  final BusSearchUseCase _searchUseCase;
  final InputValidator _validator;
  int _activeSearchToken = 0;
  bool _isDisposed = false;

  Stop? selectedSource;
  Stop? selectedDestination;

  SearchNotifier({
    required BusSearchUseCase searchUseCase,
    required InputValidator validator,
  }) : _searchUseCase = searchUseCase,
       _validator = validator,
       super(const IdleState());

  void setSource(Stop? stop) {
    selectedSource = stop;
    if (state is ErrorState) state = const IdleState();
    if (stop != null) {
      _loadStopBoard(stop);
    } else {
      state = const IdleState();
    }
  }

  void setDestination(Stop? stop) {
    selectedDestination = stop;
    clearError();
  }

  void swapStops() {
    final temp = selectedSource;
    selectedSource = selectedDestination;
    selectedDestination = temp;
    clearError();
  }

  void clearError() {
    if (state is ErrorState) {
      state = const IdleState();
    }
  }

  void resetToIdle() {
    selectedSource = null;
    selectedDestination = null;
    state = const IdleState();
  }

  void _loadStopBoard(Stop stop) {
    final buses = _searchUseCase.stopBoard(
      stop: stop,
      currentTime: DateTime.now(),
      limit: 5,
    );
    state = StopBoardState(stop: stop, buses: buses);
  }

  Future<void> search() async {
    final validation = _validator.validate(
      source: selectedSource,
      destination: selectedDestination,
    );

    if (!validation.isValid) {
      state = ErrorState(validation.errorMessage!);
      return;
    }

    final searchToken = ++_activeSearchToken;
    state = const LoadingState();

    // Simulate brief loading for UX
    await Future.delayed(const Duration(milliseconds: 500));

    if (_isDisposed || searchToken != _activeSearchToken) {
      return;
    }

    final results = _searchUseCase.search(
      source: selectedSource!,
      destination: selectedDestination!,
      currentTime: DateTime.now(),
    );

    if (_isDisposed || searchToken != _activeSearchToken) {
      return;
    }

    if (results.isEmpty) {
      state = const EmptyState();
    } else {
      state = ResultsState(results);
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
