import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_theme.dart';
import 'providers.dart';

class BusListScreen extends ConsumerWidget {
  const BusListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final buses = ref.read(busRepositoryProvider).getAllBuses();
    final routes = ref.read(busRepositoryProvider).getAllRoutes();
    final calc = ref.read(timeCalculatorProvider);

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: c.border),
                        color: c.surface,
                      ),
                      child: Icon(Icons.arrow_back, size: 16, color: c.textSub),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ALL BUSES',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 10, fontWeight: FontWeight.w500,
                            letterSpacing: 4, color: c.textSub,
                          ),
                        ),
                        Text(
                          '${buses.length} routes',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 18, fontWeight: FontWeight.w700,
                            color: c.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(height: 1, color: c.border),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: buses.length,
                itemBuilder: (context, index) {
                  final bus = buses[index];
                  final busRoutes =
                      routes.where((r) => r.bus.id == bus.id).toList();

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: c.border),
                      ),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: c.surface,
                      ),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 8,
                        ),
                        childrenPadding: const EdgeInsets.only(bottom: 12),
                        leading: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4,
                          ),
                          color: c.badge,
                          child: Text(
                            bus.number,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 12, fontWeight: FontWeight.w700,
                              letterSpacing: 1, color: c.text,
                            ),
                          ),
                        ),
                        title: Text(
                          bus.name,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 13, fontWeight: FontWeight.w600,
                            color: c.text,
                          ),
                        ),
                        subtitle: Text(
                          '${busRoutes.length} run${busRoutes.length != 1 ? 's' : ''}',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 10, letterSpacing: 1, color: c.textSub,
                          ),
                        ),
                        iconColor: c.textDim,
                        collapsedIconColor: c.textDim,
                        children: busRoutes.map((route) {
                          final first = route.stops.first;
                          final last = route.stops.last;

                          return Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Time range
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        calc.formatDepartureTime(
                                          first.departureMinutes,
                                        ),
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: c.text,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Icon(
                                          Icons.arrow_forward,
                                          size: 11, color: c.textDim,
                                        ),
                                      ),
                                      Text(
                                        calc.formatDepartureTime(
                                          last.departureMinutes,
                                        ),
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: c.textSub,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Stop list with timeline
                                ...route.stops.asMap().entries.map((entry) {
                                  final i = entry.key;
                                  final rs = entry.value;
                                  final isFirst = i == 0;
                                  final isLast = i == route.stops.length - 1;

                                  return IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 16,
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 6, height: 6,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: isFirst || isLast
                                                      ? c.accent
                                                      : Colors.transparent,
                                                  border: Border.all(
                                                    color: isFirst || isLast
                                                        ? c.accent
                                                        : c.border,
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                              if (!isLast)
                                                Expanded(
                                                  child: Container(
                                                    width: 1,
                                                    color: c.border,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 8,
                                            ),
                                            child: Text(
                                              rs.stop.name,
                                              style: GoogleFonts.spaceGrotesk(
                                                fontSize: 11,
                                                fontWeight: isFirst || isLast
                                                    ? FontWeight.w600
                                                    : FontWeight.w400,
                                                color: isFirst || isLast
                                                    ? c.text
                                                    : c.textSub,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 8,
                                          ),
                                          child: Text(
                                            calc.formatDepartureTime(
                                              rs.departureMinutes,
                                            ),
                                            style: GoogleFonts.spaceGrotesk(
                                              fontSize: 10,
                                              color: isFirst || isLast
                                                  ? c.text
                                                  : c.textDim,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
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
