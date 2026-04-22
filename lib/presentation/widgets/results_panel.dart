import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/models.dart';
import '../../domain/search_state.dart';
import '../../domain/time_calculator.dart';
import '../app_theme.dart';
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
    final c = context.appColors;
    return switch (state) {
      IdleState() => _IdleHint(c: c),
      ErrorState() => const SizedBox.shrink(),
      LoadingState() => _LoadingView(c: c),
      EmptyState() => _EmptyView(message: 'NO BUSES FOUND', c: c),
      StopBoardState(:final stop, :final buses) => buses.isEmpty
          ? _EmptyView(
              message: 'NO BUSES AT\n${stop.name.toUpperCase()}',
              c: c,
            )
          : _BusList(
              buses: buses,
              timeCalculator: timeCalculator,
              label: stop.name.toUpperCase(),
              badge: 'NEXT ${buses.length}',
              c: c,
            ),
      ResultsState(:final buses) => _BusList(
          buses: buses,
          timeCalculator: timeCalculator,
          label: 'AVAILABLE',
          badge: '${buses.length}',
          c: c,
        ),
    };
  }
}

// ── Bus list ──────────────────────────────────────────────────────────────────

class _BusList extends StatelessWidget {
  final List<BusResult> buses;
  final TimeCalculator timeCalculator;
  final String label;
  final String badge;
  final AppColors c;

  const _BusList({
    required this.buses,
    required this.timeCalculator,
    required this.label,
    required this.badge,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Row(
            children: [
              Text(
                label,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 9, fontWeight: FontWeight.w600,
                  letterSpacing: 3, color: c.textSub,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: c.border),
                ),
                child: Text(
                  badge,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 9, color: c.textSub, letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: buses.length,
            itemBuilder: (context, i) => BusCard(
              result: buses[i],
              isHighlighted: i == 0,
              timeCalculator: timeCalculator,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Idle ──────────────────────────────────────────────────────────────────────

class _IdleHint extends StatelessWidget {
  final AppColors c;
  const _IdleHint({required this.c});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: c.border),
            ),
            child: Icon(Icons.route_outlined, size: 22, color: c.textDim),
          ),
          const SizedBox(height: 20),
          Text(
            'SELECT STOPS TO BEGIN',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 10, fontWeight: FontWeight.w500,
              letterSpacing: 3, color: c.textSub,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Loading ───────────────────────────────────────────────────────────────────

class _LoadingView extends StatefulWidget {
  final AppColors c;
  const _LoadingView({required this.c});

  @override
  State<_LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<_LoadingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.c;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _ctrl,
            builder: (context, _) {
              final active = (_ctrl.value * 5).floor() % 5;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  5,
                  (i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == active ? c.accent : c.border,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            'SEARCHING...',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 10, letterSpacing: 3, color: c.textSub,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty ─────────────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  final String message;
  final AppColors c;
  const _EmptyView({required this.message, required this.c});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: c.border),
            ),
            child: Icon(
              Icons.directions_bus_outlined, size: 22, color: c.textDim,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 10, fontWeight: FontWeight.w500,
              letterSpacing: 3, color: c.textSub,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
