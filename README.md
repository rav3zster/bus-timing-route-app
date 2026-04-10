# smart_bus_assistant

Smart Bus Timing & Route Assistant built with Flutter.

## Dummy Bus Data

The app ships with mock data in [lib/data/mock_bus_repository.dart](lib/data/mock_bus_repository.dart) that includes:

- Real Mangalore route 13-series services (`13`, `13A`, `13B`, `13C`, `13D`)
- Ordered stop lists for each route variant
- Outbound and return routes for each service direction
- Time-ordered stop sequences for each trip

Route constraints are modeled so that:

- A bus can only be boarded in the listed order of stops for that trip
- Reverse travel requires a dedicated return route
- Return routes start after the corresponding outbound trip ends

## Run

```bash
flutter pub get
flutter run -d chrome
```

## Test

```bash
flutter test
```
