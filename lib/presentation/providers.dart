import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_bus_repository.dart';
import '../domain/bus_search_use_case.dart';
import '../domain/input_validator.dart';
import '../domain/search_state.dart';
import '../domain/time_calculator.dart';
import 'search_notifier.dart';

/// Current theme index (0–9). Drives the entire app's color scheme.
final themeIndexProvider = StateProvider<int>((ref) => 0);

final busRepositoryProvider = Provider((_) => MockBusRepository.instance);

final timeCalculatorProvider = Provider((_) => TimeCalculator());

final inputValidatorProvider = Provider((_) => InputValidator());

final busSearchUseCaseProvider = Provider(
  (ref) => BusSearchUseCase(
    repository: ref.read(busRepositoryProvider),
    timeCalculator: ref.read(timeCalculatorProvider),
  ),
);

final searchNotifierProvider =
    StateNotifierProvider<SearchNotifier, SearchState>(
      (ref) => SearchNotifier(
        searchUseCase: ref.read(busSearchUseCaseProvider),
        validator: ref.read(inputValidatorProvider),
      ),
    );
