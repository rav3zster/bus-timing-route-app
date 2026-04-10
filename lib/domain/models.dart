/// Core domain models for the Smart Bus Timing & Route Assistant.
library;

class Stop {
  final String id;
  final String name;

  const Stop({required this.id, required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Stop && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Stop(id: $id, name: $name)';
}

class Bus {
  final String id;
  final String number;
  final String name;

  const Bus({required this.id, required this.number, required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Bus && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Bus(id: $id, number: $number, name: $name)';
}

/// Represents a stop on a route with its departure time in minutes since midnight.
/// e.g. 8:00 AM = 480, 13:30 = 810
class RouteStop {
  final Stop stop;
  final int departureMinutes;

  const RouteStop({required this.stop, required this.departureMinutes});
}

class BusRoute {
  final Bus bus;
  final List<RouteStop> stops;

  const BusRoute({required this.bus, required this.stops});
}

class BusResult {
  final Bus bus;
  final int departureMinutes;
  final Duration timeUntilDeparture;
  final List<Stop> routePreview;

  const BusResult({
    required this.bus,
    required this.departureMinutes,
    required this.timeUntilDeparture,
    required this.routePreview,
  });
}

class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  const ValidationResult({required this.isValid, this.errorMessage});

  const ValidationResult.valid() : isValid = true, errorMessage = null;

  const ValidationResult.invalid(String message)
    : isValid = false,
      errorMessage = message;
}
