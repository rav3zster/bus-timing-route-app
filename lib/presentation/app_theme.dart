import 'package:flutter/material.dart';

// ── AppColors ThemeExtension ─────────────────────────────────────────────────
// Carried in every ThemeData so any widget can read it via
// Theme.of(context).extension<AppColors>()  or  context.appColors

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.bg,
    required this.surface,
    required this.elevated,
    required this.border,
    required this.borderBright,
    required this.text,
    required this.textSub,
    required this.textDim,
    required this.badge,
    required this.accent,
    required this.accentText,
    required this.name,
    required this.emoji,
    this.fontFamily = 'SpaceGrotesk',
  });

  final Color bg;
  final Color surface;
  final Color elevated;
  final Color border;
  final Color borderBright;
  final Color text;       // primary text
  final Color textSub;    // secondary / muted label
  final Color textDim;    // very muted
  final Color badge;      // chip / badge background
  final Color accent;     // highlighted element color
  final Color accentText; // text ON accent background
  final String name;
  final String emoji;
  final String fontFamily;

  @override
  AppColors copyWith({
    Color? bg, Color? surface, Color? elevated, Color? border,
    Color? borderBright, Color? text, Color? textSub, Color? textDim,
    Color? badge, Color? accent, Color? accentText,
    String? name, String? emoji, String? fontFamily,
  }) => AppColors(
    bg: bg ?? this.bg,
    surface: surface ?? this.surface,
    elevated: elevated ?? this.elevated,
    border: border ?? this.border,
    borderBright: borderBright ?? this.borderBright,
    text: text ?? this.text,
    textSub: textSub ?? this.textSub,
    textDim: textDim ?? this.textDim,
    badge: badge ?? this.badge,
    accent: accent ?? this.accent,
    accentText: accentText ?? this.accentText,
    name: name ?? this.name,
    emoji: emoji ?? this.emoji,
    fontFamily: fontFamily ?? this.fontFamily,
  );

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      elevated: Color.lerp(elevated, other.elevated, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderBright: Color.lerp(borderBright, other.borderBright, t)!,
      text: Color.lerp(text, other.text, t)!,
      textSub: Color.lerp(textSub, other.textSub, t)!,
      textDim: Color.lerp(textDim, other.textDim, t)!,
      badge: Color.lerp(badge, other.badge, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentText: Color.lerp(accentText, other.accentText, t)!,
      name: t < 0.5 ? name : other.name,
      emoji: t < 0.5 ? emoji : other.emoji,
      fontFamily: t < 0.5 ? fontFamily : other.fontFamily,
    );
  }
}

// ── BuildContext shortcut ────────────────────────────────────────────────────

extension AppColorsX on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}

// ── 10 Themes ────────────────────────────────────────────────────────────────

const _nothing = AppColors(
  name: 'Nothing',
  emoji: '◯',
  bg: Color(0xFF0A0A0A),
  surface: Color(0xFF111111),
  elevated: Color(0xFF181818),
  border: Color(0xFF242424),
  borderBright: Color(0xFF3A3A3A),
  text: Colors.white,
  textSub: Color(0xFF888888),
  textDim: Color(0xFF444444),
  badge: Color(0xFF2A2A2A),
  accent: Colors.white,
  accentText: Color(0xFF0A0A0A),
);

const _nord = AppColors(
  name: 'Nord',
  emoji: '❄',
  bg: Color(0xFF2E3440),
  surface: Color(0xFF3B4252),
  elevated: Color(0xFF434C5E),
  border: Color(0xFF434C5E),
  borderBright: Color(0xFF606C7A),
  text: Color(0xFFECEFF4),
  textSub: Color(0xFF9099AA),
  textDim: Color(0xFF606C7A),
  badge: Color(0xFF3B4252),
  accent: Color(0xFF88C0D0),
  accentText: Color(0xFF2E3440),
);

const _monokai = AppColors(
  name: 'Monokai',
  emoji: '⚡',
  bg: Color(0xFF272822),
  surface: Color(0xFF2F2E2B),
  elevated: Color(0xFF35342F),
  border: Color(0xFF3E3D39),
  borderBright: Color(0xFF56554E),
  text: Color(0xFFF8F8F2),
  textSub: Color(0xFFA59F85),
  textDim: Color(0xFF6B6353),
  badge: Color(0xFF403E3B),
  accent: Color(0xFFA6E22E),
  accentText: Color(0xFF272822),
);

const _solarized = AppColors(
  name: 'Solarized',
  emoji: '☀',
  bg: Color(0xFF002B36),
  surface: Color(0xFF073642),
  elevated: Color(0xFF0A4050),
  border: Color(0xFF0D4555),
  borderBright: Color(0xFF1B5060),
  text: Color(0xFF93A1A1),
  textSub: Color(0xFF657B83),
  textDim: Color(0xFF2B4C58),
  badge: Color(0xFF073642),
  accent: Color(0xFF2AA198),
  accentText: Color(0xFF002B36),
);

const _dracula = AppColors(
  name: 'Dracula',
  emoji: '🦇',
  bg: Color(0xFF282A36),
  surface: Color(0xFF313341),
  elevated: Color(0xFF3A3C4E),
  border: Color(0xFF404254),
  borderBright: Color(0xFF50527A),
  text: Color(0xFFF8F8F2),
  textSub: Color(0xFF9AA0B8),
  textDim: Color(0xFF6B7193),
  badge: Color(0xFF484A5C),
  accent: Color(0xFFBD93F9),
  accentText: Color(0xFF282A36),
);

