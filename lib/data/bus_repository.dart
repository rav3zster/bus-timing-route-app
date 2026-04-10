import '../domain/models.dart';

abstract class BusRepository {
  List<Bus> getAllBuses();
  List<Stop> getAllStops();
  List<BusRoute> getAllRoutes();
}
