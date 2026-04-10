import 'models.dart';

/// Sealed class representing all possible states of the bus search feature.
sealed class SearchState {
  const SearchState();
}

/// Initial state before any search has been performed.
class IdleState extends SearchState {
  const IdleState();
}

/// State while a search is in progress.
class LoadingState extends SearchState {
  const LoadingState();
}

/// State when search returned one or more results.
class ResultsState extends SearchState {
  final List<BusResult> buses;
  const ResultsState(this.buses);
}

/// State when search completed but no buses were found.
class EmptyState extends SearchState {
  const EmptyState();
}

/// State when an error occurred (e.g. invalid input).
class ErrorState extends SearchState {
  final String message;
  const ErrorState(this.message);
}

/// State showing upcoming buses at a single stop (stop board).
class StopBoardState extends SearchState {
  final Stop stop;
  final List<BusResult> buses;
  const StopBoardState({required this.stop, required this.buses});
}
