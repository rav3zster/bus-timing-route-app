import 'package:flutter/material.dart';
import '../../domain/models.dart';
import '../../domain/time_calculator.dart';

class BusCard extends StatelessWidget {
  final BusResult result;
  final bool isHighlighted;
  final TimeCalculator timeCalculator;

  const BusCard({
    super.key,
    required this.result,
    required this.isHighlighted,
    required this.timeCalculator,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final departureTime = timeCalculator.formatDepartureTime(
      result.departureMinutes,
    );
    final timeRemaining = timeCalculator.formatDuration(
      result.timeUntilDeparture,
    );
    final routeStops = result.routePreview.map((s) => s.name).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isHighlighted
            ? const Color(0xFF1E1E1E)
            : const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighlighted ? Colors.white : const Color(0xFF2A2A2A),
          width: isHighlighted ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row: bus number + badge + time ──────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bus number pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isHighlighted
                        ? Colors.white
                        : const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    result.bus.number,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      color: isHighlighted ? Colors.black : Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.bus.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (isHighlighted) ...[
                        const SizedBox(height: 2),
                        Text(
                          '● NEXT BUS',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 9,
                            letterSpacing: 2,
                            color: cs.secondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Departure time block
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      departureTime,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      'in $timeRemaining',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10,
                        color: isHighlighted ? Colors.white : cs.secondary,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 14),
            Divider(color: cs.outline, height: 1),
            const SizedBox(height: 12),

            // ── Route preview ────────────────────────────────────────
            _RoutePreview(stops: routeStops),
          ],
        ),
      ),
    );
  }
}

class _RoutePreview extends StatelessWidget {
  final List<String> stops;
  const _RoutePreview({required this.stops});

  @override
  Widget build(BuildContext context) {
    if (stops.isEmpty) return const SizedBox.shrink();

    return Row(
      children: [
        Icon(
          Icons.linear_scale_rounded,
          size: 14,
          color: Theme.of(context).colorScheme.secondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < stops.length; i++) ...[
                  Text(
                    stops[i],
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: i == 0 || i == stops.length - 1
                          ? Colors.white
                          : const Color(0xFF555555),
                      fontWeight: i == 0 || i == stops.length - 1
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  if (i < stops.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        '›',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