const _gruvbox = AppColors(
  name: 'Gruvbox',
  emoji: '🌄',
  bg: Color(0xFF1D2021),
  surface: Color(0xFF282828),
  elevated: Color(0xFF32302F),
  border: Color(0xFF3C3836),
  borderBright: Color(0xFF504945),
  text: Color(0xFFEBDBB2),
  textSub: Color(0xFFA89984),
  textDim: Color(0xFF665C54),
  badge: Color(0xFF32302F),
  accent: Color(0xFFFABD2F),
  accentText: Color(0xFF1D2021),
);

const _tokyoNight = AppColors(
  name: 'Tokyo Night',
  emoji: '🌃',
  bg: Color(0xFF1A1B2E),
  surface: Color(0xFF1F2040),
  elevated: Color(0xFF232446),
  border: Color(0xFF2A2C50),
  borderBright: Color(0xFF3A3D6E),
  text: Color(0xFFC0CAF5),
  textSub: Color(0xFF737AA2),
  textDim: Color(0xFF454878),
  badge: Color(0xFF232440),
  accent: Color(0xFF7AA2F7),
  accentText: Color(0xFF1A1B2E),
);

const _rosePine = AppColors(
  name: 'Rose Pine',
  emoji: '🌹',
  bg: Color(0xFF191724),
  surface: Color(0xFF1F1D2E),
  elevated: Color(0xFF26233A),
  border: Color(0xFF2A2840),
  borderBright: Color(0xFF403D5C),
  text: Color(0xFFE0DEF4),
  textSub: Color(0xFF817C9C),
  textDim: Color(0xFF524F6B),
  badge: Color(0xFF26233A),
  accent: Color(0xFFEBBCBA),
  accentText: Color(0xFF191724),
);

const _ayuDark = AppColors(
  name: 'Ayu Dark',
  emoji: '🏮',
  bg: Color(0xFF0D1017),
  surface: Color(0xFF131720),
  elevated: Color(0xFF171C28),
  border: Color(0xFF1D2433),
  borderBright: Color(0xFF2A3445),
  text: Color(0xFFBFBAB0),
  textSub: Color(0xFF5C6773),
  textDim: Color(0xFF3D4551),
  badge: Color(0xFF131921),
  accent: Color(0xFFE6B450),
  accentText: Color(0xFF0D1017),
);

const _matrix = AppColors(
  name: 'Matrix',
  emoji: '◼',
  fontFamily: 'JetBrainsMono',
  bg: Color(0xFF000000),
  surface: Color(0xFF001100),
  elevated: Color(0xFF001800),
  border: Color(0xFF002200),
  borderBright: Color(0xFF003300),
  text: Color(0xFF00FF41),
  textSub: Color(0xFF009020),
  textDim: Color(0xFF004A18),
  badge: Color(0xFF001500),
  accent: Color(0xFF00FF41),
  accentText: Color(0xFF000000),
);

// ── Light themes ─────────────────────────────────────────────────────────────

const _paper = AppColors(
  name: 'Paper',
  emoji: '○',
  bg: Color(0xFFFAFAFA),
  surface: Color(0xFFF0F0F0),
  elevated: Color(0xFFE8E8E8),
  border: Color(0xFFDDDDDD),
  borderBright: Color(0xFFBBBBBB),
  text: Color(0xFF111111),
  textSub: Color(0xFF666666),
  textDim: Color(0xFFBBBBBB),
  badge: Color(0xFFE3E3E3),
  accent: Color(0xFF111111),
  accentText: Color(0xFFFAFAFA),
);

const _daylight = AppColors(
  name: 'Daylight',
  emoji: '🌤',
  bg: Color(0xFFF5F5F0),
  surface: Color(0xFFEAEAE4),
  elevated: Color(0xFFDFDFD8),
  border: Color(0xFFD0D0C8),
  borderBright: Color(0xFFAAAAAA),
  text: Color(0xFF1A1A2E),
  textSub: Color(0xFF555570),
  textDim: Color(0xFFAAAAAC),
  badge: Color(0xFFE0E0D8),
  accent: Color(0xFF3B5BDB),
  accentText: Color(0xFFF5F5F0),
);

// ── Public theme list ────────────────────────────────────────────────────────

const List<AppColors> kThemes = [
  _nothing,
  _nord,
  _monokai,
  _solarized,
  _dracula,
  _gruvbox,
  _tokyoNight,
  _rosePine,
  _ayuDark,
  _matrix,
  _paper,
  _daylight,
];

// ── Build a full ThemeData from an AppColors ─────────────────────────────────

ThemeData buildThemeData(AppColors c) {
  // Detect if light theme by bg luminance
  final isLight = c.bg.computeLuminance() > 0.5;
  final brightness = isLight ? Brightness.light : Brightness.dark;

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    scaffoldBackgroundColor: c.bg,
    cardColor: c.surface,
    extensions: [c],
    colorScheme: isLight
        ? ColorScheme.light(
            primary: c.accent,
            onPrimary: c.accentText,
            secondary: c.textSub,
            surface: c.surface,
            onSurface: c.text,
            outline: c.border,
          )
        : ColorScheme.dark(
            primary: c.accent,
            onPrimary: c.accentText,
            secondary: c.textSub,
            surface: c.surface,
            onSurface: c.text,
            outline: c.border,
            error: c.text,
          ),
    appBarTheme: AppBarTheme(
      backgroundColor: c.bg,
      elevation: 0,
    ),
    dividerTheme: DividerThemeData(color: c.border, thickness: 1),
    splashColor: Colors.transparent,
    highlightColor: c.surface,
    // Disable ink splash ripple animations for snappier feel
    splashFactory: NoSplash.splashFactory,
  );
}
