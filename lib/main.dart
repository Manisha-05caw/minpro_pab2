import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/theme_provider.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Langsung hardcode — ganti dengan URL & KEY milikmu
  await Supabase.initialize(
    url: 'https://tbxzbtzkhpcboagvxcxg.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRieHpidHpraHBjYm9hZ3Z4Y3hnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM1NTgxMzAsImV4cCI6MjA4OTEzNDEzMH0.mn8Q3CcZyGFi7-jmPFhkEaJQIzPKpEtinOFj7_jjRq0',
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const HealthRecordApp(),
    ),
  );
}

class HealthRecordApp extends StatelessWidget {
  const HealthRecordApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      title: 'HealthRecord',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const SplashScreen(),
    );
  }
}
