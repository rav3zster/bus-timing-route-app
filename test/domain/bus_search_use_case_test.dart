import 'package:flutter_test/flutter_test.dart';
import 'package:smart_bus_assistant/data/mock_bus_repository.dart';
import 'package:smart_bus_assistant/domain/bus_search_use_case.dart';
import 'package:smart_bus_assistant/domain/models.dart';
import 'package:smart_bus_assistant/domain/time_calculator.dart';

void main() {
  late BusSearchUseCase useCase;
  late List<Stop> stops;

  Stop stopByName(String name) {
    return stops.firstWhere((s) => s.name == name);
  }

  setUp(() {
    useCase = BusSearchUseCase(
      repository: MockBusRepository.instance,
      timeCalculator: TimeCalculator(),
    );
    stops = MockBusRepository.instance.getAllStops();
  });

  test('finds forward trips on outbound routes', () {
    final stateBank = stopByName('State Bank');
    final urvaStores = stopByName('Urva Stores');

    final results = useCase.search(
      source: stateBank,
      destination: urvaStores,
      currentTime: DateTime(2026, 1, 1, 6, 55),
    );

    expect(results, isNotEmpty);
    expect(results.any((r) => r.bus.number == '13'), isTrue);
  });

  test('supports return direction through dedicated return routes', () {
    final urvaStores = stopByName('Urva Stores');
    final stateBank = stopByName('State Bank');

    final results = useCase.search(
      source: urvaStores,
      destination: stateBank,
      currentTime: DateTime(2026, 1, 1, 7, 45),
    );

    expect(results, isNotEmpty);
    expect(results.any((r) => r.bus.number == '13'), isTrue);
    expect(
      results
          .where((r) => r.bus.number == '13')
          .every((r) => r.departureMinutes >= 475),
      isTrue,
    );
  });

  test('does not permit backward travel in a single route direction', () {
    final stateBank = stopByName('State Bank');
    final bondel = stopByName('Bondel');

    final forwardResults = useCase.search(
      source: stateBank,
      destination: bondel,
      currentTime: DateTime(2026, 1, 1, 7, 0),
    );
    final reverseResults = useCase.search(
      source: bondel,
      destination: stateBank,
      currentTime: DateTime(2026, 1, 1, 7, 0),
    );

    expect(forwardResults.any((r) => r.bus.number == '13C'), isTrue);
    expect(reverseResults.any((r) => r.bus.number == '13C'), isTrue);

    final firstForward13C = forwardResults
        .where((r) => r.bus.number == '13C')
        .map((r) => r.departureMinutes)
        .reduce((a, b) => a < b ? a : b);
    final firstReverse13C = reverseResults
        .where((r) => r.bus.number == '13C')
        .map((r) => r.departureMinutes)
        .reduce((a, b) => a < b ? a : b);

    expect(firstReverse13C, greaterThan(firstForward13C));
  });

  test('13D extends 13C route beyond Bondel', () {
    final stateBank = stopByName('State Bank');
    final pacchanady = stopByName('Pacchanady');

    final results = useCase.search(
      source: stateBank,
      destination: pacchanady,
      currentTime: DateTime(2026, 1, 1, 8, 0),
    );

    expect(results.any((r) => r.bus.number == '13D'), isTrue);
    expect(
      results
          .where((r) => r.bus.number == '13D')
          .every((r) => r.routePreview.last.name == 'Pacchanady'),
      isTrue,
    );
  });

  test('stop board returns sorted upcoming arrivals only', () {
    final stateBank = stopByName('State Bank');

    final board = useCase.stopBoard(
      stop: stateBank,
      currentTime: DateTime(2026, 1, 1, 7, 15),
      limit: 5,
    );

    expect(board, isNotEmpty);
    expect(board.every((r) => r.departureMinutes >= 435), isTrue);

    for (var i = 1; i < board.length; i++) {
      expect(board[i].departureMinutes, greaterThanOrEqualTo(board[i - 1].departureMinutes));
    }
  });
}
