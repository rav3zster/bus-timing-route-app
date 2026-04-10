import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/search_state.dart';
import 'bus_list_screen.dart';
import 'providers.dart';
import 'widgets/results_panel.dart';
import 'widgets/stop_autocomplete_field.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Timer _clockTimer;
  DateTime _currentTime = DateTime.now();
  int _selectedMode = 0; // 0 = Stop Board, 1 = Route Search

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _currentTime = DateTime.now());
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  String _formatDate(DateTime dt) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return '${days[dt.weekday - 1]}  ${dt.day}  ${months[dt.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchNotifierProvider);
    final notifier = ref.read(searchNotifierProvider.notifier);
    final stops = ref.read(busRepositoryProvider).getAllStops();
    final timeCalculator = ref.read(timeCalculatorProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SMART BUS',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            letterSpacing: 4,
                            color: cs.secondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Route Assistant',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                  // Clock
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatTime(_currentTime),
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatDate(_currentTime),
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 10,
                          letterSpacing: 2,
                          color: cs.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Divider(color: cs.outline, height: 1),
            const SizedBox(height: 16),

            // ── Mode Toggle ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _ModeTab(
                      icon: Icons.place_outlined,
                      label: 'STOP BOARD',
                      sublabel: 'Next buses at stop',
                      selected: _selectedMode == 0,
                      onTap: () {
                        setState(() => _selectedMode = 0);
                        notifier.resetToIdle();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ModeTab(
                      icon: Icons.route_outlined,
                      label: 'ROUTE SEARCH',
                      sublabel: 'Find buses between stops',
                      selected: _selectedMode == 1,
                      onTap: () {
                        setState(() => _selectedMode = 1);
                        notifier.resetToIdle();
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Divider(color: cs.outline, height: 1),
            const SizedBox(height: 16),

            // ── Mode Content ────────────────────────────────────────
            if (_selectedMode == 0) ...[
              // Stop Board mode
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _FieldLabel(label: 'YOUR STOP'),
                    const SizedBox(height: 6),
                    StopAutocompleteField(
                      key: ValueKey('stopboard_${notifier.selectedSource?.id}'),
                      label: 'Select your bus stop',
                      stops: stops,
                      initialValue: notifier.selectedSource,
                      onSelected: (stop) => notifier.setSource(stop),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Route Search mode
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _FieldLabel(label: 'FROM'),
                    const SizedBox(height: 6),
                    StopAutocompleteField(
                      key: ValueKey('source_${notifier.selectedSource?.id}'),
                      label: 'Select origin stop',
                      stops: stops,
                      initialValue: notifier.selectedSource,
                      onSelected: (stop) => notifier.setSource(stop),
                    ),
                    // Swap row
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Expanded(child: Divider(color: cs.outline)),
                          GestureDetector(
                            onTap: () {
                              notifier.swapStops();
                              setState(() {});
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: cs.outline),
                                borderRadius: BorderRadius.circular(8),
                                color: const Color(0xFF141414),
                              ),
                              child: Icon(
                                Icons.swap_vert_rounded,
                                size: 18,
                                color: cs.secondary,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: cs.outline)),
                        ],
                      ),
                    ),
                    _FieldLabel(label: 'TO'),
                    const SizedBox(height: 6),
                    StopAutocompleteField(
                      key: ValueKey('dest_${notifier.selectedDestination?.id}'),
                      label: 'Select destination stop',
                      stops: stops,
                      initialValue: notifier.selectedDestination,
                      onSelected: (stop) => notifier.setDestination(stop),
                    ),
                    if (state is ErrorState) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.error_outline, size: 14, color: cs.error),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              state.message,
                              style: TextStyle(
                                color: cs.error,
                                fontSize: 12,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 14),
                    ElevatedButton(
                      onPressed: () => notifier.search(),
                      child: const Text('SEARCH BUSES'),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // ── Results ─────────────────────────────────────────────
            Expanded(
              child: ResultsPanel(state: state, timeCalculator: timeCalculator),
            ),
          ],
        ),
      ),

      // ── FAB: All Buses ───────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const BusListScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(1, 0),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                      child: child,
                    ),
            transitionDuration: const Duration(milliseconds: 350),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        icon: const Icon(Icons.directions_bus_rounded, size: 18),
        label: const Text(
          'ALL BUSES',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}

class _ModeTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final bool selected;
  final VoidCallback onTap;

  const _ModeTab({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.white : const Color(0xFF141414),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? Colors.white : cs.outline),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: selected ? Colors.black : cs.secondary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: selected ? Colors.black : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sublabel,
                    style: TextStyle(
                      fontSize: 10,
                      color: selected
                          ? Colors.black54
                          : const Color(0xFF555555),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 10,
        letterSpacing: 3,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
