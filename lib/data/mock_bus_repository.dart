import '../domain/models.dart';
import 'bus_repository.dart';

class MockBusRepository implements BusRepository {
  MockBusRepository._();
  static final MockBusRepository instance = MockBusRepository._();

  // Stops
  static const _s1 = Stop(id: 's1', name: 'Central Station');
  static const _s2 = Stop(id: 's2', name: 'Airport');
  static const _s3 = Stop(id: 's3', name: 'University');
  static const _s4 = Stop(id: 's4', name: 'Market Square');
  static const _s5 = Stop(id: 's5', name: 'Hospital');
  static const _s6 = Stop(id: 's6', name: 'Tech Park');
  static const _s7 = Stop(id: 's7', name: 'Old Town');
  static const _s8 = Stop(id: 's8', name: 'Beach Road');

  static const _stops = [_s1, _s2, _s3, _s4, _s5, _s6, _s7, _s8];

  // Buses
  static const _b1 = Bus(id: 'b1', number: '42A', name: 'City Express');
  static const _b2 = Bus(id: 'b2', number: '17B', name: 'Airport Shuttle');
  static const _b3 = Bus(id: 'b3', number: '5C', name: 'University Line');
  static const _b4 = Bus(id: 'b4', number: '88D', name: 'Coastal Runner');
  static const _b5 = Bus(id: 'b5', number: '33E', name: 'Metro Link');
  static const _b6 = Bus(id: 'b6', number: '11F', name: 'Night Connector');

  static const _buses = [_b1, _b2, _b3, _b4, _b5, _b6];

