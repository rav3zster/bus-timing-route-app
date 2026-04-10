/// Time calculation utilities for the Smart Bus Timing & Route Assistant.
library;

class TimeCalculator {
  /// Returns the duration until a bus departs.
  ///
  /// [departureMinutes] is the departure time in minutes since midnight.
  /// [now] is the current date/time.
  ///
  /// Returns [Duration.zero] if the bus has already departed.
  Duration timeUntil(int departureMinutes, DateTime now) {
    final nowMinutes = now.hour * 60 + now.minute;
    final diff = departureMinutes - nowMinutes;
    if (diff < 0) return Duration.zero;
    return Duration(minutes: diff);
  }

  /// Formats a [Duration] as a human-readable string.
  ///
  /// Returns `"Xm"` for durations under 60 minutes,
  /// or `"Xh Ym"` for 60 minutes and above.
  String formatDuration(Duration d) {
    if (d.inMinutes < 60) {
      return '${d.inMinutes}m';
    }
    final hours = d.inHours;
    final mins = d.inMinutes % 60;
    return '${hours}h ${mins}m';
  }

  /// Formats a departure time given in minutes since midnight as `HH:MM`.
  ///
  /// e.g. 480 → "08:00", 615 → "10:15"
  String formatDepartureTime(int departureMinutes) {
    final hours = departureMinutes ~/ 60;
    final mins = departureMinutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}';
  }
}
