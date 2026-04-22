import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../domain/models.dart';
import '../domain/search_state.dart';
import 'app_theme.dart';
import 'bus_list_screen.dart';
import 'providers.dart';
import 'settings_screen.dart';
import 'widgets/results_panel.dart';
import 'widgets/stop_autocomplete_field.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedMode = 0;

  late AnimationController _entryCtrl;
  late Animation<double> _entryFade;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    )..forward();
    _entryFade = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }


  void _switchMode(int mode) {
    final notifier = ref.read(searchNotifierProvider.notifier);
    setState(() => _selectedMode = mode);
    notifier.resetToIdle();
    _entryCtrl.reset();
    _entryCtrl.forward();
  }

  void _randomizeTheme() {
    final current = ref.read(themeIndexProvider);
    final rng = math.Random();
    int next;
    do {
      next = rng.nextInt(kThemes.length);
    } while (next == current);
    ref.read(themeIndexProvider.notifier).state = next;
  }

  void _openSettings(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (c, a, _) => const SettingsScreen(),
        transitionsBuilder: (c, a, _, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final state = ref.watch(searchNotifierProvider);
    final notifier = ref.read(searchNotifierProvider.notifier);
    // stops is cheap (in-memory list), but we memoize via local variable
    final stops = ref.read(busRepositoryProvider).getAllStops();
    final timeCalc = ref.read(timeCalculatorProvider);

    return Scaffold(
      backgroundColor: c.bg,
      body: FadeTransition(
        opacity: _entryFade,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, c),
              _NDivider(color: c.border),
              const SizedBox(height: 20),
              _buildModeTabs(c),
              const SizedBox(height: 20),
              _NDivider(color: c.border),
              const SizedBox(height: 20),
              if (_selectedMode == 0)
                _buildStopBoardFields(c, notifier, stops, state)
              else
                _buildRouteSearchFields(c, notifier, stops, state),
              const SizedBox(height: 20),
              // RepaintBoundary isolates list repaints from the rest of the tree
              Expanded(
                child: RepaintBoundary(
                  child: ResultsPanel(state: state, timeCalculator: timeCalc),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFab(context, c),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context, AppColors c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Bus icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: c.text, width: 1),
              color: c.bg,
            ),
            child: Icon(Icons.directions_bus_rounded, color: c.text, size: 18),
          ),
          const SizedBox(width: 14),

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SMART BUS',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 10, fontWeight: FontWeight.w500,
                    letterSpacing: 4, color: c.textSub,
                  ),
                ),
                Text(
                  'Route Assistant',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 18, fontWeight: FontWeight.w700,
                    color: c.text, height: 1.2,
                  ),
                ),
              ],
            ),
          ),

          // Action buttons
          Row(
            children: [
              _NIconButton(
                icon: Icons.shuffle_rounded,
                color: c,
                tooltip: 'Random theme',
                onTap: _randomizeTheme,
              ),
              const SizedBox(width: 8),
              _NIconButton(
                icon: Icons.palette_outlined,
                color: c,
                tooltip: 'Theme settings',
                onTap: () => _openSettings(context),
              ),
              const SizedBox(width: 12),
            ],
          ),

          // ⚡ Clock is its own StatefulWidget — only IT repaints every second
          const _LiveClock(),
        ],
      ),
    );
  }

  // ── Mode tabs ────────────────────────────────────────────────────────────────

  Widget _buildModeTabs(AppColors c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _NModeTab(
            label: 'STOP BOARD',
            sublabel: 'Next buses at stop',
            icon: Icons.place_outlined,
            selected: _selectedMode == 0,
            c: c,
            onTap: () => _switchMode(0),
          ),
          const SizedBox(width: 10),
          _NModeTab(
            label: 'ROUTE SEARCH',
            sublabel: 'Find buses between stops',
            icon: Icons.route_outlined,
            selected: _selectedMode == 1,
            c: c,
            onTap: () => _switchMode(1),
          ),
        ],
      ),
    );
  }

  // ── Stop board fields ────────────────────────────────────────────────────────

  Widget _buildStopBoardFields(
    AppColors c, dynamic notifier, List<Stop> stops, SearchState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NLabel('YOUR STOP', c),
          const SizedBox(height: 8),
          StopAutocompleteField(
            key: ValueKey('stopboard_${notifier.selectedSource?.id}'),
            label: 'Select your bus stop',
            stops: stops,
            initialValue: notifier.selectedSource,
            onSelected: (stop) => notifier.setSource(stop),
          ),
        ],
      ),
    );
  }

  // ── Route search fields ──────────────────────────────────────────────────────

  Widget _buildRouteSearchFields(
    AppColors c, dynamic notifier, List<Stop> stops, SearchState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NLabel('FROM', c),
          const SizedBox(height: 8),
          StopAutocompleteField(
            key: ValueKey('source_${notifier.selectedSource?.id}'),
            label: 'Select origin stop',
            stops: stops,
            initialValue: notifier.selectedSource,
            onSelected: (stop) => notifier.setSource(stop),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(child: Container(height: 1, color: c.border)),
                GestureDetector(
                  onTap: () {
                    notifier.swapStops();
                    setState(() {});
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: c.border),
                      color: c.surface,
                    ),
                    child: Icon(
                      Icons.swap_vert_rounded, size: 16, color: c.textSub,
                    ),
                  ),
                ),
                Expanded(child: Container(height: 1, color: c.border)),
              ],
            ),
          ),
          _NLabel('TO', c),
          const SizedBox(height: 8),
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
                Icon(Icons.error_outline, size: 13, color: c.textSub),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    state.message,
                    style: GoogleFonts.spaceGrotesk(
                      color: c.textSub, fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 14),
          // Search button
          GestureDetector(
            onTap: () => notifier.search(),
            child: Container(
              width: double.infinity,
              height: 52,
              color: c.accent,
              child: Center(
                child: Text(
                  'SEARCH BUSES',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12, fontWeight: FontWeight.w700,
                    letterSpacing: 3, color: c.accentText,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── FAB ──────────────────────────────────────────────────────────────────────

  Widget _buildFab(BuildContext context, AppColors c) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (ctx, a, _) => const BusListScreen(),
          transitionsBuilder: (ctx, a, _, child) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0), end: Offset.zero,
            ).animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 350),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        color: c.text,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.directions_bus_rounded, color: c.bg, size: 16),
            const SizedBox(width: 8),
            Text(
              'ALL BUSES',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 11, fontWeight: FontWeight.w700,
                letterSpacing: 2, color: c.bg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared Widgets ────────────────────────────────────────────────────────────

class _NDivider extends StatelessWidget {
  final Color color;
  const _NDivider({required this.color});

  @override
  Widget build(BuildContext context) =>
      Container(height: 1, color: color);
}

class _NLabel extends StatelessWidget {
  final String text;
  final AppColors c;
  const _NLabel(this.text, this.c);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.spaceGrotesk(
        fontSize: 10, fontWeight: FontWeight.w500,
        letterSpacing: 3, color: c.textSub,
      ),
    );
  }
}

