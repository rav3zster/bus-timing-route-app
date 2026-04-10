import 'package:flutter/material.dart';
import '../../domain/search_state.dart';
import '../../domain/time_calculator.dart';
import 'bus_card.dart';

class ResultsPanel extends StatelessWidget {
  final SearchState state;
  final TimeCalculator timeCalculator;

  const ResultsPanel({
    super.key,
    required this.state,
    required this.timeCalculator,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return switch (state) {
      IdleState() => _IdleHint(),
      ErrorState() => const SizedBox.shrink(),
      StopBoardState(:final stop, :final buses) =>
        buses.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.directions_bus_outlined,
                      size: 40,
                      color: cs.outline,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'NO UPCOMING BUSES',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        letterSpacing: 3,
                        color: cs.secondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'No buses at ${stop.name} right now.',
                      style: TextStyle(fontSize: 12, color: cs.outline),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.place_outlined,
                          size: 13,
                          color: cs.secondary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            stop.name.toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 10,
                              letterSpacing: 3,
                              color: cs.secondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'NEXT ${buses.length}',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 10,
                            letterSpacing: 2,
                            color: cs.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: buses.length,
                      itemBuilder: (context, index) => BusCard(
                        result: buses[index],
                        isHighlighted: index == 0,
                        timeCalculator: timeCalculator,
                      ),
                    ),
                  ),
                ],
              ),
      LoadingState() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: cs.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'SEARCHING...',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                letterSpacing: 3,
                color: cs.secondary,
              ),
            ),
          ],
        ),
      ),
      EmptyState() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.directions_bus_outlined, size: 40, color: cs.outline),
            const SizedBox(height: 16),
            Text(
              'NO BUSES FOUND',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                letterSpacing: 3,
                color: cs.secondary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try a different route or check back later.',
              style: TextStyle(fontSize: 12, color: cs.outline),
            ),
          ],
        ),
      ),
      ResultsState(:final buses) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Row(
              children: [
                Text(
                  'AVAILABLE',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10,
                    letterSpacing: 3,
                    color: cs.secondary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: cs.outline),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${buses.length}',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 10,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: buses.length,
              itemBuilder: (context, index) => BusCard(
                result: buses[index],
                isHighlighted: index == 0,
                timeCalculator: timeCalculator,
              ),
            ),
          ),
        ],
      ),
    };
  }
}

class _IdleHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.route_outlined, size: 40, color: cs.outline),
          const SizedBox(height: 16),
          Text(
            'SELECT STOPS TO BEGIN',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              letterSpacing: 3,
              color: cs.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
