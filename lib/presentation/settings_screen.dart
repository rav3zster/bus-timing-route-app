import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_theme.dart';
import 'providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final currentIndex = ref.watch(themeIndexProvider);

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────
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
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        size: 16,
                        color: c.textSub,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'APPEARANCE',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 4,
                          color: c.textSub,
                        ),
                      ),
                      Text(
                        'Theme',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: c.text,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Current theme badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: c.accent,
                    ),
                    child: Text(
                      '${kThemes[currentIndex].emoji}  ${kThemes[currentIndex].name}',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: c.accentText,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(height: 1, color: c.border),
            const SizedBox(height: 4),

            // ── Section label ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Text(
                'SELECT THEME',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 3,
                  color: c.textSub,
                ),
              ),
            ),

            // ── Theme grid ───────────────────────────────────────────
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                itemCount: kThemes.length,
                itemBuilder: (context, index) {
                  final theme = kThemes[index];
                  final isSelected = index == currentIndex;

                  return _ThemeCard(
                    theme: theme,
                    isSelected: isSelected,
                    onTap: () {
                      ref.read(themeIndexProvider.notifier).state = index;
                    },
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

// ── Theme card ───────────────────────────────────────────────────────────────

class _ThemeCard extends StatelessWidget {
  final AppColors theme;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeCard({
    required this.theme,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? c.surface : c.bg,
          border: Border.all(
            color: isSelected ? c.accent : c.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Color swatches preview
            _ColorSwatchRow(theme: theme),

            const SizedBox(width: 16),

            // Name + description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${theme.emoji}  ${theme.name}',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? c.accent : c.text,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _MiniSwatch(color: theme.bg, label: 'BG'),
                      const SizedBox(width: 6),
                      _MiniSwatch(color: theme.surface, label: 'SURF'),
                      const SizedBox(width: 6),
                      _MiniSwatch(color: theme.accent, label: 'ACC'),
                    ],
                  ),
                ],
              ),
            ),

            // Checkmark
            AnimatedOpacity(
              opacity: isSelected ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: c.accent,
                ),
                child: Icon(
                  Icons.check,
                  size: 14,
                  color: c.accentText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorSwatchRow extends StatelessWidget {
  final AppColors theme;
  const _ColorSwatchRow({required this.theme});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox(
        width: 56,
        height: 42,
        child: Stack(
          children: [
            // Background
            Container(color: theme.bg),
            // Surface strip top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 14,
              child: Container(color: theme.surface),
            ),
            // Accent dot
            Positioned(
              bottom: 6,
              right: 6,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: theme.accent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Border
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: theme.border, width: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniSwatch extends StatelessWidget {
  final Color color;
  final String label;
  const _MiniSwatch({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: c.border, width: 0.5),
          ),
        ),
        const SizedBox(width: 3),
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 8,
            color: c.textDim,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
