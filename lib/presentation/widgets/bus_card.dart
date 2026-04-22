import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/models.dart';
import '../../domain/time_calculator.dart';
import '../app_theme.dart';

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
    final c = context.appColors;
    final dep = timeCalculator.formatDepartureTime(result.departureMinutes);
    final arr = timeCalculator.formatDepartureTime(
      result.arrivalMinutes ?? result.departureMinutes,
    );
    final remaining = timeCalculator.formatDuration(result.timeUntilDeparture);
    final stops = result.routePreview.map((s) => s.name).toList();

    // Highlighted card: inverted with accent bg
    final cardBg = isHighlighted ? c.accent : c.surface;
    final cardText = isHighlighted ? c.accentText : c.text;
    final cardSub = isHighlighted
        ? c.accentText.withValues(alpha: 0.6)
        : c.textSub;
    final cardDim = isHighlighted
        ? c.accentText.withValues(alpha: 0.35)
        : c.textDim;
    final badgeBg = isHighlighted ? c.accentText.withValues(alpha: 0.15) : c.badge;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border(
          bottom: BorderSide(color: c.border),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bus number badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4,
                  ),
                  color: badgeBg,
                  child: Text(
                    result.bus.number,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12, fontWeight: FontWeight.w700,
                      letterSpacing: 1, color: cardText,
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isHighlighted)
                        Text(
                          '● NEXT',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 8, fontWeight: FontWeight.w700,
                            letterSpacing: 2, color: cardDim,
                          ),
                        ),
                      Text(
                        result.bus.name,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 14, fontWeight: FontWeight.w600,
                          color: cardText,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Time block
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$dep → $arr',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 14, fontWeight: FontWeight.w700,
                        color: cardText, letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'in $remaining',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 10, color: cardSub, letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Route strip
            _RouteStrip(stops: stops, textColor: cardText, dimColor: cardDim),
          ],
        ),
      ),
    );
  }
}

class _RouteStrip extends StatelessWidget {
  final List<String> stops;
  final Color textColor;
  final Color dimColor;

  const _RouteStrip({
    required this.stops,
    required this.textColor,
    required this.dimColor,
  });

  @override
  Widget build(BuildContext context) {
    if (stops.isEmpty) return const SizedBox.shrink();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < stops.length; i++) ...[
            Text(
              stops[i],
              style: GoogleFonts.spaceGrotesk(
                fontSize: 10,
                fontWeight: i == 0 || i == stops.length - 1
                    ? FontWeight.w600 : FontWeight.w400,
                color: i == 0 || i == stops.length - 1 ? textColor : dimColor,
              ),
            ),
            if (i < stops.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text('·', style: TextStyle(color: dimColor, fontSize: 12)),
              ),
          ],
        ],
      ),
    );
  }
}
