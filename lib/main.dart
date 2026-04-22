import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/app_theme.dart';
import 'presentation/providers.dart';
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

class SmartBusApp extends ConsumerWidget {
  const SmartBusApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeIndex = ref.watch(themeIndexProvider);
    final appColors = kThemes[themeIndex];
    final themeData = buildThemeData(appColors);

    return AnimatedTheme(
      data: themeData,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
      child: Builder(
        builder: (ctx) => MaterialApp(
          title: 'Smart Bus Timing & Route Assistant',
          debugShowCheckedModeBanner: false,
          theme: Theme.of(ctx).copyWith(extensions: [appColors]),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
