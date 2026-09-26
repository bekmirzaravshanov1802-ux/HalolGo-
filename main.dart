import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const HalolGoApp());
}

class HalolGoApp extends StatelessWidget {
  const HalolGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HalolGo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF7F8F7),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const LoginScreen(),
      routes: {
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}
