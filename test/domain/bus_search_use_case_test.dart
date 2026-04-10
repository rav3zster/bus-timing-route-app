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
    final central = stopByName('Central Station');
    final hospital = stopByName('Hospital');

    final results = useCase.search(
      source: central,
      destination: hospital,
      currentTime: DateTime(2026, 1, 1, 7, 30),
    );

    expect(results, isNotEmpty);
    expect(results.any((r) => r.bus.number == '42A'), isTrue);
  });

  test('supports return direction through dedicated return routes', () {
    final hospital = stopByName('Hospital');
    final central = stopByName('Central Station');

    final results = useCase.search(
      source: hospital,
      destination: central,
      currentTime: DateTime(2026, 1, 1, 9, 25),
    );

    expect(results, isNotEmpty);
    expect(results.any((r) => r.bus.number == '42A'), isTrue);
    expect(
      results
          .where((r) => r.bus.number == '42A')
          .every((r) => r.departureMinutes >= 580),
      isTrue,
    );
  });

  test('does not permit backward travel in a single route direction', () {
    final airport = stopByName('Airport');
    final beachRoad = stopByName('Beach Road');

    final outboundResults = useCase.search(
      source: airport,
      destination: beachRoad,
      currentTime: DateTime(2026, 1, 1, 7, 0),
    );
    final reverseResults = useCase.search(
      source: beachRoad,
      destination: airport,
      currentTime: DateTime(2026, 1, 1, 7, 0),
    );

    expect(outboundResults.any((r) => r.bus.number == '17B'), isTrue);
    expect(reverseResults.any((r) => r.bus.number == '17B'), isTrue);

    final firstOutbound17B = outboundResults
        .where((r) => r.bus.number == '17B')
        .map((r) => r.departureMinutes)
        .reduce((a, b) => a < b ? a : b);
    final firstReverse17B = reverseResults
        .where((r) => r.bus.number == '17B')
        .map((r) => r.departureMinutes)
        .reduce((a, b) => a < b ? a : b);

    expect(firstReverse17B, greaterThan(firstOutbound17B));
  });

  test('stop board returns sorted upcoming arrivals only', () {
    final central = stopByName('Central Station');

    final board = useCase.stopBoard(
      stop: central,
      currentTime: DateTime(2026, 1, 1, 9, 59),
      limit: 5,
    );

    expect(board, isNotEmpty);
    expect(board.every((r) => r.departureMinutes >= 599), isTrue);

    for (var i = 1; i < board.length; i++) {
      expect(board[i].departureMinutes, greaterThanOrEqualTo(board[i - 1].departureMinutes));
    }
  });
}
