import 'package:flutter_test/flutter_test.dart';
import 'package:smart_bus_assistant/domain/time_calculator.dart';

void main() {
  late TimeCalculator calc;

  setUp(() => calc = TimeCalculator());

  group('timeUntil', () {
    test('returns correct duration when bus is in the future', () {
      final now = DateTime(2024, 1, 1, 8, 0); // 08:00 = 480 min
      expect(calc.timeUntil(510, now), const Duration(minutes: 30)); // 08:30
    });

    test('returns Duration.zero when bus already departed', () {
      final now = DateTime(2024, 1, 1, 9, 0); // 09:00 = 540 min
      expect(calc.timeUntil(480, now), Duration.zero); // 08:00 already passed
    });

    test('returns Duration.zero when departure equals now', () {
      final now = DateTime(2024, 1, 1, 8, 0); // 480 min
      expect(calc.timeUntil(480, now), Duration.zero);
    });

    test('handles midnight boundary correctly', () {
      final now = DateTime(2024, 1, 1, 0, 0); // 00:00 = 0 min
      expect(calc.timeUntil(60, now), const Duration(minutes: 60));
    });
  });

  group('formatDuration', () {
    test('formats minutes-only for durations under 60 minutes', () {
      expect(calc.formatDuration(const Duration(minutes: 45)), '45m');
    });

    test('formats 0 minutes', () {
      expect(calc.formatDuration(Duration.zero), '0m');
    });

    test('formats 59 minutes as minutes-only', () {
      expect(calc.formatDuration(const Duration(minutes: 59)), '59m');
    });

    test('formats exactly 60 minutes as hours and minutes', () {
      expect(calc.formatDuration(const Duration(minutes: 60)), '1h 0m');
    });

    test('formats 90 minutes as 1h 30m', () {
      expect(calc.formatDuration(const Duration(minutes: 90)), '1h 30m');
    });

    test('formats 125 minutes as 2h 5m', () {
      expect(calc.formatDuration(const Duration(minutes: 125)), '2h 5m');
    });
  });

  group('formatDepartureTime', () {
    test('formats 480 as 08:00', () {
      expect(calc.formatDepartureTime(480), '08:00');
    });

    test('formats 615 as 10:15', () {
      expect(calc.formatDepartureTime(615), '10:15');
    });

    test('formats 0 as 00:00', () {
      expect(calc.formatDepartureTime(0), '00:00');
    });

    test('formats 1439 as 23:59', () {
      expect(calc.formatDepartureTime(1439), '23:59');
    });

    test('pads single-digit hours and minutes', () {
      expect(calc.formatDepartureTime(65), '01:05'); // 1h 5m
    });
  });
}
