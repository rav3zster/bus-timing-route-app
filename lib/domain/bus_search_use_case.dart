import '../data/bus_repository.dart';
import 'models.dart';
import 'time_calculator.dart';

class BusSearchUseCase {
  final BusRepository repository;
  final TimeCalculator timeCalculator;

  BusSearchUseCase({required this.repository, required this.timeCalculator});

  /// Returns the next [limit] buses arriving at [stop] from current time.
  List<BusResult> stopBoard({
    required Stop stop,
    required DateTime currentTime,
    int limit = 5,
  }) {
    final routes = repository.getAllRoutes();
    final currentMinutes = currentTime.hour * 60 + currentTime.minute;
    final results = <BusResult>[];

    for (final route in routes) {
      final idx = route.stops.indexWhere((rs) => rs.stop == stop);
      if (idx == -1) continue;

      final rs = route.stops[idx];
      if (rs.departureMinutes < currentMinutes) continue;

      // Route preview: this stop + remaining stops on the route
      final preview = route.stops.sublist(idx).map((s) => s.stop).toList();

      results.add(
        BusResult(
          bus: route.bus,
          departureMinutes: rs.departureMinutes,
          timeUntilDeparture: timeCalculator.timeUntil(
            rs.departureMinutes,
            currentTime,
          ),
          routePreview: preview,
        ),
      );
    }

    results.sort((a, b) => a.departureMinutes.compareTo(b.departureMinutes));
    return results.take(limit).toList();
  }

  List<BusResult> search({
    required Stop source,
    required Stop destination,
    required DateTime currentTime,
  }) {
    final routes = repository.getAllRoutes();
    final currentMinutes = currentTime.hour * 60 + currentTime.minute;

    final results = <BusResult>[];

    for (final route in routes) {
      final stops = route.stops;

      final sourceIndex = stops.indexWhere((rs) => rs.stop == source);
      final destinationIndex = stops.indexWhere((rs) => rs.stop == destination);

      if (sourceIndex == -1 || destinationIndex == -1) continue;
      if (sourceIndex >= destinationIndex) continue;

      final sourceRouteStop = stops[sourceIndex];
      final departureMinutes = sourceRouteStop.departureMinutes;

      if (departureMinutes < currentMinutes) continue;

      final routePreview = stops
          .sublist(sourceIndex, destinationIndex + 1)
          .map((rs) => rs.stop)
          .toList();

      results.add(
        BusResult(
          bus: route.bus,
          departureMinutes: departureMinutes,
          timeUntilDeparture: timeCalculator.timeUntil(
            departureMinutes,
            currentTime,
          ),
          routePreview: routePreview,
        ),
      );
    }

    results.sort((a, b) => a.departureMinutes.compareTo(b.departureMinutes));

    return results;
  }
}
