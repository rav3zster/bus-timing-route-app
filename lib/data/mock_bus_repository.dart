import '../domain/models.dart';
import 'bus_repository.dart';

class MockBusRepository implements BusRepository {
  MockBusRepository._();
  static final MockBusRepository instance = MockBusRepository._();

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

  // Buses
  static const _b13 = Bus(id: 'b13', number: '13', name: 'State Bank to Urva Stores');
  static const _b13a = Bus(id: 'b13a', number: '13A', name: 'State Bank to Kottara');
  static const _b13b = Bus(
    id: 'b13b',
    number: '13B',
    name: 'State Bank to Kunjathbail',
  );
  static const _b13c = Bus(id: 'b13c', number: '13C', name: 'State Bank to Bondel');
  static const _b13d = Bus(id: 'b13d', number: '13D', name: 'State Bank to Pacchanady');

  static const _buses = [_b13, _b13a, _b13b, _b13c, _b13d];

  // Routes with return trips to support reverse travel only on dedicated routes.
  static const _routes = [
    // 13 outbound
    BusRoute(
      bus: _b13,
      stops: [
        RouteStop(stop: _sStateBank, departureMinutes: 420),
        RouteStop(stop: _sCarStreet, departureMinutes: 428),
        RouteStop(stop: _sMannagudda, departureMinutes: 436),
        RouteStop(stop: _sLadyhill, departureMinutes: 444),
        RouteStop(stop: _sChilimbi, departureMinutes: 452),
        RouteStop(stop: _sUrvaStores, departureMinutes: 460),
      ],
    ),
    // 13 return
    BusRoute(
      bus: _b13,
      stops: [
        RouteStop(stop: _sUrvaStores, departureMinutes: 475),
        RouteStop(stop: _sChilimbi, departureMinutes: 483),
        RouteStop(stop: _sLadyhill, departureMinutes: 491),
        RouteStop(stop: _sMannagudda, departureMinutes: 499),
        RouteStop(stop: _sCarStreet, departureMinutes: 507),
        RouteStop(stop: _sStateBank, departureMinutes: 515),
      ],
    ),
    // 13A outbound
    BusRoute(
      bus: _b13a,
      stops: [
        RouteStop(stop: _sStateBank, departureMinutes: 450),
        RouteStop(stop: _sCarStreet, departureMinutes: 458),
        RouteStop(stop: _sMannagudda, departureMinutes: 466),
        RouteStop(stop: _sLadyhill, departureMinutes: 474),
        RouteStop(stop: _sChilimbi, departureMinutes: 482),
        RouteStop(stop: _sUrvaStores, departureMinutes: 490),
        RouteStop(stop: _sKottara, departureMinutes: 500),
      ],
    ),
    // 13A return
    BusRoute(
      bus: _b13a,
      stops: [
        RouteStop(stop: _sKottara, departureMinutes: 515),
        RouteStop(stop: _sUrvaStores, departureMinutes: 525),
        RouteStop(stop: _sChilimbi, departureMinutes: 533),
        RouteStop(stop: _sLadyhill, departureMinutes: 541),
        RouteStop(stop: _sMannagudda, departureMinutes: 549),
        RouteStop(stop: _sCarStreet, departureMinutes: 557),
        RouteStop(stop: _sStateBank, departureMinutes: 565),
      ],
    ),
    // 13B outbound
    BusRoute(
      bus: _b13b,
      stops: [
        RouteStop(stop: _sStateBank, departureMinutes: 480),
        RouteStop(stop: _sCarStreet, departureMinutes: 488),
        RouteStop(stop: _sLadyhill, departureMinutes: 498),
        RouteStop(stop: _sKulur, departureMinutes: 508),
        RouteStop(stop: _sPanjimogaru, departureMinutes: 518),
        RouteStop(stop: _sKavoor, departureMinutes: 528),
        RouteStop(stop: _sMarakada, departureMinutes: 538),
        RouteStop(stop: _sKunjathbail, departureMinutes: 548),
      ],
    ),
    // 13B return
    BusRoute(
      bus: _b13b,
      stops: [
        RouteStop(stop: _sKunjathbail, departureMinutes: 565),
        RouteStop(stop: _sMarakada, departureMinutes: 575),
        RouteStop(stop: _sKavoor, departureMinutes: 585),
        RouteStop(stop: _sPanjimogaru, departureMinutes: 595),
        RouteStop(stop: _sKulur, departureMinutes: 605),
        RouteStop(stop: _sLadyhill, departureMinutes: 615),
        RouteStop(stop: _sCarStreet, departureMinutes: 625),
        RouteStop(stop: _sStateBank, departureMinutes: 633),
      ],
    ),
    // 13C outbound
    BusRoute(
      bus: _b13c,
      stops: [
        RouteStop(stop: _sStateBank, departureMinutes: 510),
        RouteStop(stop: _sKsRaoRoad, departureMinutes: 518),
        RouteStop(stop: _sLalbagh, departureMinutes: 526),
        RouteStop(stop: _sLadyhill, departureMinutes: 536),
        RouteStop(stop: _sKuloor, departureMinutes: 546),
        RouteStop(stop: _sKudremukhHousing, departureMinutes: 556),
        RouteStop(stop: _sHudcoColony, departureMinutes: 564),
        RouteStop(stop: _sGovtWomensPoly, departureMinutes: 572),
        RouteStop(stop: _sGovtQuarters, departureMinutes: 580),
        RouteStop(stop: _sKavoor, departureMinutes: 590),
        RouteStop(stop: _sBondel, departureMinutes: 600),
      ],
    ),
    // 13C return
    BusRoute(
      bus: _b13c,
      stops: [
        RouteStop(stop: _sBondel, departureMinutes: 620),
        RouteStop(stop: _sKavoor, departureMinutes: 630),
        RouteStop(stop: _sGovtQuarters, departureMinutes: 640),
        RouteStop(stop: _sGovtWomensPoly, departureMinutes: 648),
        RouteStop(stop: _sHudcoColony, departureMinutes: 656),
        RouteStop(stop: _sKudremukhHousing, departureMinutes: 664),
        RouteStop(stop: _sKuloor, departureMinutes: 674),
        RouteStop(stop: _sLadyhill, departureMinutes: 684),
        RouteStop(stop: _sLalbagh, departureMinutes: 694),
        RouteStop(stop: _sKsRaoRoad, departureMinutes: 702),
        RouteStop(stop: _sStateBank, departureMinutes: 710),
      ],
    ),
    // 13D outbound
    BusRoute(
      bus: _b13d,
      stops: [
        RouteStop(stop: _sStateBank, departureMinutes: 540),
        RouteStop(stop: _sKsRaoRoad, departureMinutes: 548),
        RouteStop(stop: _sLalbagh, departureMinutes: 556),
        RouteStop(stop: _sLadyhill, departureMinutes: 566),
        RouteStop(stop: _sKuloor, departureMinutes: 576),
        RouteStop(stop: _sKudremukhHousing, departureMinutes: 586),
        RouteStop(stop: _sHudcoColony, departureMinutes: 594),
        RouteStop(stop: _sGovtWomensPoly, departureMinutes: 602),
        RouteStop(stop: _sGovtQuarters, departureMinutes: 610),
        RouteStop(stop: _sKavoor, departureMinutes: 620),
        RouteStop(stop: _sBondel, departureMinutes: 630),
        RouteStop(stop: _sPadangady, departureMinutes: 642),
        RouteStop(stop: _sPacchanady, departureMinutes: 654),
      ],
    ),
    // 13D return
    BusRoute(
      bus: _b13d,
      stops: [
        RouteStop(stop: _sPacchanady, departureMinutes: 675),
        RouteStop(stop: _sPadangady, departureMinutes: 687),
        RouteStop(stop: _sBondel, departureMinutes: 699),
        RouteStop(stop: _sKavoor, departureMinutes: 709),
        RouteStop(stop: _sGovtQuarters, departureMinutes: 719),
        RouteStop(stop: _sGovtWomensPoly, departureMinutes: 727),
        RouteStop(stop: _sHudcoColony, departureMinutes: 735),
        RouteStop(stop: _sKudremukhHousing, departureMinutes: 743),
        RouteStop(stop: _sKuloor, departureMinutes: 753),
        RouteStop(stop: _sLadyhill, departureMinutes: 763),
        RouteStop(stop: _sLalbagh, departureMinutes: 773),
        RouteStop(stop: _sKsRaoRoad, departureMinutes: 781),
        RouteStop(stop: _sStateBank, departureMinutes: 789),
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
