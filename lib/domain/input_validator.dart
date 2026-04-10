import 'models.dart';

class InputValidator {
  ValidationResult validate({Stop? source, Stop? destination}) {
    if (source == null) {
      return const ValidationResult.invalid('Please select a source stop');
    }
    if (destination == null) {
      return const ValidationResult.invalid('Please select a destination stop');
    }
    if (source.id == destination.id) {
      return const ValidationResult.invalid(
        'Source and destination cannot be the same stop',
      );
    }
    return const ValidationResult.valid();
  }
}
