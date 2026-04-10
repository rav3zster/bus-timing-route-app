import 'package:flutter_test/flutter_test.dart';
import 'package:smart_bus_assistant/data/mock_bus_repository.dart';
import 'package:smart_bus_assistant/domain/bus_search_use_case.dart';
import 'package:smart_bus_assistant/domain/models.dart';
import 'package:smart_bus_assistant/domain/time_calculator.dart';

void main() {
  late BusSearchUseCase useCase;
  late MockBusRepository repository;
  late List<Stop> stops;
  const busNamesPool = [
    'Golden',
    'Devi Prasad',
    'Navadurga',
    'Sri Durga',
    'Mahaveer',
    'Ganesh',
    'Lakshmi',
    'Sai Krupa',
  ];

  Stop stopByName(String name) {
    return stops.firstWhere((s) => s.name == name);
  }

  setUp(() {
    repository = MockBusRepository.instance;
    useCase = BusSearchUseCase(
      repository: repository,
      timeCalculator: TimeCalculator(),
    );
    stops = repository.getAllStops();
  });

  test('contains expected 13-series route numbers', () {
    final numbers = repository.getAllBuses().map((bus) => bus.number).toSet();

    expect(numbers, {'13', '13A', '13B', '13C', '13D'});
  });

  test('display name formatting remains clean', () {
    const bus = Bus(id: 'x', number: '13C', name: 'Sri Durga');
    expect(bus.displayName, '13C Sri Durga');
  });

  test('route 13 runs every 15 minutes from 06:00 to 21:30', () {
    final stateBank = stopByName('State Bank');
    final starts =
        repository
            .getAllRoutes()
            .where((route) => route.bus.number == '13')
            .map(
              (route) => route.stops
                  .firstWhere((s) => s.stop == stateBank)
                  .departureMinutes,
            )
            .toList()
          ..sort();

    expect(starts.first, 360);
    expect(starts.last, 1290);
    expect(starts.length, 63);
    for (var i = 1; i < starts.length; i++) {
      expect(starts[i] - starts[i - 1], 15);
    }
  });

  test('route 13D runs every 2 hours', () {
    final stateBank = stopByName('State Bank');
    final starts =
        repository
            .getAllRoutes()
            .where((route) => route.bus.number == '13D')
            .map(
              (route) => route.stops
                  .firstWhere((s) => s.stop == stateBank)
                  .departureMinutes,
            )
            .toList()
          ..sort();

    expect(starts, [360, 480, 600, 720, 840, 960, 1080, 1200]);
  });

  test('bus names are assigned per trip and vary within same route', () {
    final route13Names = repository
        .getAllRoutes()
        .where((route) => route.bus.number == '13')
        .take(12)
        .map((route) => route.bus.name)
        .toList();

    expect(route13Names.toSet().length, greaterThan(1));
    expect(route13Names.every(busNamesPool.contains), isTrue);
  });

  test('search returns nearest upcoming trips sorted by source time', () {
    final stateBank = stopByName('State Bank');
    final bondel = stopByName('Bondel');
    final currentTime = DateTime(2026, 1, 1, 9, 7); // 547

    final results = useCase.search(
      source: stateBank,
      destination: bondel,
      currentTime: currentTime,
    );

    expect(results, isNotEmpty);
    expect(results.every((r) => r.departureMinutes >= 547), isTrue);
    expect(
      results.any((r) => r.bus.number == '13C' || r.bus.number == '13D'),
      isTrue,
    );

    for (var i = 1; i < results.length; i++) {
      expect(
        results[i].departureMinutes,
        greaterThanOrEqualTo(results[i - 1].departureMinutes),
      );
    }
  });

  test('reverse direction returns no results for one-way templates', () {
    final bondel = stopByName('Bondel');
    final stateBank = stopByName('State Bank');

    final reverseResults = useCase.search(
      source: bondel,
      destination: stateBank,
      currentTime: DateTime(2026, 1, 1, 8, 0),
    );

    expect(reverseResults, isEmpty);
  });

  test('stop board returns sorted upcoming arrivals only', () {
    final stateBank = stopByName('State Bank');

    final board = useCase.stopBoard(
      stop: stateBank,
      currentTime: DateTime(2026, 1, 1, 7, 15), // 435
      limit: 5,
    );

    expect(board, isNotEmpty);
    expect(board.every((r) => r.departureMinutes >= 435), isTrue);

    for (var i = 1; i < board.length; i++) {
      expect(
        board[i].departureMinutes,
        greaterThanOrEqualTo(board[i - 1].departureMinutes),
      );
    }
  });
}
