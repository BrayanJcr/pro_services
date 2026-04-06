import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pro_services/screens/auth/login_screen.dart';
import 'package:pro_services/screens/auth/onboarding_screen.dart';
import 'package:pro_services/services/error_log_service.dart';

void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();

    // Capturar errores de Flutter (widgets, rendering, etc.)
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details); // muestra en consola
      ErrorLogService.registrar(
        error: details.exceptionAsString(),
        stackTrace: details.stack?.toString(),
        screen: details.library ?? 'unknown',
        action: 'FlutterError',
        level: 'Error',
      );
    };

    runApp(const MyApp());
  }, (error, stack) {
    // Capturar errores de Dart no manejados (async, zones)
    ErrorLogService.registrar(
      error: error.toString(),
      stackTrace: stack.toString(),
      screen: 'ZoneError',
      action: 'UnhandledException',
      level: 'Fatal',
    );
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>()!;

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  bool get isDark => _themeMode == ThemeMode.dark;

  static Future<bool> _checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_done') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pro Services',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: _checkOnboarding(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.data! ? const LoginScreen() : const OnboardingScreen();
        },
      ),
    );
  }
}
