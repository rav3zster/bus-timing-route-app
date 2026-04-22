import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _scale = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
    );
    _ctrl.forward();

    _navTimer = Timer(const Duration(milliseconds: 2600), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (c, a, _) => const HomeScreen(),
            transitionsBuilder: (c, a, _, child) =>
                FadeTransition(opacity: a, child: child),
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: _fade,
        child: ScaleTransition(
          scale: _scale,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dot-ring icon
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CustomPaint(
                    painter: _DotRingPainter(dotColor: const Color(0xFF3A3A3A)),
                    child: Center(
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                          color: Colors.black,
                        ),
                        child: const Icon(
                          Icons.directions_bus_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Title
                Text(
                  'SMART BUS',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 10,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'ROUTE ASSISTANT',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF555555),
                    letterSpacing: 5,
                  ),
                ),

                const SizedBox(height: 56),

                // Dot loader
                const _DotLoader(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Dot ring (Nothing-style) ─────────────────────────────────────────────────

class _DotRingPainter extends CustomPainter {
  final Color dotColor;
  const _DotRingPainter({required this.dotColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    const radius = 46.0;
    const dotCount = 24;
    const dotRadius = 2.0;

    for (int i = 0; i < dotCount; i++) {
      final angle = (i / dotCount) * 2 * math.pi - math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      canvas.drawCircle(Offset(x, y), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ── Dot loader ───────────────────────────────────────────────────────────────

class _DotLoader extends StatefulWidget {
  const _DotLoader();

  @override
  State<_DotLoader> createState() => _DotLoaderState();
}

class _DotLoaderState extends State<_DotLoader>
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
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final active = (_ctrl.value * 5).floor() % 5;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (i) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == active
                    ? Colors.white
                    : const Color(0xFF2A2A2A),
              ),
            );
          }),
        );
      },
    );
  }
}