  // Routes
  static const _routes = [
    // Bus 42A - City Express (outbound run 1)
    BusRoute(
      bus: _b1,
      stops: [
        RouteStop(stop: _s1, departureMinutes: 480), // Central Station 8:00
        RouteStop(stop: _s4, departureMinutes: 495), // Market Square 8:15
        RouteStop(stop: _s3, departureMinutes: 515), // University 8:35
        RouteStop(stop: _s6, departureMinutes: 540), // Tech Park 9:00
        RouteStop(stop: _s5, departureMinutes: 560), // Hospital 9:20
      ],
    ),
    // Bus 42A - City Express (inbound run 1 return)
    BusRoute(
      bus: _b1,
      stops: [
        RouteStop(stop: _s5, departureMinutes: 580), // Hospital 9:40
        RouteStop(stop: _s6, departureMinutes: 600), // Tech Park 10:00
        RouteStop(stop: _s3, departureMinutes: 620), // University 10:20
        RouteStop(stop: _s4, departureMinutes: 635), // Market Square 10:35
        RouteStop(stop: _s1, departureMinutes: 650), // Central Station 10:50
      ],
    ),
    // Bus 42A - City Express (outbound run 2)
    BusRoute(
      bus: _b1,
      stops: [
        RouteStop(stop: _s1, departureMinutes: 600), // Central Station 10:00
        RouteStop(stop: _s4, departureMinutes: 615), // Market Square 10:15
        RouteStop(stop: _s3, departureMinutes: 635), // University 10:35
        RouteStop(stop: _s6, departureMinutes: 660), // Tech Park 11:00
        RouteStop(stop: _s5, departureMinutes: 680), // Hospital 11:20
      ],
    ),
    // Bus 42A - City Express (inbound run 2 return)
    BusRoute(
      bus: _b1,
      stops: [
        RouteStop(stop: _s5, departureMinutes: 700), // Hospital 11:40
        RouteStop(stop: _s6, departureMinutes: 720), // Tech Park 12:00
        RouteStop(stop: _s3, departureMinutes: 740), // University 12:20
        RouteStop(stop: _s4, departureMinutes: 755), // Market Square 12:35
        RouteStop(stop: _s1, departureMinutes: 770), // Central Station 12:50
      ],
    ),
    // Bus 17B - Airport Shuttle (outbound run 1)
    BusRoute(
      bus: _b2,
      stops: [
        RouteStop(stop: _s2, departureMinutes: 450), // Airport 7:30
        RouteStop(stop: _s1, departureMinutes: 480), // Central Station 8:00
        RouteStop(stop: _s7, departureMinutes: 510), // Old Town 8:30
        RouteStop(stop: _s8, departureMinutes: 540), // Beach Road 9:00
      ],
    ),
    // Bus 17B - Airport Shuttle (inbound run 1 return)
    BusRoute(
      bus: _b2,
      stops: [
        RouteStop(stop: _s8, departureMinutes: 555), // Beach Road 9:15
        RouteStop(stop: _s7, departureMinutes: 585), // Old Town 9:45
        RouteStop(stop: _s1, departureMinutes: 615), // Central Station 10:15
        RouteStop(stop: _s2, departureMinutes: 645), // Airport 10:45
      ],
    ),
    // Bus 17B - Airport Shuttle (outbound run 2)
    BusRoute(
      bus: _b2,
      stops: [
        RouteStop(stop: _s2, departureMinutes: 570), // Airport 9:30
        RouteStop(stop: _s1, departureMinutes: 600), // Central Station 10:00
        RouteStop(stop: _s7, departureMinutes: 630), // Old Town 10:30
        RouteStop(stop: _s8, departureMinutes: 660), // Beach Road 11:00
      ],
    ),
    // Bus 17B - Airport Shuttle (inbound run 2 return)
    BusRoute(
      bus: _b2,
      stops: [
        RouteStop(stop: _s8, departureMinutes: 675), // Beach Road 11:15
        RouteStop(stop: _s7, departureMinutes: 705), // Old Town 11:45
        RouteStop(stop: _s1, departureMinutes: 735), // Central Station 12:15
        RouteStop(stop: _s2, departureMinutes: 765), // Airport 12:45
      ],
    ),
    // Bus 5C - University Line (outbound run 1)
    BusRoute(
      bus: _b3,
      stops: [
        RouteStop(stop: _s3, departureMinutes: 490), // University 8:10
        RouteStop(stop: _s4, departureMinutes: 510), // Market Square 8:30
        RouteStop(stop: _s1, departureMinutes: 535), // Central Station 8:55
        RouteStop(stop: _s5, departureMinutes: 555), // Hospital 9:15
      ],
    ),
    // Bus 5C - University Line (inbound run 1 return)
    BusRoute(
      bus: _b3,
      stops: [
        RouteStop(stop: _s5, departureMinutes: 570), // Hospital 9:30
        RouteStop(stop: _s1, departureMinutes: 590), // Central Station 9:50
        RouteStop(stop: _s4, departureMinutes: 615), // Market Square 10:15
        RouteStop(stop: _s3, departureMinutes: 635), // University 10:35
      ],
    ),
    // Bus 5C - University Line (outbound run 2)
    BusRoute(
      bus: _b3,
      stops: [
        RouteStop(stop: _s3, departureMinutes: 610), // University 10:10
        RouteStop(stop: _s4, departureMinutes: 630), // Market Square 10:30
        RouteStop(stop: _s1, departureMinutes: 655), // Central Station 10:55
        RouteStop(stop: _s5, departureMinutes: 675), // Hospital 11:15
      ],
    ),
    // Bus 5C - University Line (inbound run 2 return)
    BusRoute(
      bus: _b3,
      stops: [
        RouteStop(stop: _s5, departureMinutes: 690), // Hospital 11:30
        RouteStop(stop: _s1, departureMinutes: 710), // Central Station 11:50
        RouteStop(stop: _s4, departureMinutes: 735), // Market Square 12:15
        RouteStop(stop: _s3, departureMinutes: 755), // University 12:35
      ],
    ),
    // Bus 88D - Coastal Runner (outbound run 1)
    BusRoute(
      bus: _b4,
      stops: [
        RouteStop(stop: _s8, departureMinutes: 500), // Beach Road 8:20
        RouteStop(stop: _s7, departureMinutes: 520), // Old Town 8:40
        RouteStop(stop: _s4, departureMinutes: 545), // Market Square 9:05
        RouteStop(stop: _s1, departureMinutes: 570), // Central Station 9:30
        RouteStop(stop: _s2, departureMinutes: 600), // Airport 10:00
      ],
    ),
    // Bus 88D - Coastal Runner (inbound run 1 return)
    BusRoute(
      bus: _b4,
      stops: [
        RouteStop(stop: _s2, departureMinutes: 620), // Airport 10:20
        RouteStop(stop: _s1, departureMinutes: 650), // Central Station 10:50
        RouteStop(stop: _s4, departureMinutes: 675), // Market Square 11:15
        RouteStop(stop: _s7, departureMinutes: 700), // Old Town 11:40
        RouteStop(stop: _s8, departureMinutes: 720), // Beach Road 12:00
      ],
    ),
    // Bus 33E - Metro Link (outbound run 1)
    BusRoute(
      bus: _b5,
      stops: [
        RouteStop(stop: _s6, departureMinutes: 480), // Tech Park 8:00
        RouteStop(stop: _s3, departureMinutes: 500), // University 8:20
        RouteStop(stop: _s4, departureMinutes: 520), // Market Square 8:40
        RouteStop(stop: _s7, departureMinutes: 545), // Old Town 9:05
        RouteStop(stop: _s8, departureMinutes: 570), // Beach Road 9:30
      ],
    ),
    // Bus 33E - Metro Link (inbound run 1 return)
    BusRoute(
      bus: _b5,
      stops: [
        RouteStop(stop: _s8, departureMinutes: 590), // Beach Road 9:50
        RouteStop(stop: _s7, departureMinutes: 615), // Old Town 10:15
        RouteStop(stop: _s4, departureMinutes: 640), // Market Square 10:40
        RouteStop(stop: _s3, departureMinutes: 660), // University 11:00
        RouteStop(stop: _s6, departureMinutes: 680), // Tech Park 11:20
      ],
    ),
    // Bus 33E - Metro Link (outbound run 2)
    BusRoute(
      bus: _b5,
      stops: [
        RouteStop(stop: _s6, departureMinutes: 600), // Tech Park 10:00
        RouteStop(stop: _s3, departureMinutes: 620), // University 10:20
        RouteStop(stop: _s4, departureMinutes: 640), // Market Square 10:40
        RouteStop(stop: _s7, departureMinutes: 665), // Old Town 11:05
        RouteStop(stop: _s8, departureMinutes: 690), // Beach Road 11:30
      ],
    ),
    // Bus 33E - Metro Link (inbound run 2 return)
    BusRoute(
      bus: _b5,
      stops: [
        RouteStop(stop: _s8, departureMinutes: 710), // Beach Road 11:50
        RouteStop(stop: _s7, departureMinutes: 735), // Old Town 12:15
        RouteStop(stop: _s4, departureMinutes: 760), // Market Square 12:40
        RouteStop(stop: _s3, departureMinutes: 780), // University 13:00
        RouteStop(stop: _s6, departureMinutes: 800), // Tech Park 13:20
      ],
    ),
    // Bus 11F - Night Connector (outbound)
    BusRoute(
      bus: _b6,
      stops: [
        RouteStop(stop: _s1, departureMinutes: 1080), // Central Station 18:00
        RouteStop(stop: _s7, departureMinutes: 1100), // Old Town 18:20
        RouteStop(stop: _s8, departureMinutes: 1120), // Beach Road 18:40
        RouteStop(stop: _s2, departureMinutes: 1145), // Airport 19:05
      ],
    ),
    // Bus 11F - Night Connector (return)
    BusRoute(
      bus: _b6,
      stops: [
        RouteStop(stop: _s2, departureMinutes: 1160), // Airport 19:20
        RouteStop(stop: _s8, departureMinutes: 1185), // Beach Road 19:45
        RouteStop(stop: _s7, departureMinutes: 1205), // Old Town 20:05
        RouteStop(stop: _s1, departureMinutes: 1225), // Central Station 20:25
      ],
    ),
  ];

  @override
  List<Bus> getAllBuses() => List.unmodifiable(_buses);

  @override
  List<Stop> getAllStops() => List.unmodifiable(_stops);

  @override
  List<BusRoute> getAllRoutes() => List.unmodifiable(_routes);
}
