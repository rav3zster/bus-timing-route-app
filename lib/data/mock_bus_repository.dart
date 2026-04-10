import '../domain/models.dart';
import 'bus_repository.dart';

class MockBusRepository implements BusRepository {
  MockBusRepository._();
  static final MockBusRepository instance = MockBusRepository._();

  static const _serviceStartMinutes = 6 * 60; // 06:00
  static const _serviceEndMinutes = 21 * 60 + 30; // 21:30

  static const _busNamesPool = [
    'Golden',
    'Devi Prasad',
    'Navadurga',
    'Sri Durga',
    'Mahaveer',
    'Ganesh',
    'Lakshmi',
    'Sai Krupa',
  ];

  // Stops
  static const _sStateBank = Stop(id: 's1', name: 'State Bank');
  static const _sCarStreet = Stop(id: 's2', name: 'Car Street');
  static const _sMannagudda = Stop(id: 's3', name: 'Mannagudda');
  static const _sLadyhill = Stop(id: 's4', name: 'Ladyhill');
  static const _sChilimbi = Stop(id: 's5', name: 'Chilimbi');
  static const _sUrvaStores = Stop(id: 's6', name: 'Urva Stores');
  static const _sKottara = Stop(id: 's7', name: 'Kottara');
  static const _sKulur = Stop(id: 's8', name: 'Kulur');
  static const _sPanjimogaru = Stop(id: 's9', name: 'Panjimogaru');
  static const _sKavoor = Stop(id: 's10', name: 'Kavoor');
  static const _sMarakada = Stop(id: 's11', name: 'Marakada');
  static const _sKunjathbail = Stop(id: 's12', name: 'Kunjathbail');
  static const _sKsRaoRoad = Stop(id: 's13', name: 'K.S. Rao Road');
  static const _sLalbagh = Stop(id: 's14', name: 'Lalbagh');
  static const _sKuloor = Stop(id: 's15', name: 'Kuloor');
  static const _sKudremukhHousing = Stop(
    id: 's16',
    name: 'Kudremukh Housing Colony',
  );
  static const _sHudcoColony = Stop(id: 's17', name: 'Hudco Colony');
  static const _sGovtWomensPoly = Stop(
    id: 's18',
    name: 'Govt Womens Polytechnic',
  );
  static const _sGovtQuarters = Stop(id: 's19', name: 'Govt Quarters');
  static const _sBondel = Stop(id: 's20', name: 'Bondel');
  static const _sPadangady = Stop(id: 's21', name: 'Padangady');
  static const _sPacchanady = Stop(id: 's22', name: 'Pacchanady');

  static const _stops = [
    _sStateBank,
    _sCarStreet,
    _sMannagudda,
    _sLadyhill,
    _sChilimbi,
    _sUrvaStores,
    _sKottara,
    _sKulur,
    _sPanjimogaru,
    _sKavoor,
    _sMarakada,
    _sKunjathbail,
    _sKsRaoRoad,
    _sLalbagh,
    _sKuloor,
    _sKudremukhHousing,
    _sHudcoColony,
    _sGovtWomensPoly,
    _sGovtQuarters,
    _sBondel,
    _sPadangady,
    _sPacchanady,
  ];

  static const _routeSummaries = [
    Bus(id: 'route13', number: '13', name: 'State Bank to Urva Stores'),
    Bus(id: 'route13a', number: '13A', name: 'State Bank to Kottara'),
    Bus(id: 'route13b', number: '13B', name: 'State Bank to Kunjathbail'),
    Bus(id: 'route13c', number: '13C', name: 'State Bank to Bondel'),
    Bus(id: 'route13d', number: '13D', name: 'State Bank to Pacchanady'),
  ];

  static final List<_RouteTemplate> _templates = [
    _RouteTemplate(
      id: 'route13',
      number: '13',
      frequencyMinutes: 15,
      stops: [
        _sStateBank,
        _sCarStreet,
        _sMannagudda,
        _sLadyhill,
        _sChilimbi,
        _sUrvaStores,
      ],
      offsets: [0, 8, 16, 24, 32, 40],
    ),
    _RouteTemplate(
      id: 'route13a',
      number: '13A',
      frequencyMinutes: 15,
      stops: [
        _sStateBank,
        _sCarStreet,
        _sMannagudda,
        _sLadyhill,
        _sChilimbi,
        _sUrvaStores,
        _sKottara,
      ],
      offsets: [0, 8, 16, 24, 32, 40, 50],
    ),
    _RouteTemplate(
      id: 'route13b',
      number: '13B',
      frequencyMinutes: 15,
      stops: [
        _sStateBank,
        _sCarStreet,
        _sLadyhill,
        _sKulur,
        _sPanjimogaru,
        _sKavoor,
        _sMarakada,
        _sKunjathbail,
      ],
      offsets: [0, 8, 18, 28, 38, 48, 58, 68],
    ),
    _RouteTemplate(
      id: 'route13c',
      number: '13C',
      frequencyMinutes: 15,
      stops: [
        _sStateBank,
        _sKsRaoRoad,
        _sLalbagh,
        _sLadyhill,
        _sKuloor,
        _sKudremukhHousing,
        _sHudcoColony,
        _sGovtWomensPoly,
        _sGovtQuarters,
        _sKavoor,
        _sBondel,
      ],
      offsets: [0, 5, 10, 16, 24, 32, 38, 44, 50, 58, 66],
    ),
    _RouteTemplate(
      id: 'route13d',
      number: '13D',
      frequencyMinutes: 120,
      stops: [
        _sStateBank,
        _sKsRaoRoad,
        _sLalbagh,
        _sLadyhill,
        _sKuloor,
        _sKudremukhHousing,
        _sHudcoColony,
        _sGovtWomensPoly,
        _sGovtQuarters,
        _sKavoor,
        _sBondel,
        _sPadangady,
        _sPacchanady,
      ],
      offsets: [0, 5, 10, 16, 24, 32, 38, 44, 50, 58, 66, 74, 82],
    ),
  ];

  late final List<BusRoute> _routes = _generateRoutes();

  List<BusRoute> _generateRoutes() {
    final generated = <BusRoute>[];

    for (
      var templateIndex = 0;
      templateIndex < _templates.length;
      templateIndex++
    ) {
      final template = _templates[templateIndex];
      var tripStart = _serviceStartMinutes;
      var tripIndex = 0;

      while (tripStart <= _serviceEndMinutes) {
        final busName =
            _busNamesPool[(templateIndex + tripIndex) % _busNamesPool.length];

        generated.add(
          BusRoute(
            bus: Bus(id: template.id, number: template.number, name: busName),
            stops: List.generate(template.stops.length, (i) {
              return RouteStop(
                stop: template.stops[i],
                departureMinutes: tripStart + template.offsets[i],
              );
            }),
          ),
        );

        tripStart += template.frequencyMinutes;
        tripIndex++;
      }
    }

    return generated;
  }

  @override
  List<Bus> getAllBuses() => List.unmodifiable(_routeSummaries);

  @override
  List<Stop> getAllStops() => List.unmodifiable(_stops);

  @override
  List<BusRoute> getAllRoutes() => List.unmodifiable(_routes);
}

class _RouteTemplate {
  final String id;
  final String number;
  final int frequencyMinutes;
  final List<Stop> stops;
  final List<int> offsets;

  const _RouteTemplate({
    required this.id,
    required this.number,
    required this.frequencyMinutes,
    required this.stops,
    required this.offsets,
  });
}