class _NIconButton extends StatelessWidget {
  final IconData icon;
  final AppColors color;
  final String tooltip;
  final VoidCallback onTap;

  const _NIconButton({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = color;
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            border: Border.all(color: c.border),
            color: c.surface,
          ),
          child: Icon(icon, size: 16, color: c.textSub),
        ),
      ),
    );
  }
}

class _NModeTab extends StatelessWidget {
  final String label;
  final String sublabel;
  final IconData icon;
  final bool selected;
  final AppColors c;
  final VoidCallback onTap;

  const _NModeTab({
    required this.label,
    required this.sublabel,
    required this.icon,
    required this.selected,
    required this.c,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? c.accent : c.surface,
            border: Border.all(
              color: selected ? c.accent : c.border,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon, size: 16,
                color: selected ? c.accentText : c.textSub,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 10, fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: selected ? c.accentText : c.text,
                      ),
                    ),
                    Text(
                      sublabel,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 9,
                        color: selected ? c.accentText.withValues(alpha: 0.6) : c.textDim,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Isolated clock widget ─────────────────────────────────────────────────────
// Only this widget setState's every second — the rest of the screen is untouched.

class _LiveClock extends StatefulWidget {
  const _LiveClock();

  @override
  State<_LiveClock> createState() => _LiveClockState();
}

class _LiveClockState extends State<_LiveClock> {
  late DateTime _now;
  late final Timer _timer; // initialized explicitly in initState

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    // Start the tick — every second update _now and trigger digit animations
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() => _now = DateTime.now()),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  static const _months = [
    'JAN','FEB','MAR','APR','MAY','JUN',
    'JUL','AUG','SEP','OCT','NOV','DEC',
  ];
  static const _days = ['MON','TUE','WED','THU','FRI','SAT','SUN'];

  // Returns 8-char string: "HH:MM:SS"
  String get _time =>
      '${_now.hour.toString().padLeft(2, '0')}:'
      '${_now.minute.toString().padLeft(2, '0')}:'
      '${_now.second.toString().padLeft(2, '0')}';

  String get _date =>
      '${_days[_now.weekday - 1]}  ${_now.day}  ${_months[_now.month - 1]}';

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final chars = _time.split('');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Each character is its own animated slot keyed by position
        SizedBox(
          height: 28,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (int i = 0; i < chars.length; i++)
                if (chars[i] == ':')
                  _ClockColon(c: c)
                else
                  _AnimatedDigit(
                    key: ValueKey(i),   // stable key by position
                    digit: chars[i],
                    c: c,
                  ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          _date,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 9, color: c.textSub, letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}

// ── Single animated digit ────────────────────────────────────────────────────
// Slides the old digit up & out, rolls the new digit up from below.

class _AnimatedDigit extends StatefulWidget {
  final String digit;
  final AppColors c;

  const _AnimatedDigit({
    super.key,
    required this.digit,
    required this.c,
  });

  @override
  State<_AnimatedDigit> createState() => _AnimatedDigitState();
}

class _AnimatedDigitState extends State<_AnimatedDigit>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  late String _from;
  late String _to;

  static const _kHeight = 26.0;

  @override
  void initState() {
    super.initState();
    _from = widget.digit;
    _to = widget.digit;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.value = 1.0; // already complete at start
  }

  @override
  void didUpdateWidget(_AnimatedDigit old) {
    super.didUpdateWidget(old);
    if (old.digit != widget.digit) {
      _from = old.digit;
      _to = widget.digit;
      _ctrl.reset();
      _ctrl.forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _digit(String d, {required double offsetY, required double opacity}) {
    return Transform.translate(
      offset: Offset(0, offsetY),
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Text(
          d,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: widget.c.text,
            height: 1.3,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        final t = _anim.value;
        return SizedBox(
          width: 13,   // fixed width so digits don't shift layout
          height: _kHeight,
          child: ClipRect(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // Old digit: slides UP and fades out
                _digit(
                  _from,
                  offsetY: -_kHeight * t,
                  opacity: 1 - t,
                ),
                // New digit: slides UP from below and fades in
                _digit(
                  _to,
                  offsetY: _kHeight * (1 - t),
                  opacity: t,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Pulsing colon ────────────────────────────────────────────────────────────

class _ClockColon extends StatefulWidget {
  final AppColors c;
  const _ClockColon({required this.c});

  @override
  State<_ClockColon> createState() => _ClockColonState();
}

class _ClockColonState extends State<_ClockColon>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Opacity(
          opacity: 0.4 + 0.6 * _ctrl.value,
          child: Text(
            ':',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: widget.c.text,
              height: 1.3,
            ),
          ),
        ),
      ),
    );
  }
}
