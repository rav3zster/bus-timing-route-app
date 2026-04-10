import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const ProviderScope(child: SmartBusApp()));
}

class SmartBusApp extends StatelessWidget {
  const SmartBusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Bus Timing & Route Assistant',
      debugShowCheckedModeBanner: false,
      theme: _buildNothingTheme(),
      home: const SplashScreen(),
    );
  }

  ThemeData _buildNothingTheme() {
    const bg = Color(0xFF0A0A0A);
    const surface = Color(0xFF141414);
    const card = Color(0xFF1A1A1A);
    const border = Color(0xFF2A2A2A);
    const white = Colors.white;
    const grey = Color(0xFF888888);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      cardColor: card,
      colorScheme: const ColorScheme.dark(
        primary: white,
        onPrimary: Colors.black,
        secondary: grey,
        surface: surface,
        onSurface: white,
        outline: border,
        error: Color(0xFFFF4444),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        foregroundColor: white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'monospace',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: white,
          letterSpacing: 2,
        ),
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border, width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: white, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF4444)),
        ),
        labelStyle: const TextStyle(color: grey, fontFamily: 'monospace'),
        hintStyle: const TextStyle(color: Color(0xFF444444)),
        prefixIconColor: grey,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: white,
          foregroundColor: Colors.black,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: white,
        labelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 11,
          letterSpacing: 1,
          fontFamily: 'monospace',
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      dividerTheme: const DividerThemeData(color: border, thickness: 1),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: white, fontWeight: FontWeight.w700),
        headlineMedium: TextStyle(color: white, fontWeight: FontWeight.w700),
        headlineSmall: TextStyle(
          color: white,
          fontWeight: FontWeight.w600,
          fontFamily: 'monospace',
          letterSpacing: 2,
        ),
        titleLarge: TextStyle(color: white, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(color: white, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: grey),
        bodyLarge: TextStyle(color: white),
        bodyMedium: TextStyle(color: grey),
        bodySmall: TextStyle(color: Color(0xFF555555)),
        labelLarge: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontFamily: 'monospace',
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
