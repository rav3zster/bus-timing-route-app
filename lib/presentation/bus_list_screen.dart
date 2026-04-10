import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';

class BusListScreen extends ConsumerWidget {
  const BusListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buses = ref.read(busRepositoryProvider).getAllBuses();
    final routes = ref.read(busRepositoryProvider).getAllRoutes();
    final calc = ref.read(timeCalculatorProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: cs.outline),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        size: 18,
                        color: cs.secondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ALL BUSES',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          letterSpacing: 4,
                          color: cs.secondary,
                        ),
                      ),
                      Text(
                        '${buses.length} routes',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Divider(color: cs.outline, height: 1),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: buses.length,
                itemBuilder: (context, index) {
                  final bus = buses[index];
                  final busRoutes = routes
                      .where((r) => r.bus.id == bus.id)
                      .toList();

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141414),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF2A2A2A)),
                    ),
                    child: Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        childrenPadding: const EdgeInsets.fromLTRB(
                          16,
                          0,
                          16,
                          12,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            bus.number,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        title: Text(
                          bus.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          '${busRoutes.length} run${busRoutes.length != 1 ? 's' : ''}',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 10,
                            letterSpacing: 1,
                            color: cs.secondary,
                          ),
                        ),
                        iconColor: cs.secondary,
                        collapsedIconColor: cs.secondary,
                        children: busRoutes.map((route) {
                          final first = route.stops.first;
                          final last = route.stops.last;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(color: cs.outline, height: 1),
                                const SizedBox(height: 10),
                                // Run header: first stop time → last stop time
                                Row(
                                  children: [
                                    Text(
                                      calc.formatDepartureTime(
                                        first.departureMinutes,
                                      ),
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Icon(
                                        Icons.arrow_forward,
                                        size: 12,
                                        color: cs.secondary,
                                      ),
                                    ),
                                    Text(
                                      calc.formatDepartureTime(
                                        last.departureMinutes,
                                      ),
                                      style: TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: cs.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // All stops
                                ...route.stops.map(
                                  (rs) => Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: cs.secondary,
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            rs.stop.name,
                                            style: const TextStyle(
                                              fontFamily: 'monospace',
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          calc.formatDepartureTime(
                                            rs.departureMinutes,
                                          ),
                                          style: TextStyle(
                                            fontFamily: 'monospace',
                                            fontSize: 11,
                                            color: cs.secondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
